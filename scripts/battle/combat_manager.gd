extends Node

var rng = RandomNumberGenerator.new()

var tempBattleTextQueue = []
var appliedConditions

var strengthMult = 1.00
var smartsMult = 1.00
var accuracyMult = 1.00
var targetResistanceMult = 1.00
var targetResolveMult = 1.00
var targetDodgeMult = 1.00

func queue_moves():
	rng.randomize()
	var friendMove
	var enemyMove
	
	var friendLevel = Global.field['Friends'][Global.selectedFriend]['Level'] 
	var enemyLevel = Global.field['Enemies'][Global.selectedEnemy]['Level']
	var friendSpeed = (Global.field['Friends'][Global.selectedFriend]['Speed'] * (0.05) * friendLevel) * get_speed_multiplier(Global.field['Friends'][Global.selectedFriend]['Conditions'])
	var enemySpeed = (Global.field['Enemies'][Global.selectedEnemy]['Speed'] * (0.05) * enemyLevel) * get_speed_multiplier(Global.field['Enemies'][Global.selectedEnemy]['Conditions'])
	
	friendMove = {'Name':Global.field['Friends'][Global.selectedFriend]['Name'], 'Team':'Friend', 'Id':0, 'TargetId':0, 'Move':Global.selectedMove}
	if friendMove['Move'] not in Data.friends:
		friendSpeed += (friendMove['Move']['Priority'] * 1000)
	
	var num = rng.randi_range(0, Global.field['Enemies'][Global.selectedEnemy]['Moves'].size() - 1)
	enemyMove = {'Name':Global.field['Enemies'][Global.selectedEnemy]['Name'], 'Team':'Enemy', 'Id':0, 'TargetId':0, 'Move':Data.moves[Global.field['Enemies'][Global.selectedEnemy]['Moves'][num]]}
	if enemyMove['Move'] not in Data.enemies:
		enemySpeed += (enemyMove['Move']['Priority'] * 1000)
	
	if friendSpeed > enemySpeed or Global.selectedMove in Data.friends:
		Global.moveQueue.append(friendMove)
		Global.moveQueue.append(enemyMove)
	else:
		Global.moveQueue.append(enemyMove)
		Global.moveQueue.append(friendMove)

func calculate_damage():
	Global.calculatedDamage = 0
	Global.appliedConditions = {} #{['Team', 'Id'] : '[Conditions]'}
	
	rng.randomize()
	
	var id = Global.moveQueue[0]['Id']
	var targetId = Global.moveQueue[0]['TargetId']
	var team = Global.moveQueue[0]['Team']
	var move = Global.moveQueue[0]['Move']
	
	var user
	var target
	if team == "Friend":
		user = Global.field['Friends'][id]
		if move['Reciever'] == "Target":
			target = Global.field['Enemies'][targetId]
		elif move['Reciever'] == "User":
			target = Global.field['Friends'][targetId]
	elif team == "Enemy":
		user = Global.field['Enemies'][id]
		if move['Reciever'] == "Target":
			target = Global.field['Friends'][targetId]
		elif move['Reciever'] == "User":
			target = Global.field['Enemies'][targetId]
	
	var level = user['Level']
	var targetLevel = target['Level']
	var power = move['Power']
	var accuracy = move['Accuracy'] * accuracyMult
	
	#check accuracy
	var dodgeChance = (rng.randi_range(0, 100)) * targetDodgeMult
	if accuracy < dodgeChance:
		tempBattleTextQueue.append("...but it missed")
		return true
	
	if 'Effects' in move:
		apply_status_conditions(move, team, id, targetId)
	
	if move['Category'] == "Physical" or move['Category'] == "Abstract":
		set_status_multipliers(user['Conditions'], target['Conditions'])
		
		var strength 
		var targetResistance
		if move['Category'] == "Physical":
			strength = (user['Strength'] * (0.05) * level) * strengthMult
			targetResistance = (target['Resistance'] * (0.05) * targetLevel) * targetResistanceMult
		elif move['Category'] == "Abstract":
			strength = (user['Smarts'] * (0.05) * level) * smartsMult
			targetResistance = (target['Resolve'] * (0.05) * targetLevel) * targetResolveMult
		
		var sameTypeBonus = check_same_type(user, move)
		var critBonus = check_crit()
		var effectivenessMultiplier = effectiveness_multiplier(move['Type'], target['Type'])
		
		var damage = round((level/100.0) * power * (strength / targetResistance) * sameTypeBonus * critBonus * effectivenessMultiplier + 1)
		
		Global.calculatedDamage = damage
	
	return false

