extends Node2D

var rng = RandomNumberGenerator.new()

func _ready():
	Global.startBattle.connect(start_battle)
	Global.run.connect(run)

func start_battle() -> void:
	Global.hideTrainer.connect(slide_out)
	
	setup()

func setup():
	rng.randomize()
	
	$Sprite.rotation_degrees = randf_range(-7.5, 7.5)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees

func slide_out():
	$Animate.play("SlideOut")

func run():
	$Animate.play("RESET")
