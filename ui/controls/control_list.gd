extends HBoxContainer


export var action : String = "" setget set_action

const obj_button = preload("res://ui/controls/control_input.tscn")


func _ready() -> void:
	add_title()
	populate_list()


func add_title():
	var new_label = Label.new()
	new_label.text = name.capitalize()
	new_label.align = Label.ALIGN_RIGHT
	new_label.rect_min_size.x = 128
	add_child(new_label)

func cull_list():
	for i in get_children():
		if i is Button:
			i.queue_free()

func populate_list():
	var actions = InputMap.get_action_list(action)
	var actioncount = actions.size()
	
	for i in range(actioncount):
		var current_input = actions[i]
		if current_input is InputEventKey:
			var new_button = obj_button.instance()
			
			new_button.action = action
			new_button.input = current_input
			new_button.position = i
			
			add_child(new_button)


func set_action(what: String):
	action = what
