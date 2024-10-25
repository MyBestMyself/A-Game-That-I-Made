extends Node2D

var rng = RandomNumberGenerator.new()

var team
var origin

func _ready():
	if is_in_group("friend"):
		team = "FRIEND"
		origin = Vector2(-80, 0)
		
		Global.sendFriend.connect(send_out)
	elif is_in_group("enemy"):
		team = "ENEMY"
		origin = Vector2(80, -48)
		$Base/Drawing.scale.x = -1
		
		Global.sendEnemy.connect(send_out)
	
	setup()

func send_out():
	if Global.currentMenu == "intro":
		$Animate.play("Intro")
	else:
		$Animate.play("Popup")

func finish_intro():
	Global.finishIntro.emit()

func setup():
	rng.randomize()
	
	position = origin
	
	$Base.frame = rng.randi_range(0, 5)
	$Shadow.frame = $Base.frame
	
	$Base.rotation_degrees = rng.randf_range(-15, 15)
	$Shadow.rotation_degrees = $Base.rotation_degrees
