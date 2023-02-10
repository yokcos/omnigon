extends Control


var scroll: int = 0
var spacing: float = 15
var bar_size: float = 100
var animation_duration: float = 0.5
# Look, I apologise for these being out of order
# I could go in and rename them but that's boring and I'm too lazy for that
# and ultimately nobody is going to care
var icons: Array = [
	null,
	preload("res://ui/options/pause_icons4.png"),
	preload("res://ui/options/pause_icons1.png"),
	preload("res://ui/options/pause_icons2.png"),
	preload("res://ui/options/pause_icons3.png"),
	preload("res://ui/options/pause_icons7.png"),
	preload("res://ui/options/pause_icons6.png"),
	preload("res://ui/options/pause_icons5.png"),
]

const obj_controls = preload("res://ui/controls/controls.tscn")


func _ready() -> void:
	reposition_elements()
	order_fulcra()
	connect_fulcra()
	get_fulcra()[0].grab_focus()
	
	$fulcra/volume_music/area/bar.value = Settings.volume_music * bar_size
	$fulcra/volume_sfx/area/bar.value = Settings.volume_sfx * bar_size
	
	get_tree().paused = true
	
	arrive_animation()
	AudioServer.set_bus_effect_enabled(1, 0, true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		depart_animation()


func order_fulcra():
	var fulcra = get_fulcra(true)
	for i in fulcra.size():
		fulcra[i].position = i

func connect_fulcra():
	var fulcra = get_fulcra()
	
	var fulcrum_count = fulcra.size()
	for i in fulcrum_count:
		var this_fulcrum: MenuFulcrum = fulcra[i]
		
		var prev = posmod(i-1, fulcrum_count)
		var next = posmod(i+1, fulcrum_count)
		
		this_fulcrum.connect_neighbours( fulcra[prev], fulcra[next] )
		
		this_fulcrum.connect("selected", self, "_on_fulcrum_selected")

func get_fulcra(all: bool = false) -> Array:
	# If ALL is false, we only get the selectable fulcra
	var fulcra = []
	
	for i in $fulcra.get_children():
		if i is MenuFulcrum and (i.selectable or all):
			fulcra.append(i)
	
	return fulcra

func reposition_elements():
	var fulcra = get_fulcra(true)
	for i in fulcra.size():
		var angle = 30 - 15*i
		fulcra[i].rect_rotation = angle
		fulcra[i].target_rotation = angle

func remove_effects():
	AudioServer.set_bus_effect_enabled(1, 0, false)
	get_tree().paused = false

func arrive_animation():
	var base_icon_size: Vector2 = $icon.texture.get_size()
	var warped_icon_size: Vector2 = base_icon_size * Vector2(5, 0.2)
	$tween.interpolate_property($diagonoverlay, "rect_global_position", Vector2(0, -288), Vector2(), animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$tween.interpolate_property($icon, "rect_scale", Vector2(5, 0.2), Vector2(1, 1), animation_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($icon, "rect_position", -warped_icon_size/2, -base_icon_size/2, animation_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($fulcra, "rect_position", Vector2(-512, 0), Vector2(), animation_duration, Tween.TRANS_BACK, Tween.EASE_OUT)
	
	$tween.start()

func depart_animation():
	var base_icon_size: Vector2 = $icon.texture.get_size()
	var warped_icon_size: Vector2 = base_icon_size * Vector2(0.2, 5)
	$tween.interpolate_property($diagonoverlay, "rect_global_position", Vector2(), Vector2(0, 288), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$tween.interpolate_property($icon, "rect_scale", Vector2(1, 1), Vector2(0.2, 5), animation_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$tween.interpolate_property($icon, "rect_position", -base_icon_size/2, -warped_icon_size/2, animation_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$tween.interpolate_property($fulcra, "rect_position", Vector2(), Vector2(-512, 0), animation_duration, Tween.TRANS_BACK, Tween.EASE_IN)
	
	$tween.start()
	
	var timer: SceneTreeTimer = get_tree().create_timer(animation_duration)
	timer.connect("timeout", self, "_on_depart_animation_concluded")

func cull_egress_buton():
	var egress_button: Control = $fulcra/egress
	$fulcra.remove_child(egress_button)
	egress_button.queue_free()

func show_save():
	$saved.rect_global_position.x = 0
	$saved.rect_global_position.y = 288 - $saved.rect_size.y
	$animator.play("saved")


func _on_fulcrum_selected(which: int):
	var fulcra = get_fulcra(true)
	
	for i in range(fulcra.size()):
		var relative = which - i
		fulcra[i].target_rotation = relative*spacing
		fulcra[i].target_size = 1 - abs(relative)*0.1
	
	$icon.texture = icons[which]

func _on_music_value_changed(value: float) -> void:
	Settings.volume_music = value / bar_size

func _on_sfx_value_changed(value: float) -> void:
	Settings.volume_sfx = value / bar_size
	GlobalSound.play_random_sfx(GlobalSound.sfx_step)

func _on_controls_pressed() -> void:
	var new_controls = obj_controls.instance()
	#Game.deploy_ui_instance(new_controls, Vector2())
	add_child(new_controls)
	new_controls.connect("tree_exiting", self, "_on_controls_slain")
	pause_mode = PAUSE_MODE_STOP

func _on_continue_pressed() -> void:
	depart_animation()

func _on_fullscreen_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen

func _on_unsave_pressed() -> void:
	var dir = Directory.new()
	dir.remove(Game.save_file)
	get_tree().quit()

func _on_egress_pressed() -> void:
	remove_effects()
	PlayerStats.update_position()
	WorldSaver.save_room()
	Game.world = null
	Game.in_game = false
	get_tree().change_scene("res://ui/main_menu.tscn")


func _on_controls_slain():
	pause_mode = PAUSE_MODE_PROCESS
	$fulcra/controls.grab_focus()

func _on_depart_animation_concluded():
	remove_effects()
	queue_free()






