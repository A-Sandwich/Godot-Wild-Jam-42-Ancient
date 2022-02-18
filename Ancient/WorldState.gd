extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func lose():
	get_tree().paused = true

func win():
	print("WINNER")
