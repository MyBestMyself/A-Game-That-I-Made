extends Node

var currentArea = "boss"

#intro, transitioning, battling, actions, moves, items, friends
var currentMenu = null
var battling = false
var speaking = false

var calculatedDamage = 0
var appliedConditions
var displayedBattleText = []
var battleTextQueue = []
var moveQueue = [] #{team':'friend', id:0, targetid:0 'move':"Blunt"}, ...
var field = {'Friends':[], 'Enemies':[]}
var currentFriend = 0 #friend in relation to friends list
var currentEnemy = 0
var selectedFriend = 0 #field id, used in multi battles and nothing else
var selectedEnemy = 0 
var fieldCapacity = 1 #Number of friends per team
var selectedMove
var selectedStatusCondition #{Condition: ..., Id: ..., Team: ...}

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
signal hideFriendInfo
signal hideEnemyInfo
signal switchFriend
signal switchEnemy
signal downFriend(friendNum)
signal downEnemy(enemyNum)
signal checkCondition(targetTeam, targetId)
signal checkForDown
signal showMoves
signal showFriendsList
signal showMoveDetails
signal hideMoveDetails
signal showStatusDetails
signal hideStatusDetails
signal hideTrainer
signal startNextTurn
signal displayMoveText
signal attack
signal takeDamage
signal resumeBattleAfterDown
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
	
	#temporary
	Data.friends = [
	{'Name':'Geobro', 'Type':'Rock', 'Specialty':null, 'Level':15, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':70, 'Current':70}, 'Conditions':[], 'Speed':50, 'Strength':85, 'Resistance':75, 'Smarts':25, 'Resolve': 45, 'Moves':["Blunt", "Concuss", "Stonewall"], 'Stamina':{}},
	{'Name':'Leperaven', 'Type':'Biohazard', 'Specialty':null, 'Level':17, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':50, 'Current':50}, 'Conditions':[], 'Speed':55, 'Strength':70, 'Resistance':45, 'Smarts':75, 'Resolve': 55, 'Moves':["Pestilence", "Plague Bell", "Incision"], 'Stamina':{}},
	{'Name':'Frozen Yogurtle', 'Type':'Bitter Cold', 'Specialty':null, 'Level':16, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':90, 'Current':90}, 'Conditions':[], 'Speed':40, 'Strength':65, 'Resistance':100, 'Smarts':70, 'Resolve': 85, 'Moves':["Brain Freeze", "Chill Out", "Spit Flames", "Lock On"], 'Stamina':{}},
	{'Name':'Clumpy', 'Type':'Vines', 'Specialty':null, 'Level':13, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':40, 'Current':40}, 'Conditions':[], 'Speed':20, 'Strength':35, 'Resistance':50, 'Smarts':25, 'Resolve': 30, 'Moves':["Fistfull of Dirt", "Hate Mail", "Educate"], 'Stamina':{}},
	{'Name':'Pancake Drone', 'Type':'Technology', 'Specialty':null, 'Level':8, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':40, 'Current':40}, 'Conditions':[], 'Speed':95, 'Strength':45, 'Resistance':55, 'Smarts':90, 'Resolve': 75, 'Moves':["Cut", "Oil Up", "Barbed Garrote"], 'Stamina':{}}
	]
	
	Data.enemies = [
	{'Name':'Fish in a Barrel', 'Type':'Water', 'Specialty':null, 'Level':18, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':25, 'Current':25}, 'Conditions':[], 'Speed':55, 'Strength':80, 'Resistance':120, 'Smarts':60, 'Resolve': 110, 'Moves':["Squirt", "Oil Up", "Educate"], 'Stamina':{}},
	{'Name':'Barrel in a Fish', 'Type':'Water', 'Specialty':null, 'Level':20, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':85, 'Current':85}, 'Conditions':[], 'Speed':60, 'Strength':95, 'Resistance':85, 'Smarts':50, 'Resolve': 75, 'Moves':["Squirt Gun", "Shoot"], 'Stamina':{}},
	{'Name':'Gelatoad', 'Type':'Bitter Cold', 'Specialty':null, 'Level':100, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':85, 'Current':85}, 'Conditions':[], 'Speed':100, 'Strength':100, 'Resistance':100, 'Smarts':100, 'Resolve': 100, 'Moves':["The Pain Train"], 'Stamina':{}}
]
