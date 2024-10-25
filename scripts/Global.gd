extends Node

var currentArea = "boss"

#intro, transitioning, actions, moves, items, friends
var currentMenu
var battling = false

var displayedBattleText = []
var battleTextQueue = []

signal playDialogue
signal killDialogue
signal battleTransition
signal startBattle

#Battle
signal finishIntro
signal sendFriend
signal sendEnemy
signal friendInfo
signal enemyInfo
signal hideTrainer


#var cloneCount = 0
#func _process(delta: float) -> void:
	#print(cloneCount)
