extends Node

const BidirectionalDictionary = preload('res://RestClient/BidirectionalDictionary.gd')
const Cancelable = preload('res://RestClient/Cancelable.gd')
const Request = preload('res://RestClient/Request.gd')
const UUID = preload('res://RestClient/UUID.gd')

var _http_clients = []
var _http_client_pool = []
var _request_queue = []
var _http_clients_in_use = []

var _ongoing_requests = BidirectionalDictionary.new()
var _enqueued_requests = BidirectionalDictionary.new()

signal request_completed

func _init(pool_size = 5):
	for i in range(pool_size):
		var client = HTTPRequest.new()
		_http_client_pool.append(client)
		_http_clients.append(client)

func _ready():
	for index in range(_http_client_pool.size()):
		var client = _http_client_pool[index]
		add_child(client)
		client.connect('request_completed', self, '_request_completed', [index])

func get(url, headers = {}):
	return _generic_request(HTTPClient.METHOD_GET, url, headers)
	
func post(url, json_body, headers = {}):
	var stringified_body = to_json(json_body)
	var modified_headers = headers
	if !_has_header_field(modified_headers, 'Content-Type'):
		modified_headers['Content-Type'] = 'application/json'
	return _generic_request(HTTPClient.METHOD_POST, url, modified_headers, stringified_body)
	
func cancel(uuid):
	if _ongoing_requests.has(uuid):
		var client = _ongoing_requests.get(uuid)
		_ongoing_requests.erase(uuid)
		client.cancel_request()
		print('Ongoing request cancelled')
		_add_client_to_pool_and_dequeue_requests(client)
	elif _enqueued_requests.has(uuid):
		var request = _enqueued_requests.get(uuid)
		_enqueued_requests.erase(uuid)
		_request_queue.erase(request)
		print('Enqueued request cancelled')
	else:
		print('Request not found, it\'s probably already finished')
	
func _has_header_field(headers, field):
	var lowered_field = field.to_lower()
	var fields = headers.keys()
	for present_field in fields:
		if present_field.to_lower == lowered_field:
			return true
	return false
	
func _stringify_headers(headers):
	var keys = headers.keys()
	var stringified = []
	for key in keys:
		stringified.append(str(key) + ': ' + str(headers[key]))
	return stringified

func _generic_request(method, url, headers, body = ''):
	var stringified_headers = _stringify_headers(headers)
	var uuid = UUID.v4()
	var client = _pop_client()
	if client:
		client.request(url, stringified_headers, true, method, body)
		_ongoing_requests.set(uuid, client)
	else:
		var request = Request.new(method, url, body, stringified_headers)
		_request_queue.append(request)
		_enqueued_requests.set(uuid, request)
		print('No free clients. Enqueueing request, queue size is ' + str(_request_queue.size()))
	return Cancelable.new(uuid, self)

func _pop_client():
	if _http_client_pool.size() > 0:
		var client = _http_client_pool[0]
		_http_client_pool.pop_front()
		_http_clients_in_use.append(client)
		print('Popped client, ' + str(_http_client_pool.size()) + ' left')
		return client
	else:
		return null

func _process_enqueued_requests_if_possible():
	for request in _request_queue:
		var client = _pop_client()
		if client:
			client.request(request.url, request.headers, true, request.method, request.body)
			_request_queue.erase(request)
			var uuid = _enqueued_requests.get_key_from_value(request)
			_enqueued_requests.erase(uuid)
			_ongoing_requests.set(uuid, client)
			print('Processing enqueued request, queue size is ' + str(_request_queue.size()))

func _add_client_to_pool_and_dequeue_requests(client):
	if client.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
		_http_clients_in_use.erase(client)
		_http_client_pool.append(client)
		if client in _ongoing_requests:
			_ongoing_requests.erase_value(client)
		print('Pushed client, ' + str(_http_client_pool.size()) + ' left')
	else:
		print('Invalid client status!')
	_process_enqueued_requests_if_possible()

func _request_completed(result_code, response_code, headers, body, index):
	var client = _http_clients[index]
	var id = _ongoing_requests.get_key_from_value(client)
	_add_client_to_pool_and_dequeue_requests(client)
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse(json_string)
	var error = json.error
	var result = json.result
	emit_signal('request_completed', id, error, result_code, response_code, headers, result)