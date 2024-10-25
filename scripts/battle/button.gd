extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	setup()

func setup():
	rng.randomize()
	
	$Sprite.frame = rng.randi_range(0, 7)
	$Shadow.frame = $Sprite.frame
	
	$Sprite.rotation_degrees = rng.randf_range(-5, 5)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees
	
	$Sprite/Label.text = name
