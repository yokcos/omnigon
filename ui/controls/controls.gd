extends Control


var animation_duration = 0.5
var items = []


func _ready() -> void:
	$list/up.get_children()[1].grab_focus()
	
	fatherify_buttons()
	connect_buttons()
	arrive_animation()
	catalogue_controls()
	
	for i in $list.get_children():
		if i is HBoxContainer:
			i.connect("list_changed", self, "_on_list_changed")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		depart_animation()


func catalogue_controls():
	items = []
	
	for list in $list.get_children():
		if list is HBoxContainer:
			for item in list.get_children():
				if item is PanelContainer:
					items.append(item)

func get_connectable(what: Control):
	if what is HBoxContainer:
		return what.get_children()[1]
	if what is Button:
		return what

func fatherify_buttons():
	for i in $list.get_children():
		if i is HBoxContainer:
			i.father = self

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
			var these_items: Array = []
			
			for this_item in this_control.get_children():
				if this_item is PanelContainer:
					these_items.append(this_item)
			
			for j in range( these_items.size() ):
				var this_item: PanelContainer = these_items[j]
				var next_item: PanelContainer = these_items[posmod(j+1, these_items.size())]
				var prev_item: PanelContainer = these_items[posmod(j-1, these_items.size())]
				
				this_item.focus_neighbour_bottom = this_item.get_path_to(get_connectable(next_control))
				this_item.focus_next = this_item.get_path_to(get_connectable(next_control))
				
				this_item.focus_neighbour_top = this_item.get_path_to(get_connectable(prev_control))
				this_item.focus_previous = this_item.get_path_to(get_connectable(prev_control))
				
				this_item.focus_neighbour_right = this_item.get_path_to(next_item)
				this_item.focus_neighbour_left  = this_item.get_path_to(prev_item)
		
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

func _on_list_changed():
	connect_buttons()
	catalogue_controls()
