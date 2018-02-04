extends Node

var Request = preload("res://Request.gd")

var _http_client_pool = []
var _request_queue = []
var _http_clients_in_use = []

signal request_completed

func _init(pool_size = 5):
	for i in range(pool_size):
		_http_client_pool.append(HTTPRequest.new())

func _ready():
	for client in _http_client_pool:
		add_child(client)
		client.connect('request_completed', self, '_request_completed')

func get(url, headers = {}):
	return _generic_request(HTTPClient.METHOD_GET, url, headers)
	
func post(url, json_body, headers = {}):
	var stringified_body = to_json(json_body)
	var modified_headers = headers
	if !_has_header_field(modified_headers, 'Content-Type'):
		modified_headers['Content-Type'] = 'application/json'
	return _generic_request(HTTPClient.METHOD_POST, url, modified_headers, stringified_body)
	
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
	if _http_client_pool.size() > 0:
		var client = _http_client_pool[0]
		_http_client_pool.pop_front()
		client.request(url, stringified_headers, true, method, body)
	else:
		var request = Request.new(method, url, body, stringified_headers)
		_request_queue.append(request)
	
func _add_clients_to_pool():
	for client in _http_clients_in_use:
		if client.get_http_client_status == HTTPClient.STATUS_DISCONNECTED:
			_http_clients_in_use.erase(client)
			_http_client_pool.append(client)

func _process_enqueued_requests_if_possible():
	for request in _request_queue:
		if _http_client_pool.size() > 0:
			var client = _http_client_pool[0]
			_http_client_pool.pop_front()
			client.request(request.url, request.headers, true, request.method, request.body)
			_request_queue.erase(request)

func _add_clients_to_pool_and_dequeue_requests():
	_add_clients_to_pool()
	_process_enqueued_requests_if_possible()


func _request_completed(result_code, response_code, headers, body):
	_add_clients_to_pool_and_dequeue_requests()
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse(json_string)
	var error = json.error
	var result = json.result
	emit_signal('request_completed', error, result_code, response_code, headers, result)