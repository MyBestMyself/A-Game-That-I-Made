extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	
	$Sprite.rotation_degrees = rng.randf_range(0, 360)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees
	position = Vector2(rng.randi_range(-1000,1000) , rng.randi_range(-1000, 1000))
