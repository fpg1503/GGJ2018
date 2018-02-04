extends Object

var method
var url
var body
var headers

func _init(method, url, body, headers):
	self.method = method
	self.url = url
	self.body = body
	self.headers = headers