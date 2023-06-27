extends Control


enum lower_types {
	LEVEL_NAME,
	BOSS_BAR,
}

onready var lower_component: Control = $bar_bottom/level_name
var lower_type: int = lower_types.LEVEL_NAME

const eye_textures = [
	preload("res://ui/eyes0.png"),
	preload("res://ui/eyes1.png"),
	preload("res://ui/eyes2.png"),
]
const lighter_textures = [
	preload("res://entities/lighter_basic.png"),
	preload("res://entities/lighter_sophisticated.png"),
	preload("res://entities/lighter_fanciful.png"),
]

const obj_level_name = preload("res://ui/level_name.tscn")
const obj_boss_bar = preload("res://ui/boss_bar.tscn")


func _ready() -> void:
	PlayerStats.connect("eyes_changed", self, "_on_eyes_changed")
	PlayerStats.connect("lighters_changed", self, "_on_lighters_changed")
	PlayerStats.connect("secrets_changed", self, "_on_secrets_changed")
	Game.connect("world_changed", self, "_on_world_changed")
	Game.connect("boss_changed", self, "_on_boss_changed")
	Events.connect("teleported", self, "_on_teleported")
	update_lighters()
	update_secrets()
	shaderify_tele_flash()

func _process(delta: float) -> void:
	if Game.camera and is_instance_valid(Game.camera) and false:
		rect_position = Game.camera.get_camera_screen_center() - rect_size/2


func blind():
	$animator.play("blinding")

func unblind():
	$animator.play("envision")


func shaderify_tele_flash():
	$tele_flash.material = load("res://misc/mat_colouriser.tres").duplicate()
	$tele_flash.material.set_shader_param("colour", Color("fa6a0a"))
	$tele_flash.material.set_shader_param("factor", 1)

func cull_lower_component():
	lower_component.queue_free()

func deploy_boss_bar(what: Being):
	if lower_type != lower_types.BOSS_BAR:
		cull_lower_component()
		
		var new_boss_bar = obj_boss_bar.instance()
		$bar_bottom.add_child(new_boss_bar)
		
		lower_component = new_boss_bar
		lower_type = lower_types.BOSS_BAR
	
	lower_component.target = what

func deploy_level_name(what: String):
	if lower_type != lower_types.LEVEL_NAME:
		cull_lower_component()
		
		var new_level_name = obj_level_name.instance()
		$bar_bottom.add_child(new_level_name)
		
		lower_component = new_level_name
		lower_type = lower_types.LEVEL_NAME
	
	lower_component.text = what
	lower_component.percent_visible = 0

func add_popup(what: Control):
	$popups.add_child(what)

func update_lighters():
	for i in $bar_bottom/lighters.get_children():
		i.queue_free()
	
	for i in range(PlayerStats.lighters.size()):
		var this_count = PlayerStats.lighters[i]
		for j in range(this_count):
			var new_rect = TextureRect.new()
			new_rect.texture = lighter_textures[i]
			new_rect.expand = true
			new_rect.rect_min_size = Vector2(16, 16)
			$bar_bottom/lighters.add_child(new_rect)

func update_secrets():
	$bar_top/secrets.text = "Secrets found: %s" % PlayerStats.secrets.size()

func teleport():
	$animator.play("tele_flash")
	GlobalSound.play_random_sfx(GlobalSound.sfx_blap)


func _on_eyes_changed(what: int):
	var this_texture = eye_textures[what]
	$bar_bottom/eyes/left.texture = this_texture
	$bar_bottom/eyes/right.texture = this_texture

func _on_world_changed(what):
	deploy_level_name(what.title)

func _on_boss_changed(what: Being):
	if !is_instance_valid(what):
		if Game.world:
			deploy_level_name(Game.world.title)
	else:
		deploy_boss_bar(what)

func _on_lighters_changed():
	update_lighters()

func _on_secrets_changed():
	update_secrets()

func _on_teleported():
	teleport()
