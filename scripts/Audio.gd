extends Node

func play_song(name):
	$Music.stream = load("res://assets/audio/music/" + name + ".ogg")
	$Music.play()
