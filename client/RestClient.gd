extends Node

var _http_client = HTTPRequest.new()

signal request_completed

func _ready():
	add_child(_http_client)
	_http_client.connect('request_completed', self, '_request_completed')

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
	return _http_client.request(url, stringified_headers, true, method, body)
	

func _request_completed(result_code, response_code, headers, body):
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse(json_string)
	var error = json.error
	var result = json.result
	emit_signal('request_completed', error, result_code, response_code, headers, result)