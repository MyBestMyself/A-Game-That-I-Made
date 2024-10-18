extends Node

func play(name):
	$Music.stream = load("res://assets/audio/music/" + name + ".mp3")
	$Music.play()
