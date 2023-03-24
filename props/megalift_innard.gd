extends Node2D


var current_floor: int = -1


const rooms: Array = [
	Vector2(-7, -2),
	Vector2(-7, 2),
]
const positions: PoolVector2Array = PoolVector2Array([
	Vector2(256, 112),
	Vector2(256, 368),
])


func _ready() -> void:
	current_floor = rooms.find(Rooms.current_room)


func egress():
	$animator.play("depart")

func go_to_floor(index: int):
	if index >= 0 and index < rooms.size():
		var player = Game.get_player()
		if is_instance_valid(player):
			var relative = player.global_position - global_position
			PlayerStats.velocity = player.velocity
			var target_room_pos: Vector2 = rooms[index] * Rooms.room_size
			var lift_pos: Vector2 = positions[index]
			
			WorldSaver.save_data("has_megalift", false)
			WorldSaver.save_room_data("has_megalift", true, rooms[index])
			
			Rooms.player_enter_room( target_room_pos + lift_pos + relative )
			
			var new_lift = load("res://props/megalift.tscn").instance()
			Game.deploy_instance(new_lift, lift_pos)
			new_lift.instant_ingress()
			new_lift.to_exclusivify = true

func arrive():
	$animator.play("arrive")

func instant_arrive():
	$animator.play("instant_arrive")


func _on_button_rise_activated() -> void:
	var new_floor = current_floor - 1
	go_to_floor(new_floor)

func _on_button_sink_activated() -> void:
	var new_floor = current_floor + 1
	go_to_floor(new_floor)
