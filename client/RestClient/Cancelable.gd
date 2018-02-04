extends Object

var _uuid
var _rest_client

func _init(uuid, rest_client):
	_uuid = uuid
	_rest_client = rest_client
	
func cancel():
	_rest_client.cancel(_uuid)