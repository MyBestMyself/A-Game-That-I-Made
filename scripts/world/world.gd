extends Node2D

var paper = preload("res://scenes/world/paper.tscn")
var area = load("res://scenes/world/areas/" + Global.currentArea + ".tscn")

func _ready() -> void:
	Global.startBattle.connect(start_battle)
	Global.run.connect(transition_to_world)
	
	setup()

#Hi Riley :o - Jack

func spread_paper(num):
	for x in range(num):
		$Papers.add_child(paper.instantiate())

func start_battle():
	$Table.hide()
	$Papers.hide()
	$Area.hide()

func transition_to_world():
	$Table.show()
	$Papers.show()
	$Area.show()

func kill_children():
	for x in $Papers.get_children():
		$Papers.remove_child(x)
		x.queue_free()

func setup():
	$Area.add_child(area.instantiate())
	spread_paper(1000)
