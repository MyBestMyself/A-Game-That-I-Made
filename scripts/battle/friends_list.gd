extends Node2D

@export var canResetFriends = true

var friend = preload("res://scenes/battle/selected_friend.tscn")
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	kill_friends()
	
	for x in range(Data.friends.size()):
		$Friends.add_child(friend.instantiate())
		$Friends.get_child(x).id = x
		$Friends.get_child(x).setup()
	
	setup()

func setup():
	if canResetFriends:
		rng.randomize()
		$Base.rotation_degrees = randf_range(-1, 1)
		$Shadow.rotation_degrees = $Base.rotation_degrees
		
		for x in $Friends.get_children():
			x.setup()

func kill_friends():
	for x in $Friends.get_children():
		$Friends.remove_child(x)
		x.queue_free()
