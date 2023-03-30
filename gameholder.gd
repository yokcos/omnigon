extends Node2D


var popup_queue: Array = []
var current_popup: Control = null
var current_pause_block: Control = null
var tex: ViewportTexture
var screen_scale: float = 1 setget set_screen_scale
var base_screen_size: Vector2

var upper_border: float = 16
var lower_border: float = 16

const obj_popup = preload("res://ui/popup.tscn")
const obj_popup_world = preload("res://ui/popup_world.tscn")
const obj_popup_secret = preload("res://ui/popup_secret.tscn")
const obj_options = preload("res://ui/options/options.tscn")
const obj_overlay = preload("res://ui/details_overlay.tscn")
const obj_pause_block = preload("res://ui/pause_blocked.tscn")


signal screen_scale_changed


func _ready() -> void:
	var bssx = ProjectSettings.get_setting("display/window/size/width")
	var bssy = ProjectSettings.get_setting("display/window/size/height")
	base_screen_size = Vector2(bssx, bssy)
	Game.gameholder = self
	PlayerStats.connect("eyes_changed", self, "_on_eyes_changed")
	calculate_border_size()
	
	tex = $beholder/viewport.get_texture()
	tex.flags = 0
	
	$ui/ui/testure.texture = tex
	
	calculate_screen_size()

func _process(delta: float) -> void:
	if popup_queue.size() > 0 and !current_popup:
		var dict = popup_queue.pop_front()
		
		deploy_popup(dict)
	
	calculate_screen_size()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if !check_for_pause_blockers():
			var new_options = obj_options.instance()
			$ui/ui.add_child(new_options)
			new_options.rect_position = Vector2(448, 136)
			new_options.show_save()
	
	if event.is_action_pressed("map"):
		if !check_for_pause_blockers():
			var new_overlay = obj_overlay.instance()
			$ui/ui.add_child(new_overlay)


func calculate_screen_size():
	var ratio = OS.window_size / base_screen_size
	var new_scale = ratio.x if ratio.x < ratio.y else ratio.y
	if new_scale != screen_scale:
		set_screen_scale(new_scale)

func set_screen_scale(what: float):
	what = max(what, 0.1)
	
	var base_size: Vector2 = Vector2(512, 256)
	
	screen_scale = what
	$beholder/viewport.size = base_size * what
	$beholder.rect_scale = Vector2(1/what, 1/what)
	
	emit_signal("screen_scale_changed", screen_scale)

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
	
	$ui/ui.add_popup(new_popup)
	
	Game.emit_signal("popup_arisen", data)

func deploy_popup_world(what: PackedScene):
	var new_popup = obj_popup_world.instance()
	$ui/ui.add_popup(new_popup)
	new_popup.popup_centered()
	new_popup.apply_world(what)
	return new_popup

func deploy_popup_secret(what: Secret):
	var new_popup = obj_popup_secret.instance()
	$ui/ui.add_popup(new_popup)
	new_popup.popup_centered()
	new_popup.secret = what
	return new_popup

func count_popups() -> int:
	var total: int = popup_queue.size()
	if current_popup:
		total += 1
	return total

func check_for_pause_blockers():
	var blockers = get_tree().get_nodes_in_group("pause_blockers")
	if blockers.size() > 0:
		if !is_instance_valid(current_pause_block):
			var new_blocker = obj_pause_block.instance()
			Game.deploy_ui_instance(new_blocker, Vector2())
			current_pause_block = new_blocker
		
		return true
	return false


func _on_eyes_changed(what: int):
	if what == PlayerStats.EYES_NONE:
		$ui/ui.blind()
	else:
		$ui/ui.unblind()

func _on_popup_slain():
	current_popup = null
	
	if popup_queue.size() <= 0:
		Game.emit_signal("popup_arisen", null)
