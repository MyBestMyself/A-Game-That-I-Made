extends Node2D

var rng = RandomNumberGenerator.new()

var id = 0
var team
var origin

func _ready():
	Global.startBattle.connect(start_battle)
	Global.run.connect(run)

func start_battle():
	if is_in_group("friend"):
		team = "Friends"
		origin = Vector2(-80, 0)
		
		Global.sendFriend.connect(send_out)
		Global.switchFriend.connect(switch)
	elif is_in_group("enemy"):
		team = "Enemies"
		origin = Vector2(80, -48)
		$Base/Drawing.scale.x = -1
		
		Global.sendEnemy.connect(send_out)
		Global.switchEnemy.connect(switch)
	Global.attack.connect(get_attacked)

func send_out():
	if Global.currentMenu == "intro":
		$Animate.play("Intro")
		setup()
	else:
		$Animate.play("Popup")
		setup()
	
	if team == "Friends":
		Global.friendInfo.emit()
	elif team == "Enemies":
		Global.enemyInfo.emit()

func switch():
	if team == "Friends":
		Global.field['Friends'][0] = Global.moveQueue[0]['Move']
		$Animate.play("SwitchFriend")
	elif team == "Enemies":
		Global.field['Enemies'][0] = Global.moveQueue[0]['Move']
		$Animate.play("SwitchEnemy")
	
	$DelaySwitch.start()

func finish_intro():
	Global.finishIntro.emit()

func get_attacked():
	$DelayAttack.start()

func _on_delay_attack_timeout() -> void:
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

func _on_delay_switch_timeout() -> void:
	finish_turn(null)

#animation finished
func finish_turn(anim_name):
	Global.displayMoveText.emit()

func hurt():
	Global.takeDamage.emit()
	if team == "Friends":
		$AnimateAttacks.play("HurtFriend")
	elif team == "Enemies":
		$AnimateAttacks.play("HurtEnemy")
		

func setup():
	rng.randomize()
	
	position = origin
	
	$Base.frame = rng.randi_range(0, 5)
	$Shadow.frame = $Base.frame
	
	$Base.rotation_degrees = rng.randf_range(-15, 15)
	$Shadow.rotation_degrees = $Base.rotation_degrees
	
	if Global.field[team].size() > 0:
		$Base/Drawing.texture = load("res://sprites/friends/" + Global.field[team][id]['Name'] + ".png")

func run():
	$Animate.play("RESET")
