extends Node

var url = 'http://ggj2018.eastus.cloudapp.azure.com'
var client = HTTPRequest.new()

func _ready():
	print('oieee')
	add_child(client)
	client.connect('request_completed', self, 'request_completed')
	var result = client.request(url)	
	print('result: ' + str(result))
	
func request_completed(result, response_code, headers, body):
	print('request completed')
	print(result)
	print(response_code)
	print(headers)
	var json_string = body.get_string_from_utf8()
	var json = JSON.parse(json_string)
	print(json.result)
	emit_signal('response', json.result)