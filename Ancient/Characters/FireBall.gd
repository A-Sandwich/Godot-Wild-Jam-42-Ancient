extends Area2D

var speed = 200
var original = 0.125
var size = 0.25
var time_since_last_scale = 0.0
var time_to_scale = 0.032
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(direction, 0) * speed * delta
	original = original + 0.05
	
	time_since_last_scale += delta
	if time_since_last_scale > time_to_scale:
		$CollisionShape2D.scale.x += 0.05
		$CollisionShape2D.scale.y += 0.05
		$Sprite.scale.x += 0.05
		$Sprite.scale.y += 0.05
		time_since_last_scale = 0.0
	


func _on_FireBall_body_entered(body):
	pass # Replace with function body.
