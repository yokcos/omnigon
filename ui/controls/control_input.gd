extends PanelContainer


var action: String = ""
var position : int = 0
var input : InputEvent = null setget set_input
var selecting: bool = false
var had_focus: bool = false

var pan_selected = preload("res://misc/selected_panel.tres")
var pan_unselected = preload("res://misc/unselected_panel.tres")

var txt_normal = "ESC to cancel, BACKSPACE to remove"
var txt_limited = "ESC to cancel"


signal created


func _ready() -> void:
	connect("focus_exited", self, "_on_focus_lost")
	connect("focus_entered", self, "_on_focus_grabbed")

func _gui_input(event: InputEvent) -> void:
	if has_focus():
		if selecting:
			if event.is_action_pressed("ui_cancel"):
				unselect()
			elif event.is_action_pressed("ui_backspace") and input and count_inputs() > 1:
				inject_into_action(null)
				queue_free()
			elif event is InputEventKey and event.pressed:
				if input == null:
					emit_signal("created")
				inject_into_action(event)
				set_input(event)
				unselect()
		else:
			if event.is_action_pressed("ui_accept"):
				select()
	
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if event.button_index == BUTTON_LEFT and event.pressed:
			select()
	
	had_focus = has_focus()

func _pressed() -> void:
	select()


func inject_into_action(event):
	var inputs : Array = InputMap.get_action_list(action)
	var pos : int = inputs.find(input)
	
	if pos >= 0:
		for i in range(pos, inputs.size()):
			InputMap.action_erase_event(action, inputs[i])
		
		if event:
			InputMap.action_add_event(action, event)
		
		for i in range(pos+1, inputs.size()):
			InputMap.action_add_event(action, inputs[i])
	else:
		InputMap.action_add_event(action, event)

func unselect():
	selecting = false
	set_input(input)
	$cover.hide()

func select():
	if input and count_inputs() > 1:
		$cover/guide.text = txt_normal
	else:
		$cover/guide.text = txt_limited
	
	selecting = true
	set_text( "PRESS!" )
	$cover.show()

func set_text(what: String):
	$text.text = what

func get_text():
	return $text.text


func count_inputs() -> int:
	var inputs: Array = []
	for i in InputMap.get_action_list(action):
		if i is InputEventKey:
			inputs.append(i)
	return inputs.size()

func set_input(what: InputEvent):
	input = what
	
	if what == null:
		set_text("+")
	elif what is InputEventKey:
		set_text( OS.get_scancode_string(what.physical_scancode) )

func _on_focus_grabbed():
	add_stylebox_override("panel", pan_selected)

func _on_focus_lost():
	unselect()
	add_stylebox_override("panel", pan_unselected)
