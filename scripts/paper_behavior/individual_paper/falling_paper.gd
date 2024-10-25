extends Node2D

var rng = RandomNumberGenerator.new()

var gravity = 0.5
var rotspeed
var velocity

func _ready() -> void:
	rng.randomize()
	
	position.x = rng.randf_range(-256, 256)
	
	$Sprite.rotation_degrees = rng.randf_range(0, 360)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees
	
	rotspeed = rng.randf_range(-0.5, 0.5)
	velocity = rng.randf_range(-0.2, 0.2)

func _process(delta: float) -> void:
	position += Vector2(velocity, gravity)
	gravity += 0.1
	
	$Sprite.rotation_degrees += rotspeed
	$Shadow.rotation_degrees += rotspeed

func _on_kill_timer_timeout() -> void:
	queue_free()
