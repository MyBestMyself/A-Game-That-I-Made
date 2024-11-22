extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Global.hideStatusDetails.connect(hide_status_details)
	setup()
	show_status_details()

func setup():
	rng.randomize()
	
	$StatusDescription/Sprite.frame = rng.randi_range(0, 3)
	$StatusDescription/Shadow.frame = $StatusDescription/Sprite.frame
	$AllStats/Sprite.frame = rng.randi_range(0, 3)
	$AllStats/Shadow.frame = $AllStats/Sprite.frame
	
	$StatusDescription/Sprite.rotation_degrees = randf_range(-3, 3)
	$StatusDescription/Shadow.rotation_degrees = $StatusDescription/Sprite.rotation_degrees
	$AllStats/Sprite.rotation_degrees = randf_range(-3, 3)
	$AllStats/Shadow.rotation_degrees = $AllStats/Sprite.rotation_degrees

func show_status_details():
	var id = Global.selectedStatusCondition['Id']
	var team = Global.selectedStatusCondition['Team']
	var selectedCondition = Global.selectedStatusCondition['Condition']
	
	setup_description(Global.field[team][id]['Name'], selectedCondition)
	setup_stats(Global.field[team][id]['Conditions'])
	
	$Animate.play("StatusDetails")
	$Animate.seek($Animate.current_animation_position, true)

func setup_description(title, condition):
	#effect1, effect2, color
	var positive = Color(0,1,0)
	var negative = Color(1,0,0)
	
	var stats = {
		"Sharpened" : ["+50% Strength", "", positive, positive],
		"Rock-Solid" : ["+50% Defense", "", positive, positive],
		"Enlightened" : ["+50% Smarts", "", positive, positive],
		"Headstrong" : ["+50% Resolve", "", positive, positive],
		"Slippery" : ["+25% Speed", "+25% Dodge", positive, positive],
		"Heated" : ["+25% Speed", "+25% Accuracy", positive, positive],
		"Perceptive" : ["+25% Dodge", "+25% Accuracy", positive, positive],
		"Flourishing" : ["+12.5% Hp per turn", "+25% Speed", positive, positive],
		"Immunized" : ["+12.5% Hp per turn", "+25% Dodge", positive, positive],
		"Upgraded" : ["+25% Strength", "+25% Smarts", positive, positive],
		"Numb" : ["+25% Resistance", "+25% Resolve", positive, positive],
		"Oppressive" : ["This battle is unfair", "", positive, positive],
		
		#Negative
		"Burnt" : ["-12.5% Hp per turn", "-25% Strength", negative, negative],
		"Bleeding" : ["-12.5% Hp per turn", "-25% Resistance", negative, negative],
		"Frostbitten" : ["-12.5% Hp per turn", "-25% Smarts", negative, negative],
		"Infected" : ["-12.5% Hp per turn", "-25% Resolve", negative, negative],
		"Ensnared" : ["-25% Speed", "-25% Strength", negative, negative],
		"Waterlogged" : ["-25% Speed", "-25% Smarts", negative, negative],
		"Dazed" : ["-25% Dodge", "-25% Resistance", negative, negative],
		"Hacked" : ["-25% Dodge", "-25% Resolve", negative, negative],
		"Distracted" : ["-25% Strength", "-25% Resistance", negative, negative],
		"Irrational" : ["-25% Smarts", "-25% Resolve", negative, negative],
		"Blind" : ["+50% Accuracy", "", negative, negative],
		"Terrified" : [title + " is terrified", "", negative, negative],
	}
	
	var data = stats[condition]
	var effect1 = data[0]
	var effect2 = data[1]
	var e1Color = data[2]
	var e2Color = data[3]
	
	$StatusDescription/Sprite/Name.text = Global.selectedStatusCondition['Condition']
	
	$StatusDescription/Sprite/Effect1.text = effect1
	$StatusDescription/Sprite/Effect1.set("theme_override_colors/font_color", e1Color)
	
	$StatusDescription/Sprite/Effect2.text = effect2
	$StatusDescription/Sprite/Effect2.set("theme_override_colors/font_color", e2Color)
	
	$StatusDescription/Sprite/Icon.texture = load("res://sprites/battle/statusConditions/" + Global.selectedStatusCondition['Condition'] + ".png")

