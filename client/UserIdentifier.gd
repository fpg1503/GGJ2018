const uuid = preload("res://uuid.gd")

static func get_unique_id():
	var os_unique_id = OS.get_unique_id().strip_edges()
	if not os_unique_id.empty():
		return os_unique_id
	# Fallback to generating ID and saving it locally!
	var persisted = _get_persisted()
	print('Persisted data is: ' + str(persisted))
	if persisted and not persisted.empty():
		return persisted
	var new_id = uuid.v4()
	_persist(new_id)
	return new_id

static func _get_persisted():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		print('Opened file')
		var id = config.get_value("user", "id")
		return id

static func _persist(id):
	print('Persisting id: ' + str(id))
	var config = ConfigFile.new()
	config.set_value("user", "id", id)
	config.save("user://settings.cfg")
	print('Saved!')	