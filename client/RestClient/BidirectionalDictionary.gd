extends Object

var _key_to_value = {}
var _value_to_key = {}

func clear():
	_key_to_value.clear()
	_value_to_key.clear()

func empty():
	return _key_to_value.empty()

func erase(key):
	var value = _key_to_value[key]
	_key_to_value.erase(key)
	_value_to_key.erase(value)

func has(key):
	return _key_to_value.has(key)

func has_value(value):
	return _value_to_key.has(value)
	
func has_all(keys):
	return _key_to_value.has_all(keys)

func has_all_values(values):
	return _value_to_key.has_all(values)
	
func hash():
	return _key_to_value.hash()

func keys():
	return _key_to_value.keys()

func values():
	return _value_to_key.keys()
	
func size():
	return _key_to_value.size()
	
func get(key):
	return _key_to_value[key]

func set(key, value):
	_key_to_value[key] = value
	_value_to_key[value] = key

func get_key_from_value(value):
	return _value_to_key[value]