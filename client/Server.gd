extends Node

var prod_base = 'http://ggj2018.eastus.cloudapp.azure.com'
var local_base = 'http://localhost:3000'
var is_prod = true
var base_url = prod_base if is_prod else local_base
var client = HTTPRequest.new()

var _last_request = null

signal levels
signal level_fetched
signal level_saved

enum Action {
	GET_LEVELS,
	GET_LEVEL_INFO,
	SAVE_LEVEL
}

func _ready():
	add_child(client)
	client.connect('request_completed', self, 'request_completed')
	
func fetch_levels():
	var url = base_url + '/levels'
	_last_request = GET_LEVELS
	return client.request(url)
	
func fetch_level(level):
	var url = base_url + '/levels/' + str(level)
	_last_request = GET_LEVEL_INFO
	return client.request(url)
	
func save_level(level, map):
	var url = base_url + '/levels/' + str(level)
	var body = to_json(map)
	print(body)
	_last_request = SAVE_LEVEL
	return client.request(url, ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, body)
	
func request_completed(result_code, response_code, headers, body):
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse(json_string)
	var result = json.result
	if _last_request == GET_LEVELS:
		if result:
			emit_signal('levels', result)
		else:
			# TODO: Handle errors!
			pass
	elif _last_request == GET_LEVEL_INFO:
		if result:
			var level = result['level']
			var map = result['map']
			emit_signal('level_fetched', level, map)
		else:
			# TODO: Handle errors!
			pass
	elif _last_request == SAVE_LEVEL:
		if result:
			emit_signal('level_saved')
		else:
			# TODO: Handle errors!
			pass