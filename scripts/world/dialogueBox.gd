extends Node2D

var rng = RandomNumberGenerator.new()
var text = preload("res://scenes/world/dialogue_text_stamp.tscn")

var speaking = false

func _ready() -> void:
	Global.playDialogue.connect(playDialogue)

var keywords = ["START BATTLE", "BREAK", "END"]
func playDialogue():
	if not speaking:
		speaking = true
		Dialogue.textIndex = 0
		Global.killDialogue.emit()
		
		setup()
		
		$Animate.play("slideIn")
	else:
		Dialogue.textIndex += 1
		
		if Dialogue.text[Dialogue.currentSpeaker][Dialogue.textIndex] in keywords:
			speaking = false
			$Animate.play("slideOut")
			keyword_behavior(Dialogue.text[Dialogue.currentSpeaker][Dialogue.textIndex])
		else:
			add_child(text.instantiate())

func keyword_behavior(keyword):
	match keyword:
		"START BATTLE":
			Global.battleTransition.emit()

func setup():
	rng.randomize()
	
	$FirstTextStamp.frame = rng.randi_range(0,3)
	$FirstTextStampShadow.frame = $FirstTextStamp.frame
	
	$TextBox.rotation_degrees = rng.randf_range(-2, 2)
	$Shadow.rotation_degrees = $TextBox.rotation_degrees
	$Speaker.rotation_degrees = randf_range(-5, 5) 
	$SpeakerShadow.rotation_degrees = $Speaker.rotation_degrees
	$FirstTextStamp.rotation_degrees = randf_range(-2, 2)
	$FirstTextStampShadow.rotation_degrees = $FirstTextStamp.rotation_degrees
	
	$Speaker.texture = load("res://sprites/characters/" + Dialogue.currentSpeaker + "Head.png")
	$SpeakerShadow.texture = $Speaker.texture
	
	$FirstTextStamp/Label.text = Dialogue.text[Dialogue.currentSpeaker][0]
