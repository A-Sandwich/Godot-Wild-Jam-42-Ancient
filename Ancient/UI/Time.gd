extends Label

var time_passed = 0.0
var track_time = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if track_time:
		time_passed += delta
		var minutes = time_passed / 60
		var seconds = time_passed % 60
		var string = str(time_passed) + ":" + str(seconds)
		

func start():
	time_passed = 0.0
