extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	
	$YouName.frame = rng.randi_range(0,7)
	$YouNameShadow.frame = $YouName.frame
	
	$BossName.frame = rng.randi_range(0,7)
	$BossNameShadow.frame = $BossName.frame
	
	
	$Base.rotation_degrees = randf_range(-5, 5)
	$Shadow.rotation_degrees = $Base.rotation_degrees
	
	$You.rotation_degrees = randf_range(-7.5, 7.5)
	$YouShadow.rotation_degrees = $You.rotation_degrees
	$YouName.rotation_degrees = randf_range(-2.5, 2.5)
	$YouNameShadow.rotation_degrees = $YouName.rotation_degrees
	
	$Versus.rotation_degrees = randf_range(-15, 15)
	$VersusShadow.rotation_degrees = $Versus.rotation_degrees
	
	$Boss.rotation_degrees = randf_range(-7.5, 7.5)
	$BossShadow.rotation_degrees = $Boss.rotation_degrees
	$BossName.rotation_degrees = randf_range(-7.5, 7.5)
	$BossNameShadow.rotation_degrees = $BossName.rotation_degrees
	
	if Dialogue.currentSpeaker != null:
		$Boss.texture = load("res://sprites/characters/" + Dialogue.currentSpeaker + "Big.png")
		$BossShadow.texture = load("res://sprites/characters/" + Dialogue.currentSpeaker + "Big.png")
		
		$BossName/Label.text = Dialogue.currentSpeaker

func _on_kill_timer_timeout() -> void:
	queue_free()
