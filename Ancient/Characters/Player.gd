extends KinematicBody2D


var speed = 800
var velocity = Vector2.ZERO
var gravity = 1000
var jumpforce = 0
var jump_max = -2000
var is_falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	input()
	fall_detection()
	apply_jump()
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func fall_detection():
	if not is_on_floor() and not is_falling:
		is_falling = true
		$JumpAffordance.stop()
		$JumpAffordance.start()
	elif is_on_floor():
		is_falling = false
func input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed("move_up"):
		initiate_jump()
	if Input.is_action_pressed("move_down"):
		#velocity.y += 1
		pass

func apply_gravity(delta):
	velocity.y += gravity + delta

func initiate_jump():
	if (not is_on_floor() and $JumpAffordance.time_left == 0) or $JumpTimeout.time_left != 0:
		return
	$JumpStepDown.stop()
	$JumpTimeout.start()

func apply_jump():
	if $JumpTimeout.time_left > 0 and $JumpTimeout.time_left > 0.15:
		jumpforce = jump_max
	elif not Input.is_action_pressed("move_up") and jumpforce != 0 and $JumpStepDown.time_left == 0:
		$JumpStepDown.start()
	velocity.y = jumpforce


func _on_JumpTimeout_timeout():
	$JumpTimeout.stop()
	if $JumpStepDown.time_left == 0:
		$JumpStepDown.start()


func _on_JumpStepDown_timeout():
	jumpforce = jumpforce / 2
	if jumpforce < 0:
		$JumpStepDown.start()
	else:
		$JumpStepDown.stop()


func _on_JumpAffordance_timeout():
	$JumpAffordance.stop()
