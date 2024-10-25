extends Node2D

var paper = load("res://scenes/paper_behavior/individual_paper/rising_paper.tscn")

func _on_timer_timeout() -> void:
	add_child(paper.instantiate())
