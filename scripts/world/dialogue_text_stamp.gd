extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	setup()

func setup():
	$TextStamp.frame = rng.randi_range(0,3)
	$Shadow.frame = $FirstTextStamp.frame
	
	$TextStamp.rotation_degrees = randf_range(-2, 2)
	$Shadow.rotation_degrees = $TextStamp.rotation_degrees
	
	$TextStamp/Label.text = Dialogue.text[Global.currentSpeaker][0]
