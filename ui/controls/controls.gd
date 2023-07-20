extends Control


var animation_duration = 0.5
var lists: Array = []
var items: Array = []
var presets: Dictionary = {}
var queued_recatalogue: bool = false
onready var list = $scroller/list


func _ready() -> void:
	fatherify_buttons()
	arrive_animation()
	queue_recatalogue()
	
	catalogue_presets()
	deploy_presets()
	select_first_preset()
	
	for i in list.get_children():
		if i is ControlsList:
			i.connect("list_changed", self, "_on_list_changed")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		depart_animation()

func _process(delta: float) -> void:
	scroll(delta)


func select_first_preset():
	for i in $scroller/list/presets_scroller/presets.get_children():
		if i is Button:
			i.grab_focus()
			break

func scroll(delta: float):
	var focus: Control = get_focus_owner()
	if is_instance_valid(focus):
		var focus_position: Vector2 = focus.rect_global_position + focus.rect_size/2
		var centre: Vector2 = rect_size / 2
		var target_movement: Vector2 = centre - focus_position
		
		$scroller.scroll_vertical -= target_movement.y * delta*5

func queue_recatalogue():
	if !queued_recatalogue:
		queued_recatalogue = true
		
		call_deferred("recatalogue")

func recatalogue():
	queued_recatalogue = false
	
	connect_buttons()
	catalogue_controls()

func catalogue_controls():
	lists = []
	items = []
	
	for this_list in list.get_children():
		if this_list is ControlsList:
			lists.append(this_list)
			for item in this_list.get_children():
				if item is PanelContainer:
					items.append(item)

func catalogue_presets():
	var folder = "res://ui/controls/presets/"
	var dir = Directory.new()
	
	dir.open(folder)
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if !fname.ends_with("."):
			var this_thing = load(folder + fname)
			if this_thing is ControlsPreset:
				var last_dot = fname.find_last(".")
				var preset_name: String = fname.substr(0, last_dot)
				var first_underscore = preset_name.find("_")
				preset_name = preset_name.right(first_underscore + 1)
				preset_name = preset_name.capitalize()
				presets[preset_name] = this_thing
		
		fname = dir.get_next()

func deploy_presets():
	for i in presets:
		var new_button = Button.new()
		new_button.text = i
		new_button.connect("pressed", self, "_on_preset_selected", [i])
		$scroller/list/presets_scroller/presets.add_child(new_button)

func get_connectable(what: Control):
	if what is ControlsList:
		return what.get_children()[1]
	if what is Button:
		return what

func fatherify_buttons():
	for i in list.get_children():
		if i is ControlsList:
			i.father = self

func connect_buttons():
	var controllses: Array = []
	for i in list.get_children():
		var target: Control = i
		
		# Navigate down until we find something that's a bottom level container
		while true:
			if target.get_child_count() == 0 or !(target is Container):
				break
			
			var found_target: bool = false
			for this_kid in target.get_children():
				if this_kid is Container and !this_kid is ControlsInput:
					target = this_kid
					found_target = true
					break
			if found_target:
				continue
			else:
				break
		
		# Catalogue all the possible buttons
		if target is HBoxContainer or target is Button:
			var these_controls: Array = []
			if target is Button:
				these_controls.append(i)
			if target is HBoxContainer:
				for j in target.get_children():
					if j is PanelContainer or j is Button:
						these_controls.append(j)
			
			if these_controls.size() > 0:
				controllses.append(these_controls)
	
	# Actually connect them
	for i in range(controllses.size()):
		var these_controls: Array = controllses[i]
		
		var next_index = posmod(i+1, controllses.size())
		var next_list: Array = controllses[next_index]
		var prev_index = posmod(i-1, controllses.size())
		var prev_list: Array = controllses[prev_index]
		
		for j in range(these_controls.size()):
			var this_item: Control = these_controls[j]
			var next_item: Control = next_list[ min(j, next_list.size()-1) ]
			var prev_item: Control = prev_list[ min(j, prev_list.size()-1) ]
			var left_item: Control = these_controls[ posmod(j-1, these_controls.size()) ]
			var right_item:Control = these_controls[ posmod(j+1, these_controls.size()) ]
			
			var next_path: NodePath = this_item.get_path_to( next_item )
			var prev_path: NodePath = this_item.get_path_to( prev_item )
			var left_path: NodePath = this_item.get_path_to( left_item )
			var right_path:NodePath = this_item.get_path_to( right_item)
			
			this_item.focus_neighbour_bottom = next_path
			this_item.focus_next = next_path
			
			this_item.focus_neighbour_top = prev_path
			this_item.focus_previous = prev_path
			
			this_item.focus_neighbour_left = left_path
			this_item.focus_neighbour_right= right_path

func arrive_animation():
	rect_global_position = Vector2()
	
	$tween.interpolate_property($bac, "rect_scale", Vector2(1, 0), Vector2(1, 1), animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$tween.interpolate_property($scroller, "margin_left", 512, 16, animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$tween.interpolate_property($scroller, "margin_right", 512-32, -16, animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	$tween.start()

func depart_animation():
	$tween.interpolate_property($bac, "rect_scale", Vector2(1, 1), Vector2(1, 0), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$tween.interpolate_property($scroller, "margin_left", 16, 512, animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$tween.interpolate_property($scroller, "margin_right", -16, 512-32, animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	
	$tween.start()
	
	var timer: SceneTreeTimer = get_tree().create_timer(animation_duration)
	timer.connect("timeout", self, "_on_depart_animation_concluded")

func unbind_all():
	for i in items:
		i.get_culled()

func apply_preset(what: String):
	unbind_all()
	
	var this_preset: ControlsPreset = presets[what]
	var new_inputs = this_preset.get_controls()
	
	for action in new_inputs:
		InputMap.action_erase_events(action)
		for this_input in new_inputs[action]:
			if this_input is InputEventKey:
				var this_string = OS.get_scancode_string( this_input.physical_scancode )
				this_input.scancode = OS.find_scancode_from_string( this_string )
			InputMap.action_add_event(action, this_input)
	
	for this_list in lists:
		this_list.populate_list()


func _on_egress_pressed() -> void:
	depart_animation()

func _on_depart_animation_concluded():
	queue_free()

func _on_list_changed():
	queue_recatalogue()

func _on_preset_selected(what: String):
	apply_preset(what)
	call_deferred("select_first_preset")
