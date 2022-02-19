extends CanvasLayer

var seconds_passed = 0.0
var track_time = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/WorldState".connect("win", self, "_on_win")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if track_time:
		seconds_passed += delta
		var minutes = int(seconds_passed / 60)
		var seconds = int(seconds_passed - (minutes * 60))
		var str_seconds = str(seconds)
		if seconds < 10:
			str_seconds = "0"+str_seconds
		var milliseconds = int((seconds_passed - (minutes * 60) - seconds) * 100)
		var str_milliseconds = str(milliseconds)
		if milliseconds < 10:
			str_milliseconds += "0"
		var time = str(minutes) + ":" + str_seconds + ":" + str_milliseconds
		$Time.text = time

func start():
	track_time = true
	seconds_passed = 0.0

func stop():
	track_time = false

func _on_win():
	win()

func win():
	track_time = false
	$Win.visible = true