extends Control


var active: bool = true

const obj_hats = preload("res://ui/hats.tscn")

signal quit


func _ready() -> void:
	seize_focus()
	connect_list()


func connect_list():
	var buttons = $buttons.get_children()
	var first: Button = buttons[0]
	var last: Button = buttons[buttons.size() - 1]
	
	var f2l: NodePath = first.get_path_to(last)
	var l2f: NodePath = last.get_path_to(first)
	
	first.focus_neighbour_top = f2l
	last.focus_neighbour_bottom = l2f
	
	first.focus_previous = f2l
	last.focus_next = l2f

func seize_focus():
	$buttons.get_children()[0].grab_focus()
	active = true
	enable_buttons()

func enable_buttons():
	for i in $buttons.get_children():
		i.disabled = false

func disable_buttons():
	for i in $buttons.get_children():
		i.disabled = true

func summon_hat_menu():
	var new_hats = obj_hats.instance()
	new_hats.connect("quit", self, "_on_overlayer_quit")
	new_hats.pause_mode = PAUSE_MODE_PROCESS
	Game.deploy_ui_instance(new_hats, Vector2())
	
	get_parent().hide()
	active = false

func egress():
	emit_signal("quit")


func _on_hats_pressed() -> void:
	if active:
		call_deferred("summon_hat_menu")

func _on_egress_pressed() -> void:
	if active:
		egress()

func _on_overlayer_quit():
	get_parent().show()
	disable_buttons()
	call_deferred("seize_focus")
