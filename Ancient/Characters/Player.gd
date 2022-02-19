extends KinematicBody2D


var speed = 800
var velocity = Vector2.ZERO
var gravity = 1000
var jumpforce = 0
var jump_max = -2000
var is_falling = false
var original_position = Vector2.ZERO
var time_since_last_save = 0.0
var pause_player = true
var is_panning = false
var goal
var fire_ball = load("res://Characters/FireBall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/WorldState".connect("win", self, "_on_win")
	original_position = global_position
	$PanCamera.make_current()
	goal = get_goal()
	connect_to_enemies()
	finish_pan()

func connect_to_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.connect("die", self, "_on_die") 

func get_goal():
	goal = get_tree().get_nodes_in_group("goal")
	if goal.size() > 0:
		return goal[0]

func pan_to_goal(delta):
	if not is_panning:
		return
	if goal == null:
		goal = get_goal()
	if $PanCamera.global_position == goal.global_position:
		finish_pan()
	$PanCamera.global_position = $PanCamera.global_position.move_toward(goal.global_position, 7.5) 

func finish_pan():
	is_panning = false
	$Camera2D.make_current()
	$HUD.start()
	pause_player = false
	

func _physics_process(delta):
	pan_to_goal(delta)
	
	if pause_player:
		return
	input()
	fall_detection()
	apply_jump()
	apply_gravity(delta)
	var current_location = global_position
	velocity = move_and_slide(velocity, Vector2.UP)
	collision_detection()
	time_since_last_save += delta
	if time_since_last_save > 0.01666:
		time_since_last_save = 0.0
		$"/root/WorldState".append_position(global_position)

func collision_detection():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Enemy" in collision.collider.name:
			_on_die()

func fall_detection():
	if not is_on_floor() and not is_falling:
		$Respawn.start()
		is_falling = true
		$JumpAffordance.stop()
		$JumpAffordance.start()
	elif is_on_floor():
		$Respawn.stop()
		is_falling = false

func input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite.flip_h = false
		velocity.x += 1
	
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed("move_up"):
		initiate_jump()
	
	if Input.is_action_just_pressed("FireBall"):
		$AnimatedSprite.play("fireball")
		shoot_fireball()
		return
	
	if $AnimatedSprite.is_playing():
		return
	if velocity.x != 0:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.stop()

func apply_gravity(delta):
	velocity.y += gravity + delta

func initiate_jump():
	if (not is_on_floor() and $JumpAffordance.time_left == 0) or $JumpTimeout.time_left != 0:
		return
	$JumpStepDown.stop()
	$JumpTimeout.start()

func apply_jump():
	if is_on_ceiling():
		$JumpTimeout.stop()
		$JumpStepDown.stop()
		jumpforce = 0
		return
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


func _on_Respawn_timeout():
	if pause_player:
		return
	$"/root/WorldState".lose()
	global_position = original_position

func _on_win():
	pause_player = true
	$WinView.global_position = Vector2((original_position.x + global_position.x)/2, (original_position.y + global_position.y)/2)
	$Camera2D.current = false
	$WinView.current = true
	visible = false
	
func _on_die():
	global_position = original_position
	$"/root/WorldState".lose()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "fireball":
		$AnimatedSprite.stop()


func shoot_fireball():
	var fb = fire_ball.instance()
	get_parent().add_child(fb)
	if $AnimatedSprite.flip_h:
		fb.direction = -1
	fb.global_position = Vector2(global_position.x + (30 * fb.direction), global_position.y - 10)
