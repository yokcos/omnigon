extends Control


export (Array, Resource) var wares = []

onready var ware_list = $all/main/scroller/wares
var last_selected_ware: int = -1
var previously_paused: bool = false

const obj_ware = preload("res://ui/vendor/vendor_ware.tscn")


func _ready() -> void:
	previously_paused = get_tree().paused
	get_tree().paused = true
	deploy_wares()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		depart()


func clear_wares():
	for i in ware_list.get_children():
		i.queue_free()
		ware_list.remove_child(i)
	last_selected_ware = -1

func deploy_wares(selection: int = 0):
	clear_wares()
	selection = int( min(selection, wares.size()-1) )
	var selection_made: bool = false
	for i in range(wares.size()):
		var this_ware: VendorWare = wares[i]
		if this_ware.check_availability():
			var new_ware = obj_ware.instance()
			new_ware.ware = this_ware
			new_ware.connect("purchased", self, "_on_ware_purchased")
			new_ware.connect("too_poor", self, "_on_too_poor")
			new_ware.connect("focus_entered", self, "_on_ware_selected")
			ware_list.add_child(new_ware)
			$all/main/scroller/wares/warelessness.hide()
			
			if i >= selection and !selection_made:
				new_ware.grab_focus()
				selection_made = true
			else:
				new_ware.call_deferred("get_deselected")
	
	display_selection()
	connect_wares()

func get_selected_ware():
	for i in range(ware_list.get_child_count()):
		var this_ware: Control = ware_list.get_child(i)
		if this_ware.has_focus():
			return i
	return -1

func purchase_selected_ware():
	if last_selected_ware >= 0:
		var this_ware: Control = ware_list.get_child(last_selected_ware)
		this_ware.purchase()

func display_selection():
	for i in range(ware_list.get_child_count()):
		var this_ware = ware_list.get_child(i)
		if i == last_selected_ware:
			if !this_ware.selected:
				this_ware.get_selected()
		else:
			if this_ware.selected:
				this_ware.get_deselected()

func depart():
	$animator.play("depart")

func egress():
	get_tree().paused = previously_paused
	queue_free()

func set_image(what: Texture):
	if what != null:
		$all/main/portrait.texture = what

func connect_wares():
	var wares: Array = $all/main/scroller/wares.get_children()
	
	for i in range(wares.size()):
		var this_index = i
		var next_index = posmod(i+1, wares.size())
		
		var this_node: Control = wares[this_index]
		var next_node: Control = wares[next_index]
		
		var this_path = next_node.get_path_to(this_node)
		var next_path = this_node.get_path_to(next_node)
		
		this_node.focus_neighbour_bottom = next_path
		this_node.focus_next = next_path
		
		next_node.focus_neighbour_top = this_path
		next_node.focus_previous = this_path


func _on_ware_purchased():
	deploy_wares( get_selected_ware() )

func _on_too_poor():
	$animator.play("too_poor")

func _on_ware_selected():
	var ware_index = get_selected_ware()
	if ware_index >= 0:
		last_selected_ware = ware_index
		display_selection()

func _on_purchase_pressed() -> void:
	purchase_selected_ware()
	if last_selected_ware >= 0:
		var this_ware: Control = ware_list.get_child(last_selected_ware)
		this_ware.grab_focus()

func _on_egress_pressed() -> void:
	depart()
