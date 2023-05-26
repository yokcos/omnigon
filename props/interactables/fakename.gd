extends Area2D


var hit_quotes = [
	"gadzooks",
	"egad",
	"oh no",
	"owie",
	"what n tarnation",
	"oof",
	"golly",
	"that hurts",
	"that smarts",
]
var sprites = [
	preload("res://props/interactables/fakename.png"),
	preload("res://props/interactables/fakename_robo.png"),
]
onready var interactables = [
	$interactable_normal,
	$interactable_robo,
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
	$sprite.hframes = 4 - mode*2
	
	for i in interactables:
		i.active = false
	interactables[mode].active = true

func get_punched():
	$animator.play("hit")
	var index = randi() % hit_quotes.size()
	$ouch.text = hit_quotes[index]

func get_shifted():
	set_mode(1 - mode)
