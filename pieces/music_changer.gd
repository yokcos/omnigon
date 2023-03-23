extends Node


export (String) var music


func activate():
	GlobalSound.play_temp_music(music)
