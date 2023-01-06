extends Area2D


export (float) var highlight_distance = 48
export (String) var description_button = "Button"
export (String) var description_plunger = "Plunger"
export (String) var verb = "Press"
export (bool) var thru_walls = false
export (bool) var plungermode = false

var tex_button: Texture = preload("res://props/interactables/button.png")
var tex_plunger: Texture = preload("res://props/interactables/plunger.png")

signal activated


func _ready() -> void:
	$interactable.highlight_distance = highlight_distance
	$interactable.verb = verb
	$interactable.thru_walls = thru_walls
	change_sprite()
	change_text()


func get_shifted():
	plungermode = !plungermode
	
	change_sprite()
	change_text()

func change_sprite():
	$interactable/sprite.texture = tex_plunger if plungermode else tex_button

func change_text():
	var prev_text = $interactable.description
	var text: String = description_plunger if plungermode else description_button
	
	if text != prev_text:
		$interactable.description = text
		$interactable.destroy_tooltip()


func _on_interactable_activated() -> void:
	emit_signal("activated")
	
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_pop, global_position)
