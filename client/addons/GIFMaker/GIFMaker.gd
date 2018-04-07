tool
# Intern initializations
extends ReferenceRect # Extends from ReferenceRect

# Export variables!
const RECORD_KEY = KEY_R # Change this to the key you want to start/stop recording the gif.
export(float) var frames_per_second = 1.0
export(String) var output_folder = "out"

# Intern variables
onready var _frametick = 1.0/frames_per_second
#onready var _just_got_image = false
onready var _images = []
onready var _running = false
onready var _viewport = get_viewport()

# ======================================================

func _ready():
	set_process(true)
	set_process_input(true)
	pass

func _input(event):
	if event is InputEventKey and event.pressed and !event.echo:
		if event.scancode == RECORD_KEY:
			_running = !_running
			if (!_running): # It was running before
				create_gif()

func _process(delta):
	# Get images
	if _running:
		_frametick += delta
		if (_frametick > 1.0/frames_per_second):
			_frametick -= 1.0/frames_per_second
			# Let two frames pass to make sure the screen was captured
			_viewport.queue_screen_capture()
			print("New image!")
			# Retrieve the captured image
			var img = _viewport.get_screen_capture()
			# Create a texture for it
			var frame = self
			var new_img = Image(frame.get_size().width,frame.get_size().height,false,img.get_format())
			new_img.blit_rect(img,frame.get_rect(),Vector2(0,0))
			_images.append(new_img)


func create_gif():
	var dir = Directory.new()
	dir.make_dir(output_folder)
	if dir.open("res://" + output_folder + "/") != OK:
		print("An error occurred when trying to create the output folder.")
	
	var i = 0
	for image in _images:
		image.save_png("res://" + str(output_folder) + "/" + "%03d" % i + ".png")
		i+=1