func apply_status_conditions(move, team, id, targetId):
	rng.randomize()
	
	var targetTeam
	if team == "Friend":
		team = "Friends"
		targetTeam = "Enemies"
	elif team == "Enemy":
		team = "Enemies"
		targetTeam = "Friends"
	
	if 'User' in move['Effects']:
		var conditions = move['Effects']['User']
		
		for effect in conditions['Conditions']:
			var targetType = Global.field[team][id]['Type']
			var dodgeChance = (rng.randi_range(0, 100)) * targetDodgeMult
			if check_condition_immunity(effect, targetType, team, id) and dodgeChance <= conditions['Accuracy'] * accuracyMult:
				if [team, id] not in Global.appliedConditions:
					Global.appliedConditions[[team, id]] = []
				Global.appliedConditions[[team, id]].append(effect)
				tempBattleTextQueue.append(Global.field[team][id]['Name'] + " is now " + effect)
	
	if 'Target' in move['Effects']:
		var conditions = move['Effects']['Target']
		
		for effect in conditions['Conditions']:
			var targetType = Global.field[targetTeam][targetId]['Type']
			var dodgeChance = (rng.randi_range(0, 100)) * targetDodgeMult
			if check_condition_immunity(effect, targetType, targetTeam, targetId) and dodgeChance <= conditions['Accuracy'] * accuracyMult:
				if [targetTeam, targetId] not in Global.appliedConditions:
					Global.appliedConditions[[targetTeam, targetId]] = []
				Global.appliedConditions[[targetTeam, targetId]].append(effect)
				tempBattleTextQueue.append(Global.field[targetTeam][targetId]['Name'] + " is now " + effect)

func get_speed_multiplier(conditions):
	var speedMult = 1.00
	
	var statMap = {
		"Slippery": 0.25,
		"Heated": 0.25,
		"Ensnared": -0.25,
		"Waterlogged": -0.25
	}
	
	for condition in conditions:
		if condition in statMap:
			speedMult += statMap[condition]
	
	return speedMult

func set_status_multipliers(conditions, targetConditions):
	strengthMult = 1.00
	smartsMult = 1.00
	accuracyMult = 1.00
	targetResistanceMult = 1.00
	targetResolveMult = 1.00
	targetDodgeMult = 1.00
	
	#Disregarding hp and speed
	var statMap = {
		"Sharpened": {"Strength": .50},
		"Rock-Solid": {"Resistance": .50},
		"Enlightened": {"Smarts": .50},
		"Headstrong": {"Resolve": .50},
		"Slippery": {"Dodge": .25},
		"Heated": {"Accuracy": .25},
		"Perceptive": {"Dodge": .25, "Accuracy": .25},
		"Immunized": {"Dodge": .25},
		"Upgraded": {"Strength": .25, "Smarts": .25},
		"Numb": {"Resistance": .25, "Resolve": .25},
		"Oppressive": {},
		
		"Burnt": {"Strength": -0.25},
		"Bleeding": {"Resistance": -0.25},
		"Frostbitten": {"Smarts": -0.25},
		"Infected": {"Resolve": -0.25},
		"Ensnared": {"Strength": -0.25},
		"Waterlogged": {"Smarts": -0.25},
		"Dazed": {"Dodge": -0.25, "Resistance": -0.25},
		"Hacked": {"Dodge": -0.25, "Resolve": -0.25},
		"Distracted": {"Strength": -0.25, "Resistance": -0.25},
		"Irrational": {"Smarts": -0.25, "Resolve": -0.25},
		"Blind": {"Accuracy": -0.50},
		"Terrified": {},
	}
	
	for condition in conditions:
		if condition in statMap:
			var statChanges = statMap[condition]
			for stat in statChanges.keys():
				if stat == "Strength":
					strengthMult += statChanges[stat]
				elif stat == "Smarts":
					smartsMult += statChanges[stat]
				elif stat == "Accuracy":
					accuracyMult += statChanges[stat]
	
	for condition in targetConditions:
		if condition in statMap:
			var statChanges = statMap[condition]
			for stat in statChanges.keys():
				if stat == "Resistance":
					targetResistanceMult += statChanges[stat]
				elif stat == "Resolve":
					targetResolveMult += statChanges[stat]
				elif stat == "Dodge":
					targetDodgeMult += statChanges[stat]

func check_same_type(user, move):
	if user['Type'] == move['Type']:
		return 1.5
	else:
		return 1

func check_crit():
	var num = rng.randi_range(1, 16)
	if num == 16:
		tempBattleTextQueue.append("Critical hit!")
		return 1.5
	else:
		return 1

func check_condition_immunity(effect, targetType, team, id):
	var immunities = { 
		"Rock": ["Enlightened", "Dazed", "Bleeding"],
		"Paper": ["Sharpened", "Distracted", "Dazed"],
		"Scissors": ["Rock-Solid", "Bleeding", "Distracted"],
		"Fire": ["Slippery", "Burnt", "Ensnared"],
		"Water": ["Flourishing", "Waterlogged", "Burnt"],
		"Vines": ["Heated", "Ensnared", "Waterlogged"],
		"Technology": ["Numb", "Hacked", "Infected"],
		"Bitter Cold": ["Immunized", "Frostbitten", "Hacked"],
		"Biohazard": ["Upgraded", "Infected", "Frostbitten"],
		"Sight": ["Headstrong", "Blind", "Terrified"],
		"Mind": ["Oppressive", "Irrational", "Blind"],
		"Terror": ["Perceptive", "Terrified", "Blind"],
	}
	
	if effect in Global.field[team][id]['Conditions']:
		tempBattleTextQueue.append(Global.field[team][id]['Name'] + " is already " + effect)
		return false
	elif effect in immunities[targetType]:
		tempBattleTextQueue.append(Global.field[team][id]['Name'] + " is immune to " + effect)
		return false
	else:
		return true

