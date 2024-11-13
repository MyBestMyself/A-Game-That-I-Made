extends Node2D

var rng = RandomNumberGenerator.new()
var text = preload("res://scenes/battle/battle_text_stamp.tscn")
var moveDetails = preload("res://scenes/battle/move_details.tscn")

func _ready():
	Global.startBattle.connect(start_battle)
	Global.run.connect(run)

func start_battle() -> void:
	setup()
	Global.finishIntro.connect(finish_intro)
	Global.showMoves.connect(show_moves)
	Global.showFriendsList.connect(show_friends_list)
	Global.showMoveDetails.connect(show_move_details)
	Global.startNextTurn.connect(start_next_turn)
	Global.displayMoveText.connect(display_move_text)
	
	play_intro("trainer")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and Global.currentMenu == "intro":
		clear_text()
		Global.hideTrainer.emit()
		then_write()
		Global.sendEnemy.emit()
		
		Global.currentMenu = "transitioning"
	
	if Input.is_action_just_pressed("cancel"):
		close_menu()

func ready_for_intro():
	Global.currentMenu = "intro"

func play_intro(type):
	$Animate.play("BattleIntro")
	
	match type:
		"trainer":
			write("You are challenged by trainer Ellie")
			Global.battleTextQueue.append("Ellie sent out " + Global.field['Enemies'][0]['Name'])

func finish_intro():
	write("Go! " + Global.field['Friends'][0]['Name'])
	Global.sendFriend.emit()
	#Make this nicer if you ever figure out how
	await get_tree().create_timer(1.3).timeout
	clear_text()
	then_write(0.5, "What will " + Global.field['Friends'][0]['Name'] + " do?")
	actions()

func start_next_turn():
	match Global.currentMenu:
		"moves":
			$Animate.play("HideActionsAndMoves")
		"friends":
			$Animate.play("HideActionsAndFriends")
	
	Global.currentMenu = "battling"
	$CombatManager.queue_moves()
	next_turn()

func display_move_text():
	$CombatManager.append_move_text()
	
	if Global.battleTextQueue.size() > 0:
		write()
		for x in Global.battleTextQueue.size():
			var delay = 1
			then_write(delay) 
			await get_tree().create_timer(delay).timeout
		await get_tree().create_timer(1).timeout
	
	Global.moveQueue.remove_at(0)
	next_turn()

func next_turn():
	clear_text()
	
	if Global.moveQueue.size() > 0:
		var selectedName = Global.moveQueue[0]['Name']
		var selectedTeam = Global.moveQueue[0]['Team']
		var selectedMove = Global.moveQueue[0]['Move']
		
		if selectedTeam == "Friend" and selectedMove in Data.friends: #SWITCH FRIEND
			then_write(0.5, selectedName + " came back to you")
			then_write(1.5, "Go " + selectedMove['Name'] + "!")
			
			Global.calculatedDamage = null
			Global.switchFriend.emit()
		elif selectedTeam == "Enemy" and selectedMove in Data.enemies: #SWITCH ENEMY
			then_write(0.5, selectedName + " came back to you")
			then_write(1.5, "Go " + selectedMove['Name'] + "!")
			
			Global.calculatedDamage = null
			Global.switchEnemy.emit()
		else: #ATTACK
			then_write(0.5, selectedName + " used " + selectedMove['Name'])
			
			$CombatManager.calculate_damage()
			Global.attack.emit()
	else:
		then_write(0.5, "What will " + Global.field['Friends'][0]['Name'] + " do?")
		actions()

func write(message = null):
	if message != null:
		Global.battleTextQueue.append(message)
	$BattleText.add_child(text.instantiate())

#Wait until current text slides out THEN WRITE a new line
func then_write(time = 0.5, message = null):
	await get_tree().create_timer(time).timeout
	write(message)

func clear_text():
	Global.displayedBattleText.clear()
	for x in $BattleText.get_children():
		x.get_node("Animate").play("SlideOut")

func actions():
	Global.currentMenu = "actions"
	$Animate.play("Actions")
	setup_buttons()

func show_moves():
	Global.currentMenu = "moves"
	$Animate.play("Moves")
	setup_buttons()

func show_friends_list():
	Global.currentMenu = "friends"
	$Animate.play("FriendsList")
	$FriendsList.setup()

func show_move_details():
	add_child(moveDetails.instantiate())

func close_menu():
	match Global.currentMenu:
		"moves":
			Global.currentMenu = "actions"
			$Animate.play("HideMoves")
			setup_buttons()
		"friends":
			Global.currentMenu = "actions"
			$Animate.play_backwards("FriendsList")
			setup_buttons()

func setup_buttons():
	for x in $Actions.get_children():
		x.check_if_selectable()

func setup():
	rng.randomize()
	$Sprite.rotation_degrees = rng.randf_range(-1, 1)

func run():
	$Animate.play("RESET")
