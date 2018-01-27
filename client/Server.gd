extends Node

var RestClient = preload("res://RestClient.gd")

var prod_base = 'http://ggj2018.eastus.cloudapp.azure.com'
var local_base = 'http://localhost:3000'
var is_prod = false
var base_url = prod_base if is_prod else local_base
var client = RestClient.new()

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
	client._stringify_headers({"Content-Type": "application/json"})
	return client.get(url)
	
func save_level(level, map, user, parent):
	var url = base_url + '/levels/' + str(level)
	_last_request = SAVE_LEVEL
	var body = {
		'map': map,
		'parentId': parent,
		'userName': user
	}
	return client.post(url, body)
	
func request_completed(error, result_code, response_code, headers, result):
	if _last_request == GET_LEVELS:
		if result:
			emit_signal('levels', result)
		else:
			# TODO: Handle errors!
			pass
	elif _last_request == GET_LEVEL_INFO:
		if result:
			emit_signal('level_fetched', result.level, result.map, result._id)
		else:
			# TODO: Handle errors!
			pass
	elif _last_request == SAVE_LEVEL:
		if result:
			emit_signal('level_saved')
		else:
			# TODO: Handle errors!
			pass