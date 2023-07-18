class_name ControlsList
extends HBoxContainer


export var action : String = "" setget set_action

var father: Control = null

const obj_button = preload("res://ui/controls/control_input.tscn")


signal list_changed


func _ready() -> void:
	add_title()
	populate_list()


func add_title():
	var new_label = Label.new()
	new_label.text = name.capitalize()
	new_label.align = Label.ALIGN_RIGHT
	new_label.rect_min_size.x = 128
	add_child(new_label)

func add_extra_button():
	var new_button = obj_button.instance()
	
	new_button.action = action
	new_button.position = InputMap.get_action_list(action).size()
	new_button.set_text("+")
	new_button.connect("created", self, "_on_button_created")
	new_button.connect("tree_exited", self, "_on_button_slain")
	
	add_child(new_button)

func rejiggle_list():
	var items: Array = []
	
	for i in get_children():
		if i is PanelContainer:
			items.append(i)
	
	for i in range(items.size()):
		var this_item = items[i]
		this_item.position = i

func populate_list():
	var actions = InputMap.get_action_list(action)
	var actioncount = actions.size()
	
	for i in range(actioncount):
		var current_input = actions[i]
		if current_input is InputEventKey or current_input is InputEventJoypadButton:
			var new_button = obj_button.instance()
			
			new_button.action = action
			new_button.input = current_input
			new_button.position = i
			new_button.connect("created", self, "_on_button_created")
			new_button.connect("tree_exited", self, "_on_button_slain")
			
			add_child(new_button)
	
	add_extra_button()


func set_action(what: String):
	action = what

func _on_button_created():
	add_extra_button()
	emit_signal("list_changed")

func _on_button_slain():
	if is_inside_tree():
		rejiggle_list()
		emit_signal("list_changed")
		get_children()[1].grab_focus()
