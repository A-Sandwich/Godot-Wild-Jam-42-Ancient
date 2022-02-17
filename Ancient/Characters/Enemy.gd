extends KinematicBody2D


var speed = 80
var velocity = Vector2(1, 0)
var gravity = 1000
var jumpforce = 0
var jump_max = -2000
var is_falling = false
var ray_cast_distance = 150
var x = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_line(Vector2(0, 0), Vector2(ray_cast_distance*x,ray_cast_distance), Color(255, 0, 0), 10)

func _physics_process(delta):
	velocity = Vector2(x,0)
	avoid_fall()
	apply_gravity(delta)
	move_and_slide(velocity * speed, Vector2.UP)

func avoid_fall():
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var result = space_state.intersect_ray(Vector2(global_position.x, global_position.y), Vector2(global_position.x+ray_cast_distance*x, global_position.y+ray_cast_distance), [self, $CollisionShape2D])
	if not result:
		$Sprite.flip_h = not $Sprite.flip_h
		update()
		x = x * -1
		velocity.x = x

func fall_detection():
	if not is_on_floor() and not is_falling:
		is_falling = true
	elif is_on_floor():
		is_falling = false

func apply_gravity(delta):
	velocity.y += gravity * delta

