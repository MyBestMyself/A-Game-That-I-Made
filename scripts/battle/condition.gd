extends Node2D

@export var condNum = 0
var id
var team

var icon

var rng = RandomNumberGenerator.new()
var inPlay = false

func _ready() -> void:
	Global.checkCondition.connect(check_condition)

func check_condition(targetTeam, targetId):
	if team == targetTeam and id == targetId:
		if condNum < Global.field[team][targetId]["Conditions"].size():
			if not inPlay:
				inPlay = true
				setup(team, targetId)
				$Animate.play("Popup")
		elif inPlay:
			inPlay = false
			$Animate.play("RESET")

func setup(team, targetId):
	$Base.frame = rng.randi_range(0, 3)
	$Shadow.frame = $Base.frame
	
	$Base.rotation_degrees = rng.randf_range(-15, 15)
	$Shadow.rotation_degrees = $Base.rotation_degrees
	
	icon = Global.field[team][targetId]["Conditions"][condNum]
	$Base/Icon.texture = load("res://sprites/battle/statusConditions/" + icon + ".png")

func make_unselectable():
	$Hitbox.input_pickable = false

func _on_hitbox_mouse_entered() -> void:
	$Animate.play("Select")
	Global.selectedStatusCondition = {'Condition': icon, 'Id': id, 'Team': team}
	Global.showStatusDetails.emit()

func _on_hitbox_mouse_exited() -> void:
	$Animate.play_backwards("Select")
	Global.hideStatusDetails.emit()
