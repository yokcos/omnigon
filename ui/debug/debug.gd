extends VBoxContainer


func _ready() -> void:
	update_target_room()

func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("debug"):
			visible = !visible
			if visible:
				target_this_room()


func target_this_room():
	var this_room = Rooms.current_room
	$room_teleporter/x.value = this_room.x
	$room_teleporter/y.value = this_room.y

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
	hide()

func _on_don_pressed() -> void:
	var hat_name = $hats/text.text
	var this_hat = PlayerStats.get_hat(hat_name)
	
	if this_hat:
		if !PlayerStats.don_hat(this_hat):
			Game.summon_popup("ERROR", "That hat is too long to be worn in your current position", "ah poo")
	else:
		show_output("No such hat")

func _on_doff_pressed() -> void:
	var hat_name = $hats/text.text
	var this_hat = PlayerStats.get_hat(hat_name)
	
	if this_hat:
		PlayerStats.doff_hat(this_hat)
	else:
		show_output("No such hat")

func _on_gain_pressed() -> void:
	var hat_name = $hats/text.text
	var this_hat = PlayerStats.get_hat(hat_name)
	
	if this_hat:
		PlayerStats.gain_hat(this_hat)
	else:
		show_output("No such hat")
