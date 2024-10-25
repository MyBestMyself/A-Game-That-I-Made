extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var versus = preload("res://scenes/world/versus_screen.tscn")
var paperRain = preload("res://scenes/paper_behavior/paper_rain.tscn")
var battle = preload("res://scenes/battle/battle.tscn")

var directionQueue = []
var facingRight = true

func _ready() -> void:
	Global.battleTransition.connect(battleTransition)
	Global.startBattle.connect(start_battle)

func _physics_process(delta: float) -> void:
	var directions = ["up", "down", "left", "right"]
	
	for direction in directions:
		if Input.is_action_just_pressed(direction):
			directionQueue.append(direction)
		elif Input.is_action_just_released(direction):
			directionQueue.erase(direction)
	
	if not $Dialogue.speaking and not Global.battling:
		move_character()
	
	if directionQueue.size() == 0:
		$Animate.stop()

func move_character() -> void:
	if directionQueue.size() == 0:
		return
	
	var dir = directionQueue[0]
	var move_vector = Vector2.ZERO
	var is_moving = false

	match dir:
		"right":
			move_vector.x = 1
			is_moving = Input.is_action_pressed(dir)
			if !facingRight:
				facingRight = true
				$Flip.play_backwards("flip")
		"left":
			move_vector.x = -1
			is_moving = Input.is_action_pressed(dir)
			if facingRight:
				facingRight = false
				$Flip.play("flip")
		"down":
			move_vector.y = 1
			is_moving = Input.is_action_pressed(dir)
		"up":
			move_vector.y = -1
			is_moving = Input.is_action_pressed(dir)

	if is_moving:
		move_and_collide(move_vector)
		$Animate.play("walk")

func walk() -> void:
	rng.randomize()
	
	if $Sprite.rotation_degrees > 0:
		$Sprite.rotation_degrees = rng.randf_range(-7.5, -0.5)
		$Shadow.rotation_degrees = $Sprite.rotation_degrees
	else:
		$Sprite.rotation_degrees = rng.randf_range(0.5, 7.5)
		$Shadow.rotation_degrees = $Sprite.rotation_degrees

var bosses = ["Ellie"]
func battleTransition():
	Global.battling = true
	if Dialogue.currentSpeaker in bosses:
		add_child(versus.instantiate())
	Audio.play_song("Boss")
	add_child(paperRain.instantiate())
	load_battle_background()

func start_battle():
	$Sprite.hide()
	$Shadow.hide()
	
	#Load the background, then reparent to the battle scene to prevent lag
	add_child(battle.instantiate())
	$PaperBackground.show() 
	$PaperBackground.reparent($Battle)


var paper_rise = preload("res://scenes/paper_behavior/paper_rise.tscn")
var paper_wave = preload("res://scenes/paper_behavior/paper_wave.tscn")
func load_battle_background():
	$PaperBackground.add_child(paper_rise.instantiate())
	$PaperBackground.add_child(paper_wave.instantiate())
