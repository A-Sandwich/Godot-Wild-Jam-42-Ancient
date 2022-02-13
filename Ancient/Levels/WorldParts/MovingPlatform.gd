extends KinematicBody2D


var original_position = Vector2.ZERO
var direction = 1
var speed = 100
var distance = 500
var target_position = original_position

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = global_position
	target_position = original_position
	target_position.x = target_position.x + 5000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var diff = global_position.x + original_position.x
	if diff > (original_position.x + distance) or diff < (original_position.x - distance):
		direction = direction * -1
		target_position.x = global_position.x + distance * direction
	var pos = global_position
	global_position.x += direction * speed * delta
	update()
