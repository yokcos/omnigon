extends Control


var animation_duration = 0.5


func _ready() -> void:
	$list/up.get_children()[1].grab_focus()
	
	connect_buttons()
	arrive_animation()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		depart_animation()


func get_connectable(what: Control):
	if what is HBoxContainer:
		return what.get_children()[1]
	if what is Button:
		return what

func connect_buttons():
	var controllses: Array = []
	for i in $list.get_children():
		if i is HBoxContainer or i is Button:
			controllses.append(i)
	
	for i in range(controllses.size()):
		var this_control: Control = controllses[i]
		var next_index = posmod(i+1, controllses.size())
		var next_control: Control = controllses[next_index]
		var prev_index = posmod(i-1, controllses.size())
		var prev_control: Control = controllses[prev_index]
		
		if this_control is HBoxContainer:
			for this_item in this_control.get_children():
				if this_item is PanelContainer:
					this_item.focus_neighbour_bottom = this_item.get_path_to(get_connectable(next_control))
					this_item.focus_next = this_item.get_path_to(get_connectable(next_control))
					
					this_item.focus_neighbour_top = this_item.get_path_to(get_connectable(prev_control))
					this_item.focus_previous = this_item.get_path_to(get_connectable(prev_control))
		if this_control is Button:
			this_control.focus_neighbour_bottom = this_control.get_path_to(get_connectable(next_control))
			this_control.focus_next = this_control.get_path_to(get_connectable(next_control))
			
			this_control.focus_neighbour_top = this_control.get_path_to(get_connectable(prev_control))
			this_control.focus_previous = this_control.get_path_to(get_connectable(prev_control))

func arrive_animation():
	rect_global_position = Vector2()
	
	$tween.interpolate_property($bac, "rect_scale", Vector2(1, 0), Vector2(1, 1), animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$tween.interpolate_property($list, "rect_position", Vector2(512, 0), Vector2(16, 0), animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	$tween.start()

func depart_animation():
	$tween.interpolate_property($bac, "rect_scale", Vector2(1, 1), Vector2(1, 0), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$tween.interpolate_property($list, "rect_position", Vector2(16, 0), Vector2(512, 0), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	
	$tween.start()
	
	var timer: SceneTreeTimer = get_tree().create_timer(animation_duration)
	timer.connect("timeout", self, "_on_depart_animation_concluded")


func _on_egress_pressed() -> void:
	depart_animation()

func _on_depart_animation_concluded():
	queue_free()