func effectiveness_multiplier(moveType, targetType):
	var mult = 1
	
	var effectiveness = { 
		"Rock": {
			"strengths": ["Scissors", "Fire", "Bitter Cold", "Biohazard"],
			"weaknesses": ["Paper", "Water", "Vines", "Technology", "Terror"], 
			"keywords": ["blunts", "smothers", "withstands", "neglects"]
		},
		"Paper": {
			"strengths": ["Rock", "Sight"], 
			"weaknesses": ["Scissors", "Fire", "Water"],
			"keywords": ["wraps", "eludes"]
		},
		"Scissors": {
			"strengths": ["Paper", "Vines", "Sight", "Terror"], 
			"weaknesses": ["Rock", "Fire", "Water", "Mind"],
			"keywords": ["cuts", "trims", "ambushes", "defies"]
		},
		"Fire": {
			"strengths": ["Paper", "Scissors", "Vines", "Bitter Cold", "Biohazard"], 
			"weaknesses": ["Rock", "Water", "Technology", "Terror"],
			"keywords": ["ignites", "melts", "incinerates", "thaws", "erradicates"]
		},
		"Water": {
			"strengths": ["Rock", "Paper", "Scissors", "Fire", "Technology"], 
			"weaknesses": ["Vines", "Bitter Cold", "Biohazard", "Sight", "Terror"],
			"keywords": ["errodes", "cripples", "rusts", "extinguishes", "clogs"]
		},
		"Vines": {
			"strengths": ["Rock", "Water", "Technology"], 
			"weaknesses": ["Scissors", "Fire", "Bitter Cold", "Biohazard"],
			"keywords": ["weather", "absorb", "oppress"]
		},
		"Technology": {
			"strengths": ["Rock", "Fire", "Biohazard", "Sight"], 
			"weaknesses": ["Water", "Vines", "Bitter Cold", "Mind"],
			"keywords": ["excavates", "resolves", "cures", "rectifies"]
		},
		"Bitter Cold": {
			"strengths": ["Water", "Vines", "Technology", "Mind"], 
			"weaknesses": ["Rock", "Fire", "Biohazard"],
			"keywords": ["freezes", "embrittles", "disrupts", "breaks"]
		},
		"Biohazard": {
			"strengths": ["Water", "Vines", "Mind", "Bitter Cold", "Terror"], 
			"weaknesses": ["Rock", "Fire", "Technology"],
			"keywords": ["contaminates", "exterminates", "influences", "disregards", "blights"]
		},
		"Sight": {
			"strengths": ["Water", "Terror"], 
			"weaknesses": ["Paper", "Scissors", "Technology", "Mind"],
			"keywords": ["percieves", "overlooks"]
		},
		"Mind": {
			"strengths": ["Scissors", "Technology", "Sight"], 
			"weaknesses": ["Biohazard", "Terror", "Bitter Cold"],
			"keywords": ["outsmarts", "understands", "exploits"]
		},
		"Terror": {
			"strengths": ["Rock", "Fire", "Water", "Bitter Cold", "Mind", "Terror"], 
			"weaknesses": ["Scissors", "Biohazard", "Sight", "Terror"],
			"keywords": ["beats", "beats", "beats", "beats", "beats", "beats"]
		}
	}
	
	if targetType in effectiveness[moveType]["strengths"]:
		mult = 2
		var index = effectiveness[moveType]["strengths"].find(targetType)
		var keyword = effectiveness[moveType]['keywords'][index]
		tempBattleTextQueue.append(moveType + " " + keyword + " " + targetType)
	elif targetType in effectiveness[moveType]["weaknesses"]:
		mult = 0.5
		tempBattleTextQueue.append("It didn't do much")
	
	return mult

func append_move_text():
	#check for down
	var failMessages = ["collapsed!", "is down!", "tapped out!"]
	
	for id in range(len(Global.field['Friends'])):
		var friend = Global.field['Friends'][id]
		if friend['Health']['Current'] <= 0:
			tempBattleTextQueue.append([id, "Friend", str(friend['Name']) + " " + failMessages[rng.randi_range(0, 2)]])
			Global.hideFriendInfo.emit()
	
	for id in range(len(Global.field['Enemies'])):
		var enemy = Global.field['Enemies'][id]
		if enemy['Health']['Current'] <= 0:
			tempBattleTextQueue.append([id, "Enemy", str(enemy['Name']) + " " + failMessages[rng.randi_range(0, 2)]])
			Global.hideEnemyInfo.emit()
	
	
	for x in tempBattleTextQueue:
		Global.battleTextQueue.append(x)
	tempBattleTextQueue.clear()
