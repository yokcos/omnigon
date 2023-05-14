extends VBoxContainer


func _ready() -> void:
	update_target_room()

func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("debug"):
			visible = !visible


func update_target_room():
	var x = $room_teleporter/x.value
	var y = $room_teleporter/y.value
	var coords = Vector2(x, y)
	var data = Rooms.get_room_data(coords)
	if data:
		$room_teleporter/room_name.text = data["title"]
	else:
		$room_teleporter/room_name.text = "No room"

func teleport_to_room():
	var x = $room_teleporter/x.value
	var y = $room_teleporter/y.value
	var coords = Vector2(x, y)
	
	var target_pos = coords * Rooms.room_size
	target_pos += Rooms.room_size/2
	Rooms.player_enter_room( target_pos )

func show_output(what: String):
	$output.text = what


func _on_room_target_changed(value: float) -> void:
	update_target_room()

func _on_teleport_pressed() -> void:
	teleport_to_room()

func _on_don_pressed() -> void:
	var hat_name = $hat_gainer/text.text
	var this_hat = PlayerStats.get_hat(hat_name)
	
	if this_hat:
		if !PlayerStats.hats.has(this_hat):
			PlayerStats.hats.append(this_hat)
			
			if is_instance_valid(Game.get_player()):
				Game.get_player().apply_hats()
	else:
		show_output("No such hat")

func _on_doff_pressed() -> void:
	var hat_name = $hat_gainer/text.text
	var this_hat = PlayerStats.get_hat(hat_name)
	
	if this_hat:
		if PlayerStats.hats.has(this_hat):
			PlayerStats.hats.erase(this_hat)
			
			if is_instance_valid(Game.get_player()):
				Game.get_player().apply_hats()
	else:
		show_output("No such hat")
