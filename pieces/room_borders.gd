tool
extends Node2D


export (Vector2) var room_size = Vector2(1, 1) setget set_room_size


func _ready() -> void:
	set_room_size(room_size)

func _process(delta: float) -> void:
	var overlapping_bodies = []
	for i in [$top, $bottom, $left, $right]:
		for j in i.get_overlapping_bodies():
			if !overlapping_bodies.has(j):
				overlapping_bodies.append(j)
	
	for i in overlapping_bodies:
		if i.is_in_group("players"):
			transition(i)


func set_room_size(what: Vector2):
	room_size = what
	
	var actual_size = room_size * Rooms.room_size
	var border_offset: Vector2 = Vector2(16, 20)
	var extra_width = border_offset - Vector2(8, 8)
	
	$top.position.x = actual_size.x/2
	$bottom.position.x = actual_size.x/2
	
	$left.position.y = actual_size.y/2
	$right.position.y = actual_size.y/2
	
	$top.position.y = -border_offset.y
	$left.position.x = -border_offset.x
	
	$bottom.position.y = actual_size.y + border_offset.y
	$right.position.x = actual_size.x + border_offset.x
	
	$top/hitbox   .shape.extents.x = actual_size.x/2 + extra_width.x
	$left/hitbox  .shape.extents.y = actual_size.y/2 + extra_width.y
	$bottom/hitbox.shape.extents.x = actual_size.x/2 + extra_width.x
	$right/hitbox .shape.extents.y = actual_size.y/2 + extra_width.y

func transition(player: Entity):
	PlayerStats.velocity = player.velocity
	PlayerStats.flipped = player.flipped
	
	var global_pos: Vector2 = player.global_position + Rooms.current_room*Rooms.room_size
	var target_subroom: Vector2 = Rooms.get_subroom_at(global_pos)
	var target_room: Vector2 = Rooms.get_room_at(global_pos)
	#print("Going from room %s to room %s" % [Rooms.current_room, target_room])
	#print("Velocity is %s; actual velocity is %s" % [player.velocity, player.get_actual_velocity()])
	
	# If we're transitioning to a room other than this one
	if target_room != Rooms.current_room:
		var prev_pos: Vector2 = global_pos
		var current_room: Vector2 = target_room
		var current_subroom: Vector2 = target_subroom
		var i: int = 50
		
		var from_this_room: bool = current_room == Rooms.current_room
		var current_in_this_room: bool = current_subroom == target_subroom
		
		# Figure out the subroom we're moving from
		while (current_in_this_room or !from_this_room) and player.velocity.length() > 1:
			# Multiplying by 5 to lose some accuracy but gain speed
			prev_pos -= 5 * player.get_actual_velocity().normalized()
			current_subroom = Rooms.get_subroom_at(prev_pos)
			current_room = Rooms.get_room_at(prev_pos)
			i -= 1
			if i <= 0:
				return false
			
			from_this_room = current_room == Rooms.current_room
			current_in_this_room = current_subroom == target_subroom
		
		# Jump when going into the room above
		if target_subroom.y < current_subroom.y:
			PlayerStats.velocity.y = min(PlayerStats.velocity.y, -300)
		
		# Horizontal rounding of position
		# so we don't smash into a wall/floor on the other side
		if target_subroom.x != current_subroom.x:
			global_pos.x = round(global_pos.x / Rooms.room_size.x) * Rooms.room_size.x
			global_pos.x += sign(target_subroom.x - current_subroom.x)
		# Vertical rounding
		if target_subroom.y != current_subroom.y:
			global_pos.y = round(global_pos.y / Rooms.room_size.y) * Rooms.room_size.y
			global_pos.y += sign(target_subroom.y - current_subroom.y)
		
		var state: String = player.get_node("fsm").state_name
		PlayerStats.extra_data.append("stt_" + state)
		Rooms.player_enter_room(global_pos)



