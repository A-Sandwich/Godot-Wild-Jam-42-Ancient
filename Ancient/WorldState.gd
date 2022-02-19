extends Node

var original_location = Vector2.ZERO
var deaths = []
var current_life = []
var ghosts = []
var play_attempts = false
var player_ghost = load("res://Characters/PlayerGhost.tscn")
var frames_replayed = 0
var time_since_last_update = 0.0
signal win

func _physics_process(delta):
	time_since_last_update += delta
	if not play_attempts or time_since_last_update <= 0.0166:
		return
	time_since_last_update = 0.0
	for ghost_index in range(ghosts.size()):
		if deaths.size() <= ghost_index:
			#This shouldn't happen
			continue
		if deaths[ghost_index].size() > frames_replayed:
			ghosts[ghost_index].global_position = deaths[ghost_index][frames_replayed]
	frames_replayed = frames_replayed + 1
	
func append_position(global_position):
	current_life.append(global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func lose():
	var copy = current_life.duplicate(true)
	deaths.append(copy)
	current_life.clear()


func win():
	emit_signal("win")
	var copy = current_life.duplicate(true)
	deaths.append(copy)
	current_life.clear()
	for attempt in deaths:
		if attempt.size() == 0:
			#This shouldn't happen
			print("array contained zero positions")
		var ghost = player_ghost.instance()
		ghost.global_position = attempt[0]
		ghosts.append(ghost)
		add_child(ghost)
	play_attempts = true
	print("WINNER")

func get_level_center():
	return Vector2(100, 100)
