extends Node

#{'Name':"I'm a little confused", 'Type':null, 'Specialty':null, 'Level':100, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':100, 'Current':100}, 'Conditions':[], 'Speed':100, 'Strength':100, 'Resistance':100, 'Smarts':100, 'Resolve': 100, 'Moves':[{'Name':'Kill', 'Stamina':1}]}
var friends = [
	{'Name':'Geobro', 'Type':'Rock', 'Specialty':null, 'Level':15, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':70, 'Current':70}, 'Conditions':[], 'Speed':50, 'Strength':85, 'Resistance':75, 'Smarts':25, 'Resolve': 45, 'Moves':["Blunt", "Dirt Laser", "Concuss", "Stonewall"], 'Stamina':{}},
	{'Name':'Leperaven', 'Type':'Biohazard', 'Specialty':null, 'Level':17, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':50, 'Current':50}, 'Conditions':[], 'Speed':55, 'Strength':70, 'Resistance':45, 'Smarts':75, 'Resolve': 55, 'Moves':["Blunt"], 'Stamina':{}},
	{'Name':'Watter', 'Type':'Water', 'Specialty':null, 'Level':12, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':20, 'Current':20}, 'Conditions':[], 'Speed':45, 'Strength':35, 'Resistance':40, 'Smarts':55, 'Resolve': 30, 'Moves':["Blunt"], 'Stamina':{}},
	{'Name':'Clumpy', 'Type':'Vines', 'Specialty':null, 'Level':10, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':100, 'Current':100}, 'Conditions':[], 'Speed':100, 'Strength':100, 'Resistance':100, 'Smarts':100, 'Resolve': 100, 'Moves':["Blunt"], 'Stamina':{}},
	{'Name':'Pancake Drone', 'Type':'Technology', 'Specialty':null, 'Level':5, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':100, 'Current':100}, 'Conditions':[], 'Speed':100, 'Strength':100, 'Resistance':100, 'Smarts':100, 'Resolve': 100, 'Moves':["Blunt"], 'Stamina':{}}
	]

var enemies = [
	{'Name':'Fish in a Barrel', 'Type':'Water', 'Specialty':null, 'Level':18, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':25, 'Current':25}, 'Conditions':[], 'Speed':55, 'Strength':80, 'Resistance':120, 'Smarts':60, 'Resolve': 110, 'Moves':["Squirt"], 'Stamina':{}},
	{'Name':'Barrel in a Fish', 'Type':'Water', 'Specialty':null, 'Level':20, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':85, 'Current':85}, 'Conditions':[], 'Speed':60, 'Strength':95, 'Resistance':85, 'Smarts':50, 'Resolve': 75, 'Moves':["Squirt"], 'Stamina':{}}
]
var moves = {
	"I'm a little confused" : {'Name':"I'm a little confused", 'Type':'Rock', 'Category':'Physical', 'Power':85, 'Accuracy':75, 'Stamina':75, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'User':{'Conditions':[], "Accuracy":null}, 'Target':{'Conditions':[], "Accuracy":null},'All':{'Conditions':[], "Accuracy":null}}, 'Other':null, 'Description':"I'm a little confused"},
	
	#Rock 
	'Blunt' : {'Name':'Blunt', 'Type':'Rock', 'Category':'Physical', 'Power':85, 'Accuracy':75, 'Stamina':25, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"Bop them with the hard part of your body, politely"},
	'Concuss' : {'Name':'Concuss', 'Type':'Rock', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':15, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Dazed"], "Accuracy":null}}, 'Description':"A precise bash between the eyes"},
	'Stonewall' : {'Name':'Stonewall', 'Type':'Rock', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':10, 'Reciever':'User', 'Hits':1, 'Priority':0, 'Effects':{'User':{'Conditions':["Rock-Solid"], "Accuracy":null}}, 'Description':"Defend against adversity by erecting some rocks"},
	
	'Dirt Laser' : {'Name':'Dirt Laser', 'Type':'Vines', 'Category':'Special', 'Power':100, 'Accuracy':90, 'Stamina':25, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"It's a dirt laser"},
	
	'Squirt' : {'Name':'Squirt', 'Type':'Water', 'Category':'Physical', 'Power':55, 'Accuracy':75, 'Stamina':25, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"Squirt"},
}

func setup_battle():
	#stamina
	for friend in friends:
		for move in friend['Moves']:
			if move not in friend['Stamina']:
				friend['Stamina'][move] = moves[move]['Stamina']
	for enemy in enemies:
		for move in enemy['Moves']:
			if move not in enemy['Stamina']:
				enemy['Stamina'][move] = moves[move]['Stamina']
	
	Global.field['Friends'].append(friends[0])
	Global.field['Enemies'].append(enemies[0])
