extends Node2D

var rng = RandomNumberGenerator.new()

var gravity
var rotspeed
var velocity

func _ready() -> void:
	rng.randomize()
	
	position.x = rng.randf_range(-256, 256)
	
	gravity = rng.randf_range(-0.5, -0.25)
	rotspeed = rng.randf_range(-0.05, 0.05)
	velocity = rng.randf_range(-0.05, 0.05)

func _process(delta: float) -> void:
	position += Vector2(velocity, gravity)
	
	$Sprite.rotation_degrees += rotspeed
	$Shadow.rotation_degrees += rotspeed

func _on_kill_timer_timeout() -> void:
	queue_free()
