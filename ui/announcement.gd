extends Node2D


var border: float = 16
var target_position: Vector2 = Vector2()


func _ready() -> void:
	reposition()

func _process(delta: float) -> void:
	reposition()
	
	global_position = global_position.linear_interpolate(target_position, delta * 5)
	rotation = global_position.distance_squared_to(target_position) / 10000


func limit_to_borders():
	var rect = $panel.rect_size
	
	var room_size: Vector2
	if Game.world:
		room_size = Game.world.room_size * Rooms.room_size
	
	position.x = clamp(position.x, rect.x/2 + border, room_size.x - rect.x/2 - border)
	position.y = clamp(position.y, rect.y/2 + border, room_size.y - rect.y/2 - border)

func reposition():
	var player: Entity = Game.get_player()
	var cam: Camera2D = Game.camera
	
	if player and cam:
		var centre: Vector2 = cam.get_actual_position()
		var relative: Vector2 = player.global_position - centre
		var screen_size: Rect2 = cam.get_visible_rect()
		
		relative = relative.normalized()
		relative *= 600
		
		var rect = $panel.rect_size
		var relative_position = centre-relative - screen_size.end/2
		relative_position.x = clamp(
			relative_position.x,
			screen_size.position.x + border + rect.x/2,
			screen_size.end.x - border - rect.x/2
		)
		relative_position.y = clamp(
			relative_position.y,
			screen_size.position.y + border + rect.y/2,
			screen_size.end.y - border - rect.y/2
		)
		
		target_position = relative_position + centre - screen_size.end/2

