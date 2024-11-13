extends Node2D

var id
var touchingMouse = false

var rng = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and touchingMouse:
		Global.selectedMove = Data.friends[id]
		Global.startNextTurn.emit()

func setup():
	var friend = Data.friends[id]
	
	position.y = -78 + (id * 39)
	rng.randomize()
	
	$Sticky.frame = rng.randi_range(0, 5)
	$Shadow.frame = $Sticky.frame
	$Name.frame = rng.randi_range(0, 7)
	$NameShadow.frame = $Name.frame
	$Level.frame = rng.randi_range(0, 3)
	$LevelShadow.frame = $Level.frame
	$HealthStub.frame = rng.randi_range(0, 3)
	$HealthStubShadow.frame = $HealthStub.frame
	
	var num = randi_range(1, 4)
	$Healthbar.texture_progress = load("res://sprites/battle/Health" + str(num) + ".png")
	$HealthbarShadow.texture_progress = $Healthbar.texture_progress
	
	$Sticky.rotation_degrees = rng.randf_range(-5, 5)
	$Shadow.rotation_degrees = $Sticky.rotation_degrees
	$Name.rotation_degrees = rng.randf_range(-5, 5)
	$NameShadow.rotation_degrees = $Name.rotation_degrees
	$Level.rotation_degrees = rng.randf_range(-15, 15)
	$LevelShadow.rotation_degrees = $Level.rotation_degrees
	$Healthbar.rotation_degrees = rng.randf_range(-2.5, 2.5)
	$HealthbarShadow.rotation_degrees = $Healthbar.rotation_degrees
	$HealthStub.rotation_degrees = rng.randf_range(-10, 10)
	$HealthStubShadow.rotation_degrees = $HealthStub.rotation_degrees
	$Wobble.current_animation = "wobble"
	$Wobble.advance(rng.randi_range(0, 2.4))
	$Wobble.pause()
	
	$Name/Label.text = friend['Name']
	$Level/HBoxContainer/Num.text = str(friend['Level'])
	$HealthStub/Num.text = str(friend['Health']['Current']) + "/" + str(friend['Health']['Max'])
	
	$Sticky/Drawing.texture = load("res://sprites/friends/" + friend['Name'] + ".png")
	
	$Healthbar.value = (friend['Health']['Current'] / friend['Health']['Max']) * 100
	$HealthbarShadow.value = $Healthbar.value
	
	resize_text($Name/Label, 1)

func resize_text(label, limit = 2):
	var fontSize = 16
	label.add_theme_font_size_override("font_size", fontSize)
	
	while label.get_line_count() > limit:
		fontSize -= 1
		label.add_theme_font_size_override("font_size", fontSize)

func _on_hitbox_mouse_entered() -> void:
	touchingMouse = true
	
	$Scale.play("Scale")
	$Wobble.play("wobble")
	
	$Sticky.z_index = 1
	$Shadow.z_index = 1


func _on_hitbox_mouse_exited() -> void:
	touchingMouse = false
	
	$Scale.play_backwards("Scale")
	$Wobble.pause()
	
	$Sticky.z_index = 0
	$Shadow.z_index = 0
