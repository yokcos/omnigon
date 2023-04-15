extends Control


var map: Resource = load("res://rooms/map/main_map.tres")
var default_image: Texture = preload("res://ui/map/images/base.png")
var image_size: Vector2 = Vector2(32, 16)
var borders: Rect2 = Rect2()

var velocity: Vector2 = Vector2()
var acceleration: float = 5000
var friction: float = 10
var animation_duration: float = .5

const scr_map_image = preload("res://ui/map/map_image.gd")
const tex_icon = preload("res://ui/map/map_icon.png")


signal slain


func _ready() -> void:
	arrive_animation()
	deploy_images()
	deploy_player_icon()
	apply_scale()
	$stuff/egress.grab_focus()

func _process(delta: float) -> void:
	tractutate(delta)
	frictutate(delta)
	
	$stuff/image_holder/images.rect_position -= velocity * delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		depart_animation()
		emit_signal("slain")


func tractutate(delta: float):
	var traction = Vector2()
	
	if Input.is_action_pressed("move_up"):
		traction.y -= 1
	if Input.is_action_pressed("move_down"):
		traction.y += 1
	if Input.is_action_pressed("move_left"):
		traction.x -= 1
	if Input.is_action_pressed("move_right"):
		traction.x += 1
	
	traction = traction.normalized()
	
	velocity += traction * acceleration * delta

func frictutate(delta: float):
	velocity -= velocity * friction * delta

func arrive_animation():
	$tween.interpolate_property($diagonoverlay, "rect_position", Vector2(0, -288), Vector2(), animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$tween.interpolate_property($stuff/title, "percent_visible", 0, 1, animation_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($stuff, "rect_scale", Vector2(.5, .5), Vector2(1, 1), animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$tween.interpolate_property($stuff, "rect_rotation", -30, 0, animation_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	$tween.start()

func depart_animation():
	$tween.interpolate_property($diagonoverlay, "rect_position", Vector2(), Vector2(0, 288), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$tween.interpolate_property($stuff/title, "percent_visible", 1, 0, animation_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$tween.interpolate_property($stuff, "rect_scale", Vector2(1, 1), Vector2(.2, .2), animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	$tween.interpolate_property($stuff, "rect_rotation", 0, 30, animation_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	
	$tween.start()
	
	var timer: SceneTreeTimer = get_tree().create_timer(animation_duration)
	timer.connect("timeout", self, "_on_depart_animation_concluded")

func deploy_images():
	borders = Rect2()
	
	for i in Rooms.rooms:
		var this_room = Rooms.rooms[i]
		if this_room is PackedScene:
			var visits = WorldSaver.load_data_at(i, "visits")
			if visits > 0:
				var new_room = this_room.instance()
				var img: Texture = new_room.map_image
				new_room.queue_free()
				
				if !img:
					img = default_image
				
				var new_rect = TextureRect.new()
				new_rect.texture = img
				new_rect.set_script(scr_map_image)
				new_rect.set_room_position(i)
				$stuff/image_holder/images.add_child(new_rect)
				new_rect.rect_position = i*image_size - image_size/2
				new_rect.target_position = new_rect.rect_position
				
				if i.x < borders.position.x:
					borders.position.x = i.x
				if i.y < borders.position.y:
					borders.position.y = i.y
				if i.x > borders.end.x:
					borders.end.x = i.x
				if i.y > borders.end.y:
					borders.end.y = i.y
				
				borders.end += Vector2(1, 1)

func deploy_player_icon():
	var player = Game.get_player()
	if is_instance_valid(player):
		var pos = player.global_position / Rooms.room_size
		var room_pos = Rooms.current_room
		var global_pos = pos + room_pos
		var icon_pos = global_pos * image_size - image_size/2
		
		var new_icon = TextureRect.new()
		new_icon.texture = tex_icon
		$stuff/image_holder/images.add_child(new_icon)
		new_icon.rect_size = Vector2()
		new_icon.rect_position = icon_pos - new_icon.rect_size/2
		new_icon.hint_tooltip = "You are here!"
		
		focus_on_position(new_icon.rect_position)

func focus_on_position(where: Vector2):
	$stuff/image_holder/images.rect_position = -where + $stuff/image_holder.rect_size/2

func apply_scale():
	var ratio2: Vector2 = ($stuff/image_holder.rect_size - Vector2(32, 32)) / (borders.size * image_size)
	var ratio: float
	if ratio2.x < ratio2.y:
		ratio = ratio2.x
	else:
		ratio = ratio2.y
	
	ratio = clamp(ratio, 1, 1)
	
	$stuff/image_holder/images.rect_scale = Vector2(ratio, ratio)

func die():
	depart_animation()


func _on_egress_pressed() -> void:
	depart_animation()

func _on_depart_animation_concluded():
	queue_free()
