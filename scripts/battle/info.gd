extends Node2D

var rng = RandomNumberGenerator.new()

var team

func _ready() -> void:
	if is_in_group("friend"):
		team = "FRIEND"
		$Animate.play("SetupFriend")
		Global.friendInfo.connect(intro)
	elif is_in_group("enemy"):
		team = "ENEMY"
		$Animate.play("SetupEnemy")
		Global.enemyInfo.connect(intro)
	
	setup()

func intro():
	if team == "FRIEND":
		if Global.currentMenu == "intro":
			$Animate.play("FriendIntro")
		else:
			$Animate.play("FriendPopup")
	elif team == "ENEMY":
		if Global.currentMenu == "intro":
			$Animate.play("EnemyIntro")
		else:
			$Animate.play("EnemyPopup")

func setup():
	rng.randomize()
	
	$Sprite.frame = rng.randi_range(0, 3)
	$Shadow.frame = $Sprite.frame
	$Name.frame = rng.randi_range(0, 7)
	$NameShadow.frame = $Name.frame
	$Level.frame = rng.randi_range(0, 3)
	$LevelShadow.frame = $Level.frame
	
	$Sprite.rotation_degrees = rng.randf_range(-5, 5)
	$Shadow.rotation_degrees = $Sprite.rotation_degrees
	$Name.rotation_degrees = rng.randf_range(-5, 5)
	$NameShadow.rotation_degrees = $Name.rotation_degrees
	$Level.rotation_degrees = rng.randf_range(-15, 15)
	$LevelShadow.rotation_degrees = $Level.rotation_degrees
	
	
	$Health.rotation_degrees = rng.randf_range(-2.5, 2.5)
