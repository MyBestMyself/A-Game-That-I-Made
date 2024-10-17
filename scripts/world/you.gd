extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var directionQueue = []
var facingRight = true

func _physics_process(delta: float) -> void:
	var directions = ["up", "down", "left", "right"]
	
	for direction in directions:
		if Input.is_action_just_pressed(direction):
			directionQueue.append(direction)
		elif Input.is_action_just_released(direction):
			directionQueue.erase(direction)
	
	if not $Dialogue.speaking:
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
