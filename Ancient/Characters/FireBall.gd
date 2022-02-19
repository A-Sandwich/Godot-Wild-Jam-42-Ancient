extends Area2D

var speed = 200
var original = 0.125
var size = 2.5
var time_since_last_scale = 0.0
var time_to_scale = 0.032
var direction = 1
var hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Sprite.scale.x <= 0:
		self.queue_free()
	if hit:
		change_scale_by(-0.15)
		return
	position += Vector2(direction, 0) * speed * delta
	original = original + 0.05
	if $CollisionShape2D.scale.x > size:
		return
	time_since_last_scale += delta
	if time_since_last_scale > time_to_scale:
		change_scale_by(0.05)
		time_since_last_scale = 0.0

func change_scale_by(delta):
	$CollisionShape2D.scale.x += delta
	$CollisionShape2D.scale.y += delta
	$Sprite.scale.x += delta
	$Sprite.scale.y += delta


func _on_FireBall_body_entered(body):
	print(body.name)
	if body.name == "Player":
		return
	if "Enemy" in body.name:
		body.die()
	hit = true
