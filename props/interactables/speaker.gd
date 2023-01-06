extends TextInteractable


var sign_title: String = ""
var sign_text: String = ""
var sign_egress: String = ""

var sign_highlight_distance: float = 48
var sign_description: String = ""
var sign_verb: String = "Obtain"
var sign_thru_walls: bool = false

var current_sfx: SFX = null


func _ready() -> void:
	Game.connect("popup_arisen", self, "_on_popup_arisen")


func summon_popup():
	.summon_popup()


func _on_popup_arisen(data):
	if data is Dictionary:
		if data["anchor"] == self:
			current_sfx = GlobalSound.play_random_sfx(GlobalSound.sfx_weewoo)
		elif current_sfx:
			current_sfx.queue_free()
	elif current_sfx:
		current_sfx.queue_free()

func _on_shift() -> void:
	var obj_thing = load("res://props/interactables/sign.tscn")
	var new_thing = obj_thing.instance()
	
	new_thing.title = sign_title
	new_thing.text = sign_text
	new_thing.egress = sign_egress
	
	new_thing.highlight_distance = sign_highlight_distance
	new_thing.description = sign_description
	new_thing.verb = sign_verb
	new_thing.thru_walls = sign_thru_walls
	
	Game.deploy_instance(new_thing, global_position)
	queue_free()
