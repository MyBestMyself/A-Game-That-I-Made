extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Global.hideMoveDetails.connect(hide_move_details)
	setup()
	show_move_details()

func setup():
	rng.randomize()
	
	$MoveDescription/Sprite.frame = rng.randi_range(0, 3)
	$MoveDescription/Shadow.frame = $MoveDescription/Sprite.frame
	$MoveStats/Sprite.frame = rng.randi_range(0, 3)
	$MoveStats/Shadow.frame = $MoveStats/Sprite.frame
	
	$MoveDescription/Sprite.rotation_degrees = randf_range(-3, 3)
	$MoveDescription/Shadow.rotation_degrees = $MoveDescription/Sprite.rotation_degrees
	$MoveStats/Sprite.rotation_degrees = randf_range(-3, 3)
	$MoveStats/Shadow.rotation_degrees = $MoveStats/Sprite.rotation_degrees

func show_move_details():
	$MoveDescription/Sprite/Name.text = Global.selectedMove['Name']
	$MoveDescription/Sprite/Stamina.text = str(Global.field['Friends'][Global.selectedFriend]["Stamina"][Global.selectedMove['Name']])
	$MoveDescription/Sprite/Description.text = Global.selectedMove['Description']
	$MoveStats/Sprite/Type.text = Global.selectedMove['Type']
	$MoveStats/Sprite/Category.text = Global.selectedMove['Category']
	$MoveStats/Sprite/Accuracy.text = "Accuracy: " + str(Global.selectedMove['Accuracy'])
	$MoveStats/Sprite/Power.text = "Power: " + str(Global.selectedMove['Power'])
	if 'Other' in Global.selectedMove:
		$MoveStats/Sprite/Other.text = Global.selectedMove['Other']
	elif 'Effects' in Global.selectedMove:
		$MoveStats/Sprite/Other.text = effects_description(Global.selectedMove['Effects'])
	
	$Animate.play("MoveDetails")
	$Animate.seek($Animate.current_animation_position, true)

func hide_move_details():
	$Animate.play_backwards("MoveDetails")
	$Animate.seek($Animate.current_animation_position, true)
	$KillTimer.start()

func effects_description(effects):
	#'Effects':{'User':{'Conditions':[], "Accuracy":null}, 'Target':{'Conditions':[], "Accuracy":null},'All':{'Conditions':[], "Accuracy":null}}
	#User - gain
	#Target - inflict
	#Environment - summon
	var output = ""
	if 'User' in effects:
		if 'Accuracy' in effects['User'] and effects['User']['Accuracy'] != null:
			output += str(effects['User']['Accuracy']) + "% chance to gain"
		else:
			output += "Gain"
		
		for i in range(effects['User']['Conditions'].size()):
			output += " " + effects['User']['Conditions'][i]
			if i < effects['User']['Conditions'].size() - 2:
				output += ","
			elif i == effects['User']['Conditions'].size() - 2:
				output += " and"
	
	if 'User' in effects and 'Target' in effects:
		output += " "
	
	if 'Target' in effects:
		if 'Accuracy' in effects['Target'] and effects['Target']['Accuracy'] != null:
			output += str(effects['Target']['Accuracy']) + "% chance to inflict"
		else:
			output += "Inflicts"
		
		for i in range(effects['Target']['Conditions'].size()):
			output += " " + effects['Target']['Conditions'][i]
			if i < effects['Target']['Conditions'].size() - 2:
				output += ","
			elif i == effects['Target']['Conditions'].size() - 2:
				output += " and"
	return output

func resize_text(label):
	var fontSize = 16
	label.add_theme_font_size_override("font_size", fontSize)
	
	while label.get_line_count() > 2:
		fontSize -= 1
		label.add_theme_font_size_override("font_size", fontSize)

func _on_kill_timer_timeout() -> void:
	queue_free()
