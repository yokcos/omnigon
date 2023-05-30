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
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("attack"):
		depart()


func clear_wares():
	for i in ware_list.get_children():
		i.queue_free()
	last_selected_ware = -1

func deploy_wares(selection: int = 0):
	clear_wares()
	selection = int( min(selection, wares.size()-1) )
	for i in range(wares.size()):
		var this_ware: VendorWare = wares[i]
		if this_ware.check_availability():
			var new_ware = obj_ware.instance()
			new_ware.ware = this_ware
			new_ware.connect("purchased", self, "_on_ware_purchased")
			new_ware.connect("too_poor", self, "_on_too_poor")
			new_ware.connect("focus_entered", self, "_on_ware_selected")
			ware_list.add_child(new_ware)
			
			if i == selection:
				new_ware.grab_focus()
			else:
				new_ware.call_deferred("get_deselected")
	
	display_selection()

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
