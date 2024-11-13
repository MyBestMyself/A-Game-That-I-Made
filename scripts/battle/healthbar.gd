extends Node2D

var rng = RandomNumberGenerator.new()

var id
var team
var lastDamage

func _ready() -> void:
	Global.takeDamage.connect(take_damage)

func take_damage(targetId = id):
	var move = Global.moveQueue[0]
	if move['Team'] == 'Friend' and move['Move']['Reciever'] == "Target":
		if team == "Enemies":
			hurt()
	elif move['Team'] == 'Friend' and move['Move']['Reciever'] == "User":
		if team == "Friends":
			hurt()
	elif move['Team'] == 'Enemy' and move['Move']['Reciever'] == "Target":
		if team == "Friends":
			hurt()
	elif move['Team'] == 'Enemy' and move['Move']['Reciever'] == "User":
		if team == "Enemies":
			hurt()

func hurt():
	if Global.calculatedDamage != null:
		Global.field[team][id]['Health']['Current'] -= Global.calculatedDamage
	var maxHealth = Global.field[team][id]['Health']['Max']
	var currentHealth = Global.field[team][id]['Health']['Current']
	
	var healthPercent = (currentHealth/maxHealth) * 100
	$Offset/Health.value = healthPercent
	$Offset/Shadow.value = healthPercent
	$Offset/TransformFakeHealth/FakeHealth.value = 100 - (healthPercent)
	$Offset/TransformFakeHealthShadow/FakeHealthShadow.value = 100 - (healthPercent)
	
	var steps = (lastDamage / maxHealth) * 100
	$Offset/TransformFakeHealth/Light.position.x = -steps * 0.82
	$Offset/TransformFakeHealthShadow/Light.position.x = -steps * 0.82
	
	$Animate.play("hurt" + str(rng.randi_range(1, 4)))
	lastDamage = maxHealth - currentHealth

func setup():
	rng.randomize()
	
	var num = randi_range(1, 4)
	$Offset/Health.texture_progress = load("res://sprites/battle/Health" + str(num) + ".png")
	$Offset/Shadow.texture_progress = load("res://sprites/battle/Health" + str(num) + ".png")
	$Offset/TransformFakeHealth/FakeHealth.texture_progress = load("res://sprites/battle/Health" + str(num) + ".png")
	$Offset/TransformFakeHealthShadow/FakeHealthShadow.texture_progress = load("res://sprites/battle/Health" + str(num) + ".png")
	
	$Offset/Health.rotation_degrees = rng.randf_range(-2.5, 2.5)
	$Offset/Shadow.rotation_degrees = $Offset/Health.rotation_degrees
	$Offset/TransformFakeHealth/FakeHealth.rotation_degrees = $Offset/Health.rotation_degrees
	$Offset/TransformFakeHealthShadow/FakeHealthShadow.rotation_degrees = $Offset/Health.rotation_degrees
	
	var maxHealth = Global.field[team][id]['Health']['Max']
	var currentHealth = Global.field[team][id]['Health']['Current']
	
	lastDamage = maxHealth - currentHealth
	hurt()
