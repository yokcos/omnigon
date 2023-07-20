extends Control


var animation_duration = 0.5
var items = []
onready var list = $scroller/list


func _ready() -> void:
	list.get_children()[0].get_children()[1].grab_focus()
	
	fatherify_buttons()
	connect_buttons()
	arrive_animation()
	catalogue_controls()
	
	for i in list.get_children():
		if i is ControlsList:
			i.connect("list_changed", self, "_on_list_changed")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		depart_animation()


func catalogue_controls():
	items = []
	
	for this_list in list.get_children():
		if this_list is ControlsList:
			for item in this_list.get_children():
				if item is PanelContainer:
					items.append(item)

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
		if i is HBoxContainer or i is Button:
			var these_controls: Array = []
			if i is Button:
				these_controls.append(i)
			if i is HBoxContainer:
				for j in i.get_children():
					if j is PanelContainer:
						these_controls.append(j)
			
			if these_controls.size() > 0:
				controllses.append(these_controls)
	
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
	$tween.interpolate_property(list, "rect_position", Vector2(512, 0), Vector2(16, 0), animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	$tween.start()

func depart_animation():
	$tween.interpolate_property($bac, "rect_scale", Vector2(1, 1), Vector2(1, 0), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$tween.interpolate_property(list, "rect_position", Vector2(16, 0), Vector2(512, 0), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	
	$tween.start()
	
	var timer: SceneTreeTimer = get_tree().create_timer(animation_duration)
	timer.connect("timeout", self, "_on_depart_animation_concluded")

func unbind_all():
	pass


func _on_egress_pressed() -> void:
	depart_animation()

func _on_depart_animation_concluded():
	queue_free()

func _on_list_changed():
	connect_buttons()
	catalogue_controls()
