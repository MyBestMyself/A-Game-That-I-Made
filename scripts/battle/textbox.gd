extends Node2D

var rng = RandomNumberGenerator.new()
var text = preload("res://scenes/battle/battle_text_stamp.tscn")

func _ready() -> void:
	setup()
	
	Global.finishIntro.connect(finish_intro)
	play_intro("trainer")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and Global.currentMenu == "intro":
		clear_text()
		Global.hideTrainer.emit()
		then_write()
		Global.sendEnemy.emit()
		Global.enemyInfo.emit()
		
		Global.currentMenu = "transitioning"

func ready_for_intro():
	Global.currentMenu = "intro"

func play_intro(type):
	match type:
		"trainer":
			write("You are challenged by trainer Ellie")
			Global.battleTextQueue.append("Ellie sent out Geobro")

func finish_intro():
	write("Go! Geobro")
	Global.sendFriend.emit()
	Global.friendInfo.emit()
	#Make this nicer if you ever figure out how
	await get_tree().create_timer(1.3).timeout
	clear_text()
	then_write("What will Geobro do?")
	actions()


func write(message = null):
	if message != null:
		Global.battleTextQueue.append(message)
	$BattleText.add_child(text.instantiate())

#Wait until current text slides out THEN WRITE a new line
func then_write(message = null, time = 0.3):
	await get_tree().create_timer(time).timeout
	write(message)

func clear_text():
	Global.displayedBattleText.clear()
	for x in $BattleText.get_children():
		x.get_node("Animate").play("SlideOut")

func actions():
	Global.currentMenu = "actions"
	$Animate.play("Actions")

func setup():
	rng.randomize()
	
	$Sprite.rotation_degrees = rng.randf_range(-1, 1)
