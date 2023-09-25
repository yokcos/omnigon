class_name ControlsInput
extends PanelContainer


var action: String = ""
var position : int = 0
var input : InputEvent = null setget set_input
var selecting: bool = false
var had_focus: bool = false
var grandfather: Control = null
var duration: float = 8
var velocity: Vector2 = Vector2()
var acceleration: Vector2 = Vector2(0, 200)
var rotation_speed: float = rand_range(-400, 400)

var pan_selected = preload("res://misc/selected_panel.tres")
var pan_unselected = preload("res://misc/unselected_panel.tres")

var txt_normal = "ESC to cancel, BACKSPACE to remove"
var txt_limited = "ESC to cancel"

const sprites_xbox = [
	preload("res://ui/controls/icons/controls_xbox1.png"),
	preload("res://ui/controls/icons/controls_xbox2.png"),
	preload("res://ui/controls/icons/controls_xbox3.png"),
	preload("res://ui/controls/icons/controls_xbox4.png"),
	preload("res://ui/controls/icons/controls_xbox5.png"),
	preload("res://ui/controls/icons/controls_xbox6.png"),
	preload("res://ui/controls/icons/controls_xbox7.png"),
	preload("res://ui/controls/icons/controls_xbox8.png"),
	preload("res://ui/controls/icons/controls_xbox9.png"),
	preload("res://ui/controls/icons/controls_xbox10.png"),
	preload("res://ui/controls/icons/controls_xbox11.png"),
	preload("res://ui/controls/icons/controls_xbox12.png"),
	preload("res://ui/controls/icons/controls_xbox13.png"),
	preload("res://ui/controls/icons/controls_xbox14.png"),
	preload("res://ui/controls/icons/controls_xbox15.png"),
	preload("res://ui/controls/icons/controls_xbox16.png"),
]


signal created
signal slain_selected


func _ready() -> void:
	connect("focus_exited", self, "_on_focus_lost")
	connect("focus_entered", self, "_on_focus_grabbed")
	call_deferred("grandfatherify")

func _process(delta: float) -> void:
	if !(get_parent() is Container):
		velocity += acceleration * delta
		rect_position += velocity * delta
		rect_rotation += rotation_speed * delta
		duration -= delta
		if duration <= 0:
			queue_free()

func _gui_input(event: InputEvent) -> void:
	if has_focus():
		if selecting:
			if event.is_action_pressed("ui_cancel"):
				unselect()
				get_viewport().set_input_as_handled()
			elif event.is_action_pressed("ui_backspace") and input and count_inputs() > 1:
				emit_signal("slain_selected")
				get_culled()
			elif (event is InputEventKey or event is InputEventJoypadButton) and event.pressed:
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


func grandfatherify():
	if !is_instance_valid(grandfather):
		grandfather = get_parent().father

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
	elif event != null:
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
	$icon.texture = null

func set_icon(what: int):
	$icon.texture = sprites_xbox[what]
	$text.text = ""

func get_text():
	return $text.text

func exclusivify_input(what: InputEvent):
	if what and is_instance_valid(grandfather):
		for i in grandfather.items:
			if !i.input:
				continue
			if i == self:
				continue
			if i.input.get_class() != what.get_class():
				continue
			
			if what is InputEventKey:
				if i.input.scancode == what.scancode:
					cull_other_input(i)
				
			if what is InputEventJoypadButton:
				if i.input.button_index == what.button_index:
					cull_other_input(i)

func cull_other_input(what: PanelContainer):
	what.get_culled()

func get_culled():
	var pos: Vector2 = rect_global_position
	rect_pivot_offset = rect_size / 2
	velocity = Vector2(500, -150).rotated(rand_range(-.4, .4))
	
	inject_into_action(null)
	get_parent().remove_child(self)
	
	grandfather.add_child(self)
	rect_global_position = pos


func count_inputs() -> int:
	var inputs: Array = []
	for i in InputMap.get_action_list(action):
		if i is InputEventKey:
			inputs.append(i)
	return inputs.size()

func set_input(what: InputEvent):
	input = what
	exclusivify_input(what)
	
	if what == null:
		set_text("+")
	elif what is InputEventKey:
		var this_scancode: String = OS.get_scancode_string(what.physical_scancode)
		if this_scancode == "":
			this_scancode = OS.get_scancode_string(what.scancode)
		set_text( this_scancode )
	elif what is InputEventJoypadButton:
		set_icon( what.button_index )

func _on_focus_grabbed():
	add_stylebox_override("panel", pan_selected)

func _on_focus_lost():
	unselect()
	add_stylebox_override("panel", pan_unselected)
