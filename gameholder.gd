extends Node2D


var popup_queue: Array = []
var current_popup: Control = null

var upper_border: float = 16
var lower_border: float = 16

const obj_popup = preload("res://ui/popup.tscn")
const obj_options = preload("res://ui/options/options.tscn")
const obj_overlay = preload("res://ui/details_overlay.tscn")


func _ready() -> void:
	Game.gameholder = self
	PlayerStats.connect("eyes_changed", self, "_on_eyes_changed")
	calculate_border_size()

func _process(delta: float) -> void:
	if popup_queue.size() > 0 and !current_popup:
		var dict = popup_queue.pop_front()
		
		deploy_popup(dict)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var new_options = obj_options.instance()
		$ui/ui.add_child(new_options)
		new_options.rect_position = Vector2(448, 136)
		new_options.show_save()
	
	if event.is_action_pressed("map"):
		var new_overlay = obj_overlay.instance()
		$ui/ui.add_child(new_overlay)


func calculate_border_size():
	upper_border = $beholder/viewport/world.position.y
	lower_border = ProjectSettings.get_setting("display/window/size/height") - Rooms.room_size.y - upper_border

func add_world(what: Node2D):
	$beholder/viewport/world.add_child(what)

func add_popup(title: String, text: String, egress: String = "Alrighty", anchor: Node2D = null):
	var dict = {
		"title": title,
		"text": text,
		"egress": egress,
		"anchor": anchor,
	}
	
	popup_queue.append(dict)

func deploy_popup(data: Dictionary):
	var new_popup = obj_popup.instance()
	
	new_popup.set_title(data["title"])
	new_popup.set_text(data["text"])
	new_popup.set_egress(data["egress"])
	new_popup.anchor = data["anchor"]
	
	new_popup.connect("tree_exiting", self, "_on_popup_slain")
	
	current_popup = new_popup
	
	$ui/ui.add_child(new_popup)
	
	Game.emit_signal("popup_arisen", data)

func count_popups() -> int:
	var total: int = popup_queue.size()
	if current_popup:
		total += 1
	return total


func _on_eyes_changed(what: int):
	if what == PlayerStats.EYES_NONE:
		$ui/ui.blind()
	else:
		$ui/ui.unblind()

func _on_popup_slain():
	current_popup = null
	
	if popup_queue.size() <= 0:
		Game.emit_signal("popup_arisen", null)
