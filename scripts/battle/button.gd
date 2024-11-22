extends Node2D

var rng = RandomNumberGenerator.new()

var touchingMouse = false
var identity

func _ready() -> void:
	if is_in_group("action"):
		identity = "actions"
	else:
		identity = "moves"
		
	
	setup()
	
	Global.showMoves.connect(reset_moves)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and touchingMouse:
		if identity == "actions":
			match name:
				"Moves":
					Global.showMoves.emit()
				"Stuff":
					pass
				"Friends":
					Global.showFriendsList.emit()
				"Run":
					Global.clear_battle()
					Global.run.emit()
		elif identity == "moves":
			Global.startNextTurn.emit()

func check_if_selectable():
	if identity == Global.currentMenu and $Sprite/Label.text != "...":
		$Area2D.input_pickable = true
	else:
		$Area2D.input_pickable = false
		touchingMouse = false

func reset_moves():
	if identity == "moves":
		if int(str(name)[-1]) <= Global.field['Friends'][Global.selectedFriend]['Moves'].size() - 1:
			$Sprite/Label.text = Global.field['Friends'][Global.selectedFriend]['Moves'][int(str(name)[-1])]
			$Area2D.input_pickable = true
			resize_text($Sprite/Label, 1)
		else:
			$Sprite/Label.text = "..."
			$Area2D.input_pickable = false
		setup()

func resize_text(label, limit = 2):
	var fontSize = 16
	label.add_theme_font_size_override("font_size", fontSize)
	
	while label.get_line_count() > limit:
		fontSize -= 1
		label.add_theme_font_size_override("font_size", fontSize)

func setup():
	rng.randomize()
	
	$Sprite.frame = rng.randi_range(0, 7)
	$Shadow.frame = $Sprite.frame
	
	$Sprite.rotation_degrees = rng.randf_range(-5, 5)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees
	
	if identity == "actions":
		$Sprite/Label.text = name

func _on_area_2d_mouse_entered() -> void:
	touchingMouse = true
	$Animate.play("Popup")
	$Animate.seek($Animate.current_animation_position, true)
	
	if Global.currentMenu == "moves":
		Global.selectedMove = Data.moves[$Sprite/Label.text]
		Global.showMoveDetails.emit()

func _on_area_2d_mouse_exited() -> void:
	touchingMouse = false
	$Animate.play_backwards("Popup")
	$Animate.seek($Animate.current_animation_position, true)
	
	if identity == "moves":
		Global.hideMoveDetails.emit()
