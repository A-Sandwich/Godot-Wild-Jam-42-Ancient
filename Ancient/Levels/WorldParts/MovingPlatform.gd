extends KinematicBody2D


var original_position = Vector2.ZERO
var direction = 1
var speed = 250
var distance = 500
var target_position = original_position
var rng = RandomNumberGenerator.new()
var prev_distance_to = 99999999999
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	direction = 1 if rng.randi_range(0,1) == 1 else -1
	var speed_modifier = rng.randi_range(-100, 100)
	speed += speed_modifier
	original_position = global_position
	target_position = original_position
	var distance_modifier = rng.randi_range(400, 800) * direction
	target_position.x = target_position.x + distance_modifier
	print(name, global_position, target_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var distance = global_position.distance_to(target_position)

	if distance > prev_distance_to:
		direction = direction * -1
		var temp = target_position.x
		target_position.x = original_position.x
		original_position.x = temp
		prev_distance_to = 99999999999
		return
	prev_distance_to = distance
	global_position.x += direction * speed * delta
	update()
