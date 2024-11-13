extends Node2D

@export var quantity = 36
var paperHelper = 0

var paper = preload("res://scenes/paper_behavior/individual_paper/spin_paper.tscn")


func _on_stagger_timer_timeout() -> void:
	add_child(paper.instantiate())
	paperHelper += 1
	
	quantity -= 1
	if quantity <= 0:
		$StaggerTimer.stop()
