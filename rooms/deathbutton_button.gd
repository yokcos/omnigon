extends Area2D


var tex_button: Texture = preload("res://props/interactables/button.png")
var tex_plunger: Texture = preload("res://props/interactables/plunger.png")

var plungermode: bool = false
var previous_activations: int = 0

var texts = [
	"Button that kills you instantly",
	"Button that killed you instantly",
	"Button that rewarded you handsomely",
	"Plunger that kills you instantly",
	"Plunger that killed you instantly",
	"Plunger that rewarded you handsomely",
]


func get_shifted():
	plungermode = !plungermode
	
	$interactable/sprite.texture = tex_plunger if plungermode else tex_button
	
	change_text()

func change_text():
	var index = 0
	index += previous_activations
	if plungermode: index += 3
	
	$interactable.description = texts[index]
	$interactable.destroy_tooltip()
