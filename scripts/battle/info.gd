extends Node2D

var rng = RandomNumberGenerator.new()

var id = 0
var team 

func _ready():
	Global.startBattle.connect(start_battle)
	Global.run.connect(run)

func start_battle():
	if is_in_group("friend"):
		team = "Friends"
		$Healthbar.team = team
		
		$Animate.play("SetupFriend")
		Global.friendInfo.connect(intro)
		Global.switchFriend.connect(switch)
	elif is_in_group("enemy"):
		team = "Enemies"
		$Healthbar.team = team
		
		$Animate.play("SetupEnemy")
		Global.enemyInfo.connect(intro)
		Global.switchEnemy.connect(switch)
	
	Global.takeDamage.connect(hurt)

func intro():
	setup()
	
	if team == "Friends":
		if Global.currentMenu == "intro":
			$Animate.play("FriendIntro")
		else:
			$Animate.play("FriendPopup")
	elif team == "Enemies":
		if Global.currentMenu == "intro":
			$Animate.play("EnemyIntro")
		else:
			$Animate.play("EnemyPopup")

func switch():
	if team == "Friends":
		$Animate.play("SlideOutFriend")
	elif team == "Enemies":
		$Animate.play("SlideOutEnemy")

func hurt():
	var move = Global.moveQueue[0]
	if move['Team'] == 'Friend' and move['Move']['Reciever'] == "User":
		if team == "Friends" and Global.calculatedDamage > 0:
			$Animate.play("ChangeHealth")
	elif move['Team'] == 'Enemy' and move['Move']['Reciever'] == "Target":
		if team == "Friends" and Global.calculatedDamage > 0:
			$Animate.play("ChangeHealth")

func set_new_health():
	$HealthStub/Num.text = str(Global.field[team][id]['Health']['Current']) + "/" + str(Global.field[team][id]['Health']['Max'])

func setup():
	$Healthbar.id = id
	$Healthbar.setup()
	
	rng.randomize()
	
	$Sprite.frame = rng.randi_range(0, 3)
	$Shadow.frame = $Sprite.frame
	$Name.frame = rng.randi_range(0, 7)
	$NameShadow.frame = $Name.frame
	$Level.frame = rng.randi_range(0, 3)
	$LevelShadow.frame = $Level.frame
	$HealthStub.frame = rng.randi_range(0, 3)
	$HealthStubShadow.frame = $HealthStub.frame
	
	$Sprite.rotation_degrees = rng.randf_range(-5, 5)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees
	$Name.rotation_degrees = rng.randf_range(-5, 5)
	$NameShadow.rotation_degrees = $Name.rotation_degrees
	$Level.rotation_degrees = rng.randf_range(-15, 15)
	$LevelShadow.rotation_degrees = $Level.rotation_degrees
	$HealthStub.rotation_degrees = rng.randf_range(-10, 10)
	$HealthStubShadow.rotation_degrees = $HealthStub.rotation_degrees
	
	if Global.field[team].size() > 0:
		$Name/Label.text = Global.field[team][id]['Name']
		$Level/HBoxContainer/Num.text = str(Global.field[team][id]['Level'])
		$HealthStub/Num.text = str(Global.field[team][id]['Health']['Current']) + "/" + str(Global.field[team][id]['Health']['Max'])
	
	resize_text($Name/Label, 1)

func resize_text(label, limit = 2):
	var fontSize = 16
	label.add_theme_font_size_override("font_size", fontSize)
	
	while label.get_line_count() > limit:
		fontSize -= 1
		label.add_theme_font_size_override("font_size", fontSize)

func run():
	$Animate.play("RESET")
