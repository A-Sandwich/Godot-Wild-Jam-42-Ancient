extends Node2D


var rng = RandomNumberGenerator.new()
var stegosaurus = load("res://Characters/Stegosaurus.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for lorp in range(100):
		var spikey_boi = stegosaurus.instance()
		var x = rng.randi_range(46, 1200)
		spikey_boi.global_position = Vector2(x, -600)
		
		add_child(spikey_boi)
