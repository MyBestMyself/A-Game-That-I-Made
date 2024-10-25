extends Node2D

var paper = preload("res://scenes/world/paper.tscn")
var area = load("res://scenes/world/areas/" + Global.currentArea + ".tscn")

func _ready() -> void:
	Global.startBattle.connect(start_battle)
	
	spread_paper(1000)
	$Area.add_child(area.instantiate())

#Hi Riley :o - Jack

func spread_paper(num):
	for x in range(num):
		$Papers.add_child(paper.instantiate())

func start_battle():
	#kill children
	for x in $Papers.get_children():
		$Papers.remove_child(x)
		x.queue_free()
	
	$Table.hide()
	$Area.hide()
