extends Area2D


const obj_flying_image = preload("res://fx/flying_image.tscn")
const tex_text = preload("res://fx/boing.png")

var overlappers: Array = []


func _init() -> void:
	add_to_group("mattresses")

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("body_entered", self, "_on_body_entered")
	connect("area_exited", self, "_on_area_exited")
	connect("body_exited", self, "_on_body_exited")


func activate():
	if !$animator.is_playing() or $animator.current_animation_position > 0.2:
		deploy_text()
	if $animator.is_playing():
		$animator.stop()
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_spring, global_position)
	new_sfx.randomise_pitch(0.8, 1.2)
	new_sfx.relative_volume = 0.5
	new_sfx.max_distance = 400
	
	var index = randi() % 2
	var animations = ["activate0", "activate1"]
	$animator.play(animations[index])

func deploy_text():
	var new_flying_image = obj_flying_image.instance()
	new_flying_image.texture = tex_text
	new_flying_image.velocity = Vector2(0, -64).rotated(rand_range(-0.5, 0.5))
	Game.deploy_instance(new_flying_image, global_position)

func has_point(what: Vector2) -> bool:
	var shape: RectangleShape2D = $hitbox.shape
	var rect: Rect2 = Rect2()
	rect.position = $hitbox.global_position - shape.extents
	rect.size = shape.extents*2
	
	return rect.has_point(what)

func receive_overlapper(what: Node2D):
	if !overlappers.has(what):
		overlappers.append(what)

func cull_overlapper(what: Node2D):
	if overlappers.has(what):
		overlappers.erase(what)


func _on_area_entered(what):
	receive_overlapper(what)
func _on_body_entered(what):
	receive_overlapper(what)

func _on_area_exited(what):
	cull_overlapper(what)
func _on_body_exited(what):
	cull_overlapper(what)

