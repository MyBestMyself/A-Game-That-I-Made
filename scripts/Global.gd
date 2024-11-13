extends Node

var currentArea = "boss"

#intro, transitioning, battling, actions, moves, items, friends
var currentMenu = null
var battling = false

var calculatedDamage
var displayedBattleText = []
var battleTextQueue = []
var moveQueue = [] #{team':'friend', id:0, targetid:0 'move':"Blunt"}, ...
var field = {'Friends':[], 'Enemies':[]}
var selectedFriend = 0 #field id, used in multi battles and nothing else
var selectedEnemy = 0 
var selectedMove

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
signal switchFriend
signal switchEnemy
signal showMoves
signal showFriendsList
signal showMoveDetails
signal hideMoveDetails
signal hideTrainer
signal startNextTurn
signal displayMoveText
signal attack
signal takeDamage
signal run


#var cloneCount = 0
#func _process(delta: float) -> void:
	#print(cloneCount)

func clear_battle():
	currentMenu = null
	calculatedDamage = 0
	displayedBattleText = []
	battleTextQueue = []
	moveQueue = [] 
	field = {'Friends':[], 'Enemies':[]}
	selectedFriend = 0
	selectedEnemy = 0 
	selectedMove = {}
