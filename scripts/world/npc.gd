extends Node2D

var touchingPlayer = false

func _process(delta: float) -> void:
	if touchingPlayer and Input.is_action_just_pressed("confirm"):
		Global.currentSpeaker = name
		Global.playDialogue.emit()
func _on_flip_area_entered(area: Area2D) -> void:
	if abs($Sprite.scale.x) == 0.5:
		if $Sprite.scale.x > 0:
			$Animate.play("flip")
		else:
			$Animate.play_backwards("flip")


func _on_interact_area_entered(area: Area2D) -> void:
	touchingPlayer = true

func _on_interact_area_exited(area: Area2D) -> void:
	touchingPlayer = false
