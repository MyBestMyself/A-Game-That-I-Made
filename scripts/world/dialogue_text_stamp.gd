extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Global.killDialogue.connect(kill)
	
	setup()

func setup():
	rng.randomize()
	
	$Sprite.frame = rng.randi_range(0,3)
	$Shadow.frame = $Sprite.frame
	
	$Sprite.rotation_degrees = randf_range(-2, 2)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees
	
	$Sprite/Label.text = Dialogue.text[Dialogue.currentSpeaker][Dialogue.textIndex]

func kill():
	queue_free()
