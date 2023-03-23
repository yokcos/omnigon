extends Node2D


var limits: Vector2 = Vector2()


func _ready() -> void:
	limits = Rooms.room_size * Rooms.get_room_size(Rooms.current_room)
	$control/verb/instruction.text = "Press %s in order to" % Game.get_input_string("interact")
	
	var bac_colour = Game.background_colour
	$control/desc.add_color_override("font_outline_modulate", bac_colour)
	$control/verb/instruction.add_color_override("font_outline_modulate", bac_colour)
	$control/verb.add_color_override("font_outline_modulate", bac_colour)
	
	var brightness: float = (bac_colour.r + bac_colour.g + bac_colour.b)/3
	if brightness < 0.5:
		set_colour("b9bffb")

func _process(delta: float) -> void:
	var rect = $control.rect_size
	
	position.x = clamp(position.x, rect.x/2, limits.x - rect.x/2)
	position.y = clamp(position.y, rect.y  , limits.y           )


func set_colour(what: Color):
	$control/desc.add_color_override("font_color", what)
	$control/verb/instruction.add_color_override("font_color", what)
	$control/verb.add_color_override("font_color", what)

func set_desc(what: String):
	$control/desc.text = what

func set_verb(what: String):
	$control/verb.text = what