func setup_stats(conditions):
	var hp = 0
	var speed = 100
	var strength = 100
	var smarts = 100
	var resistance = 100
	var resolve = 100
	var accuracy = 100
	var dodge = 100
	
	var defaultStats = {
		"Hp": hp,
		"Speed": speed,
		"Strength": strength,
		"Smarts": smarts,
		"Resistance": resistance,
		"Resolve": resolve,
		"Accuracy": accuracy,
		"Dodge": dodge,
	}
	
	var stats = {
		"Sharpened" : [["strength"], [50]],
		"Rock-Solid" : [["resistance"], [50]],
		"Enlightened" : [["smarts"], [50]],
		"Headstrong" : [["resolve"], [50]],
		"Slippery" : [["speed", "dodge"], [25, 25]],
		"Heated" : [["speed", "accuracy"], [25, 25]],
		"Perceptive" : [["dodge", "accuracy"], [25, 25]],
		"Flourishing" : [["hp", "speed"], [12.5, 25]],
		"Immunized" : [["hp", "dodge"], [12.5, 25]],
		"Upgraded" : [["strength", "smarts"], [25, 25]],
		"Numb" : [["resistance", "resolve"], [25, 25]],
		"Oppressive" : [[], []],
		
		#Negative
		"Burnt" : [["hp", "strength"], [-12.5, -25]],
		"Bleeding" : [["hp", "resistance"], [-12.5, -25]],
		"Frostbitten" : [["hp", "smarts"], [-12.5, -25]],
		"Infected" : [["hp", "resolve"], [-12.5, -25]],
		"Ensnared" : [["speed", "strength"], [-25, -25]],
		"Waterlogged" : [["speed", "smarts"], [-25, -25]],
		"Dazed" : [["dodge", "resistance"], [-25, -25]],
		"Hacked" : [["dodge", "resolve"], [-25, -25]],
		"Distracted" : [["strength", "resistance"], [-25, -25]],
		"Irrational" : [["smarts", "resolve"], [-25, -25]],
		"Blind" : [["accuracy"], [-50]],
		"Terrified" : [[], []],
	}
	
	for condition in conditions:
		var effects = stats[condition]
		for i in range(len(effects[0])):
			var stat = effects[0][i]
			var val = effects[1][i]
			
			if stat == "strength":
				strength += val
			elif stat == "resistance":
				resistance += val
			elif stat == "smarts":
				smarts += val
			elif stat == "resolve":
				resolve += val
			elif stat == "speed":
				speed += val
			elif stat == "accuracy":
				accuracy += val
			elif stat == "dodge":
				dodge += val
			elif stat == "hp":
				hp += val
	
	if hp >= 0:
		$AllStats/Sprite/Hp.text = "Hp: +" + str(hp) + "% / turn"
	else:
		$AllStats/Sprite/Hp.text = "Hp: " + str(hp) + "% / turn"
	
	$AllStats/Sprite/Speed.text = "Speed: " + str(speed) + "%"
	$AllStats/Sprite/Strength.text = "Strength: " + str(strength) + "%"
	$AllStats/Sprite/Smarts.text = "Smarts: " + str(smarts) + "%"
	$AllStats/Sprite/Resistance.text = "Resistance: " + str(resistance) + "%"
	$AllStats/Sprite/Resolve.text = "Resolve: " + str(resolve) + "%"
	$AllStats/Sprite/Accuracy.text = "Accuracy: " + str(accuracy) + "%"
	$AllStats/Sprite/Dodge.text = "Dodge: " + str(dodge) + "%"
	
	var newStats = {
		"Hp": hp,
		"Speed": speed,
		"Strength": strength,
		"Smarts": smarts,
		"Resistance": resistance,
		"Resolve": resolve,
		"Accuracy": accuracy,
		"Dodge": dodge,
	}
	
	#set color
	var positive = Color(0, 1, 0)
	var negative = Color(1, 0, 0)
	var neutral = Color(0, 0, 0) 
	
	for stat in defaultStats.keys():
		var current = newStats[stat]
		var default = defaultStats[stat]
		
		var color = neutral
		if current > default:
			color = positive
		elif current < default:
			color = negative
		
		$AllStats/Sprite.get_node(stat).set("theme_override_colors/font_color", color)

func hide_status_details():
	$Animate.play_backwards("StatusDetails")
	$Animate.seek($Animate.current_animation_position, true)
	$KillTimer.start()

func resize_text(label):
	var fontSize = 12
	label.add_theme_font_size_override("font_size", fontSize)
	
	while label.get_line_count() > 2:
		fontSize -= 1
		label.add_theme_font_size_override("font_size", fontSize)

func _on_kill_timer_timeout() -> void:
	queue_free()
