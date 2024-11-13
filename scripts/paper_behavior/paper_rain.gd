extends Node2D

@export var quantity = 100

var paper = preload("res://scenes/paper_behavior/individual_paper/falling_paper.tscn")

func _on_initial_timer_timeout() -> void:
	$Timer.start()
	
	$KillTimer.wait_time = 2.5 + (quantity * $Timer.wait_time)
	$KillTimer.start()

func _on_timer_timeout() -> void:
	add_child(paper.instantiate())
	
	if quantity > 0:
		quantity -= 1
		$Timer.start()
	else:
		$BattleTimer.start()

func _on_battle_timer_timeout() -> void:
	Data.setup_battle()
	Global.startBattle.emit()

func _on_kill_timer_timeout() -> void:
	queue_free()
