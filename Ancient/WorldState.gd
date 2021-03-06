extends Node

var original_location = Vector2.ZERO
var deaths = []
var current_life = []
var ghosts = []
var play_attempts = false
var player_ghost = load("res://Characters/PlayerGhost.tscn")
var frames_replayed = 0
var time_since_last_update = 0.0
var levels = ["res://Levels/Level1.tscn", "res://Levels/Level2.tscn", "res://Levels/Level3.tscn", "res://Levels/Level4.tscn"]
var level_index = 0
var total_time = 0.0
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
		else:
			ghosts[ghost_index].visible = false
	frames_replayed = frames_replayed + 1
	
func append_position(global_position):
	current_life.append(global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func lose():
	reset_current_life()


func reset_current_life():
	if current_life.size() == 0:
		return
	var copy = current_life.duplicate(true)
	deaths.append(copy)
	current_life.clear()

func win():
	emit_signal("win")
	reset_current_life()
	for attempt in deaths:
		if attempt.size() == 0:
			#This shouldn't happen
			print("array contained zero positions")
			continue
		var ghost = player_ghost.instance()
		ghost.global_position = attempt[0]
		ghosts.append(ghost)
		add_child(ghost)
	frames_replayed = 0
	play_attempts = true
	print("WINNER")

func get_level_center():
	return Vector2(100, 100)

func reset_replay_data():
	deaths.clear()
	current_life.clear()
	ghosts.clear()
	frames_replayed = 0

func has_next_level():
	return (level_index + 1) < levels.size()

func load_next_level():
	for ghost in ghosts:
		ghost.queue_free()
	ghosts.clear()
	reset_replay_data()
	level_index += 1
	if level_index >= levels.size():
		return
	var level = levels[level_index]
	
	get_tree().change_scene(level)

func format_time():
	var minutes = int(total_time / 60)
	var seconds = int(total_time - (minutes * 60))
	var str_seconds = str(seconds)
	if seconds < 10:
		str_seconds = "0"+str_seconds
	var milliseconds = int((total_time - (minutes * 60) - seconds) * 100)
	var str_milliseconds = str(milliseconds)
	if milliseconds < 10:
		str_milliseconds += "0"
	var time = str(minutes) + ":" + str_seconds + ":" + str_milliseconds
	return time
