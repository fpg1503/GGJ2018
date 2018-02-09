extends Node

var RestClient = preload("res://RestClient/RestClient.gd")

var is_prod = true

var prod_base = 'http://ggj2018.eastus.cloudapp.azure.com'
var local_base = 'http://localhost:3000'
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
	return client.get(url)
	
func fetch_level(level, user):
	var url = base_url + '/levels/' + str(level) + '?userName=' + str(user)
	_last_request = GET_LEVEL_INFO
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
	
func request_completed(id, error, result_code, response_code, headers, result):
	print('Response from ' + id)
	if _last_request == GET_LEVELS:
		emit_signal('levels', error, result)
	elif _last_request == GET_LEVEL_INFO:
		# TODO: Handle malformed JSON responses!
		emit_signal('level_fetched', error, result.level, result.map, result._id)
	elif _last_request == SAVE_LEVEL:
		emit_signal('level_saved', error)