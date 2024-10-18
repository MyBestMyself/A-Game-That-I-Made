extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Global.killDialogue.connect(kill)
	
	setup()

func setup():
	$TextStamp.frame = rng.randi_range(0,3)
	$Shadow.frame = $TextStamp.frame
	
	$TextStamp.rotation_degrees = randf_range(-2, 2)
	$Shadow.rotation_degrees = $TextStamp.rotation_degrees
	
	$TextStamp/Label.text = Dialogue.text[Dialogue.currentSpeaker][Dialogue.textIndex]

func kill():
	queue_free()
