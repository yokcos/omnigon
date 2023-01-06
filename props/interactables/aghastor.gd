extends Area2D


var hit_quotes = [
	"ouch!",
	"hey!",
	"stop that",
	"owie!",
	"oof.",
	"why",
	"you charlatan",
	"you knave",
	"gah!",
]
var sprites = [
	preload("res://props/interactables/aghastor.png"),
	preload("res://props/interactables/guillaume.png"),
]
onready var interactables = [
	$interactable_aghastor,
	$interactable_guillaume,
]
var mode: int = 0


func _ready() -> void:
	add_to_group("saveables")


func get_saved():
	return {
		"mode": mode
	}

func get_loaded(what: Dictionary):
	set_mode(what["mode"])

func set_mode(what):
	mode = what
	$sprite.texture = sprites[mode]
	
	for i in interactables:
		i.active = false
	interactables[mode].active = true

func get_punched():
	$animator.play("hit")
	var index = randi() % hit_quotes.size()
	$ouch.text = hit_quotes[index]

func get_shifted():
	set_mode(1 - mode)
