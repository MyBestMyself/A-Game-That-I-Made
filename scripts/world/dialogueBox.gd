extends Node2D

var rng = RandomNumberGenerator.new()
var speaking = false

func _ready() -> void:
	Global.playDialogue.connect(playDialogue)

func playDialogue():
	if not speaking:
		speaking = true
		setup()
		$Animate.play("slideIn")
	else:
		pass

func setup():
	$FirstTextStamp.frame = rng.randi_range(0,3)
	$FirstTextStampShadow.frame = $FirstTextStamp.frame
	
	$TextBox.rotation_degrees = rng.randf_range(-2, 2)
	$Shadow.rotation_degrees = $TextBox.rotation_degrees
	$Speaker.rotation_degrees = randf_range(-5, 5) 
	$SpeakerShadow.rotation_degrees = $Speaker.rotation_degrees
	$FirstTextStamp.rotation_degrees = randf_range(-2, 2)
	$FirstTextStampShadow.rotation_degrees = $FirstTextStamp.rotation_degrees
	
	$Speaker.texture = load("res://sprites/characters/" + Global.currentSpeaker + "Head.png")
	$SpeakerShadow.texture = $Speaker.texture
	
	$FirstTextStamp/Label.text = Dialogue.text[Global.currentSpeaker][0]
