extends Node2D

func _ready() -> void:
	hide()
	
	Global.startBattle.connect(start_battle)
	Global.run.connect(run)

func _process(delta: float) -> void:
	$Label.text = str(Global.currentMenu)

func start_battle():
	show()

func run():
	hide()
