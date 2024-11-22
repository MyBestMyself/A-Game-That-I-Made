extends Node

#{'Name':"I'm a little confused", 'Type':null, 'Specialty':null, 'Level':100, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':100, 'Current':100}, 'Conditions':[], 'Speed':100, 'Strength':100, 'Resistance':100, 'Smarts':100, 'Resolve': 100, 'Moves':[{'Name':'Kill', 'Stamina':1}]}
var friends = [
	{'Name':'Geobro', 'Type':'Rock', 'Specialty':null, 'Level':15, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':70, 'Current':70}, 'Conditions':[], 'Speed':50, 'Strength':85, 'Resistance':75, 'Smarts':25, 'Resolve': 45, 'Moves':["Blunt", "Concuss", "Stonewall"], 'Stamina':{}},
	{'Name':'Leperaven', 'Type':'Biohazard', 'Specialty':null, 'Level':17, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':50, 'Current':50}, 'Conditions':[], 'Speed':55, 'Strength':70, 'Resistance':45, 'Smarts':75, 'Resolve': 55, 'Moves':["Pestilence", "Plague Bell", "Incision"], 'Stamina':{}},
	{'Name':'Frozen Yogurtle', 'Type':'Bitter Cold', 'Specialty':null, 'Level':16, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':90, 'Current':90}, 'Conditions':[], 'Speed':40, 'Strength':65, 'Resistance':100, 'Smarts':70, 'Resolve': 85, 'Moves':["Brain Freeze", "Chill Out", "Spit Flames", "Lock On"], 'Stamina':{}},
	{'Name':'Clumpy', 'Type':'Vines', 'Specialty':null, 'Level':13, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':40, 'Current':40}, 'Conditions':[], 'Speed':20, 'Strength':35, 'Resistance':50, 'Smarts':25, 'Resolve': 30, 'Moves':["Fistfull of Dirt", "Hate Mail", "Educate"], 'Stamina':{}},
	{'Name':'Pancake Drone', 'Type':'Technology', 'Specialty':null, 'Level':8, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':40, 'Current':40}, 'Conditions':[], 'Speed':95, 'Strength':45, 'Resistance':55, 'Smarts':90, 'Resolve': 75, 'Moves':["Cut", "Oil Up", "Barbed Garrote"], 'Stamina':{}}
	]

var enemies = [
	{'Name':'Fish in a Barrel', 'Type':'Water', 'Specialty':null, 'Level':18, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':25, 'Current':25}, 'Conditions':[], 'Speed':55, 'Strength':80, 'Resistance':120, 'Smarts':60, 'Resolve': 110, 'Moves':["Squirt", "Oil Up", "Educate"], 'Stamina':{}},
	{'Name':'Barrel in a Fish', 'Type':'Water', 'Specialty':null, 'Level':20, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':85, 'Current':85}, 'Conditions':[], 'Speed':60, 'Strength':95, 'Resistance':85, 'Smarts':50, 'Resolve': 75, 'Moves':["Squirt Gun", "Shoot"], 'Stamina':{}},
	{'Name':'Gelatoad', 'Type':'Bitter Cold', 'Specialty':null, 'Level':100, "Experience":{'Current':0, 'ToNextLevel':100}, 'Health':{'Max':85, 'Current':85}, 'Conditions':[], 'Speed':100, 'Strength':100, 'Resistance':100, 'Smarts':100, 'Resolve': 100, 'Moves':["The Pain Train"], 'Stamina':{}}
]
var moves = {
	"I'm a little confused" : {'Name':"I'm a little confused", 'Type':'Rock', 'Category':'Physical', 'Power':85, 'Accuracy':75, 'Stamina':75, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'User':{'Conditions':[], "Accuracy":100}, 'Target':{'Conditions':[], "Accuracy":100},'All':{'Conditions':[], "Accuracy":null}}, 'Other':null, 'Description':"I'm a little confused"},
	
	#Rock 
	'Blunt' : {'Name':'Blunt', 'Type':'Rock', 'Category':'Physical', 'Power':85, 'Accuracy':75, 'Stamina':25, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"Bop them with the hard part of your body, politely"},
	'Concuss' : {'Name':'Concuss', 'Type':'Rock', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':15, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Dazed"], "Accuracy":100}}, 'Description':"A precise bash between the eyes"},
	'Stonewall' : {'Name':'Stonewall', 'Type':'Rock', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':10, 'Reciever':'User', 'Hits':1, 'Priority':0, 'Effects':{'User':{'Conditions':["Rock-Solid"], "Accuracy":100}}, 'Description':"Defend against adversity by erecting some rocks"},
	
	#Paper
	'Wrap' : {'Name':'Wrap', 'Type':'Paper', 'Category':'Physical', 'Power':75, 'Accuracy':85, 'Stamina':30, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"Cover them with bank statements and drawings of trains"},
	'Hate Mail' : {'Name':'Hate Mail', 'Type':'Paper', 'Category':'Abstract', 'Power':100, 'Accuracy':80, 'Stamina':10, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Heated"], "Accuracy":50}}, 'Description':"Write them a strongly worded letter. Might make them a little angry, if they even care at all"},
	'Educate' : {'Name':'Educate', 'Type':'Paper', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':20, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Distracted"], "Accuracy":100}}, 'Description':"Overload their brain with misinformation"},
	
	
	#Scissors
	'Cut' : {'Name':'Cut', 'Type':'Scissors', 'Category':'Physical', 'Power':65, 'Accuracy':95, 'Stamina':35, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"Don't actually cut the paper because then I'll have to redraw it"},
	'Incision' : {'Name':'Incision', 'Type':'Scissors', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':10, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Bleeding"], "Accuracy":100}}, 'Description':"Delicately sever an artery"},
	'Barbed Garrote' : {'Name':'Barbed Garrote', 'Type':'Scissors', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':5, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Bleeding", "Ensnared"], "Accuracy":100}}, 'Description':"Entangle them in barbed wire"},
	
	#Fire
	'Spit Flames' : {'Name':'Spit Flames', 'Type':'Fire', 'Category':'Abstract', 'Power':95, 'Accuracy':70, 'Stamina':15, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Burnt"], "Accuracy":50}}, 'Description':"Spit bars of the highest caliber for immense psychological damage"},
	
	#Water
	'Squirt' : {'Name':'Squirt', 'Type':'Water', 'Category':'Physical', 'Power':40, 'Accuracy':100, 'Stamina':25, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"A pathetic little splash of water"},
	'Squirt Gun' : {'Name':'Squirt Gun', 'Type':'Water', 'Category':'Physical', 'Power':75, 'Accuracy':100, 'Stamina':15, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"An accurate, high-pressure jet of water"},
	'Oil Up' : {'Name':'Oil Up', 'Type':'Water', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':10, 'Reciever':'User', 'Hits':1, 'Priority':0, 'Effects':{'User':{'Conditions':["Slippery"], "Accuracy":100}}, 'Description':"Get slick with it"},
	
	#Vines
	'Fistfull of Dirt' : {'Name':'Fistfull of Dirt', 'Type':'Vines', 'Category':'Physical', 'Power':90, 'Accuracy':90, 'Stamina':10, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"A vegan-approved fighting style"},
	
	#Technology
	'Shoot' : {'Name':'Shoot', 'Type':'Technology', 'Category':'Physical', 'Power':100, 'Accuracy':100, 'Stamina':6, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Description':"Shoot them, impolitely"},
	
	#Bitter Cold
	'Brain Freeze' : {'Name':'Brain Freeze', 'Type':'Bitter Cold', 'Category':'Abstract', 'Power':35, 'Accuracy':100, 'Stamina':20, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Irrational"], "Accuracy":80}}, 'Description':"How could you think when you brain can't move?"},
	'Chill Out' : {'Name':'Chill Out', 'Type':'Bitter Cold', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':15, 'Reciever':'User', 'Hits':1, 'Priority':0, 'Effects':{'User':{'Conditions':["Numb"], "Accuracy":100}}, 'Description':"Stop. You are no longer cold"},
	
	#Biohazard
	'Pestilence' : {'Name':'Pestilence', 'Type':'Biohazard', 'Category':'Abstract', 'Power':85, 'Accuracy':90, 'Stamina':25, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Infected"], "Accuracy":25}}, 'Description':"Ravage their immune system"},
	'Plague Bell' : {'Name':'Plague Bell', 'Type':'Biohazard', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':5, 'Reciever':'Target', 'Hits':1, 'Priority':0, 'Effects':{'Target':{'Conditions':["Infected"], "Accuracy":100}}, 'Description':"Toll the bell; Their time runs thin"},
	
	#Sight
	'Lock On' : {'Name':'Lock On', 'Type':'Sight', 'Category':'Status', 'Power':0, 'Accuracy':100, 'Stamina':10, 'Reciever':'User', 'Hits':1, 'Priority':0, 'Effects':{'User':{'Conditions':["Perceptive"], "Accuracy":100}}, 'Description':"Take aim..."},
	
	#Mind
	
	#Terror
	'The Pain Train' : {'Name':'The Pain Train', 'Type':'Terror', 'Category':'Physical', 'Power':10000, 'Accuracy':100, 'Stamina':1, 'Reciever':'Target', 'Hits':1, 'Priority':1, 'Description':"Bring on the Pain Train"},
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
