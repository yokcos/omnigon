extends Node


export (String) var url = ""


func activate():
	OS.shell_open(url)
