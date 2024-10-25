extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	setup()

func setup():
	rng.randomize()
	
	if Global.displayedBattleText.size() == 0:
		$Offset.position.x -= 68
	else:
		$Offset.position.x += 68
	
	$Offset/Sprite.frame = rng.randi_range(0,3)
	$Offset/Shadow.frame = $Offset/Sprite.frame
	
	$Offset/Sprite.rotation_degrees = randf_range(-2, 2)
	$Offset/Shadow.rotation_degrees = $Offset/Sprite.rotation_degrees
	
	if Global.battleTextQueue.size() > 0:
		$Offset/Sprite/Label.text = Global.battleTextQueue[0]
		Global.displayedBattleText.append(Global.battleTextQueue.pop_at(0)) 
	else:
		$Offset/Sprite/Label.text = "I'm a little confused"
	
	#Resize text
	resize_text($Offset/Sprite/Label)

func resize_text(label):
	var fontSize = 16
	label.add_theme_font_size_override("font_size", fontSize)
	
	while label.get_line_count() > 2:
		fontSize -= 1
		label.add_theme_font_size_override("font_size", fontSize)

func kill():
	queue_free()
