extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Global.hideTrainer.connect(slide_out)
	
	setup()

func setup():
	rng.randomize()
	
	$Sprite.rotation_degrees = randf_range(-7.5, 7.5)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees

func slide_out():
	$Animate.play("SlideOut")
