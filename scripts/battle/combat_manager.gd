extends Node

var rng = RandomNumberGenerator.new()

var tempBattleTextQueue = []

func queue_moves():
	var friendMove
	var enemyMove
	var friendSpeed = Global.field['Friends'][Global.selectedFriend]['Speed']
	var enemySpeed = Global.field['Enemies'][Global.selectedEnemy]['Speed']
	
	friendMove = {'Name':Global.field['Friends'][Global.selectedFriend]['Name'], 'Team':'Friend', 'Id':0, 'TargetId':0, 'Move':Global.selectedMove}
	if friendMove['Move'] not in Data.friends:
		friendSpeed += (friendMove['Move']['Priority'] * 1000)
	
	enemyMove = {'Name':Global.field['Enemies'][Global.selectedEnemy]['Name'], 'Team':'Enemy', 'Id':0, 'TargetId':0, 'Move':Data.moves[Global.field['Enemies'][Global.selectedEnemy]['Moves'][0]]}
	if enemyMove['Move'] not in Data.enemies:
		enemySpeed = (enemyMove['Move']['Priority'] * 1000)
	
	if friendSpeed > enemySpeed or Global.selectedMove in Data.friends:
		Global.moveQueue.append(friendMove)
		Global.moveQueue.append(enemyMove)
	else:
		Global.moveQueue.append(enemyMove)
		Global.moveQueue.append(friendMove)

func calculate_damage():
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
		elif move['Recivever'] == "User":
			target = Global.field['Friends'][targetId]
	elif team == "Enemy":
		user = Global.field['Enemies'][id]
		if move['Reciever'] == "Target":
			target = Global.field['Friends'][targetId]
		elif move['Recivever'] == "User":
			target = Global.field['Enemies'][targetId]
	
	var level = user['Level']
	var speed = user['Speed']
	var power = move['Power']
	var accuracy = move['Accuracy']
	
	if move['Category'] == "Physical" or move['Category'] == "Special":
		var strength
		var targetResistance
		if move['Category'] == "Physical":
			strength = user['Strength']
			targetResistance = target['Resistance']
		elif move['Category'] == "Special":
			strength = user['Smarts']
			targetResistance = target['Resolve']
		
		var sameTypeBonus = check_same_type(user, move)
		var critBonus = check_crit()
		var effectivenessMultiplier = effectiveness_multiplier(move['Type'], target['Type'])
		
		var damage = round((level/100.0) * power * (strength / targetResistance) * sameTypeBonus * critBonus * effectivenessMultiplier + 1)
		
		Global.calculatedDamage = damage
	else:
		Global.calculatedDamage = 0
	

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

func effectiveness_multiplier(moveType, targetType):
	var mult = 1
	
	var effectiveness = { 
		"Rock": {
			"strengths": ["Scissors", "Fire", "Bitter Cold", "Biohazard"],
			"weaknesses": ["Paper", "Water", "Vines", "Technology", "Terror"], 
			"immunities": ["Enlightened", "Dazed", "Bleeding"],
			"keywords": ["blunts", "smothers", "withstands", "neglects"]
		},
		"Paper": {
			"strengths": ["Rock", "Sight"], 
			"weaknesses": ["Scissors", "Fire", "Water"],
			"immunities": ["Sharpened", "Distracted", "Dazed"],
			"keywords": ["wraps", "eludes"]
		},
		"Scissors": {
			"strengths": ["Paper", "Vines", "Sight", "Terror"], 
			"weaknesses": ["Rock", "Fire", "Water", "Mind"],
			"immunities": ["Rock-Solid", "Bleeding", "Distracted"],
			"keywords": ["cuts", "trims", "ambushes", "defies"]
		},
		"Fire": {
			"strengths": ["Paper", "Scissors", "Vines", "Bitter Cold", "Biohazard"], 
			"weaknesses": ["Rock", "Water", "Technology", "Terror"],
			"immunities": ["Slippery", "Burnt", "Ensnared"],
			"keywords": ["ignites", "melts", "incinerates", "thaws", "erradicates"]
		},
		"Water": {
			"strengths": ["Rock", "Paper", "Scissors", "Fire", "Technology"], 
			"weaknesses": ["Vines", "Bitter Cold", "Biohazard", "Sight", "Terror"],
			"immunities": ["Flourishing", "Waterlogged", "Burnt"],
			"keywords": ["errodes", "cripples", "rusts", "extinguishes", "clogs"]
		},
		"Vines": {
			"strengths": ["Rock", "Water", "Technology"], 
			"weaknesses": ["Scissors", "Fire", "Bitter Cold", "Biohazard"],
			"immunities": ["Heated", "Ensnared", "Waterlogged"],
			"keywords": ["weather", "absorb", "oppress"]
		},
		"Technology": {
			"strengths": ["Rock", "Fire", "Biohazard", "Sight"], 
			"weaknesses": ["Water", "Vines", "Bitter Cold", "Mind"],
			"immunities": ["Numb", "Hacked", "Infected"],
			"keywords": ["excavates", "resolves", "cures", "rectifies"]
		},
		"Bitter Cold": {
			"strengths": ["Water", "Vines", "Technology", "Mind"], 
			"weaknesses": ["Rock", "Fire", "Biohazard"],
			"immunities": ["Immunized", "Frostbitten", "Hacked"],
			"keywords": ["freezes", "embrittles", "disrupts", "breaks"]
		},
		"Biohazard": {
			"strengths": ["Water", "Vines", "Mind", "Bitter Cold", "Terror"], 
			"weaknesses": ["Rock", "Fire", "Technology"],
			"immunities": ["Upgraded", "Infected", "Frostbitten"],
			"keywords": ["contaminates", "exterminates", "influences", "disregards", "blights"]
		},
		"Sight": {
			"strengths": ["Water", "Terror"], 
			"weaknesses": ["Paper", "Scissors", "Technology", "Mind"],
			"immunities": ["Headstrong", "Blind", "Terrified"],
			"keywords": ["percieves", "overlooks"]
		},
		"Mind": {
			"strengths": ["Scissors", "Technology", "Sight"], 
			"weaknesses": ["Biohazard", "Terror", "Bitter Cold"],
			"immunities": ["Oppressive", "Irrational", "Blind"],
			"keywords": ["outsmarts", "understands", "exploits"]
		},
		"Terror": {
			"strengths": ["Rock", "Fire", "Water", "Bitter Cold", "Mind", "Terror"], 
			"weaknesses": ["Scissors", "Biohazard", "Sight", "Terror"],
			"immunities": ["Perceptive", "Terrified", "Blind"],
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
	for x in tempBattleTextQueue:
		Global.battleTextQueue.append(x)
	tempBattleTextQueue.clear()
