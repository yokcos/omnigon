extends Control


var index: int = -1 setget set_index
var father: Control = null
var new: bool = false

var mat_normal   = preload("res://misc/unselected_panel.tres")
var mat_selected = preload("res://misc/selected_panel.tres"  )

const obj_delete_confirm = preload("res://ui/save_delete_confirm.tscn")

signal save_deleted


func _ready() -> void:
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")


func set_index( what: int ):
	index = what
	$list/index.text = str(what)

func set_file( what: Dictionary ):
	var room_location = Rooms.get_room_at( what["player"]["position"] )
	var room_name = ""
	if Rooms.room_data.has(room_location):
		room_name = Rooms.room_data[room_location]["title"]
	$list/room.text = "Room: %s" % room_name
	
	$list/stats0/vertices.text = "Vertices: %04d" % what["player"]["vertices"]
	var time = what["player"]["time"]
	var seconds = fmod(time, 60)
	var minutes = fmod( (time - seconds)/60, 60 )
	var hours = time - minutes*60 - seconds
	hours /= 3600
	$list/stats0/time.text = "Time: %02d:%02d:%02d" % [hours, minutes, seconds]
	
	$list/stats1/rooms.text = "Rooms visited: %s" % count_rooms(what)
	$list/stats1/hats.text = "Hats: %s" % what["player"]["available_hats"].size()

func make_new():
	$list/new.show()
	$list/room.hide()
	$list/stats0.hide()
	$list/stats1.hide()
	$list/delete_save.hide()
	$list/index.text = "+"
	new = true

func count_rooms( dict: Dictionary ) -> int:
	var count: int = 0
	
	for i in dict["world"]:
		if i is Vector2 and dict["world"][i].has("visits"):
			if dict["world"][i]["visits"] > 0:
				count += 1
	
	return count

func activate():
	if index >= 0:
		Game.save_slot = index
		if new:
			pass
		else:
			Game.apply_save_file( Game.load_game() )
		get_tree().change_scene("res://gameholder.tscn")
		PlayerStats.call_deferred("apply_position")

func get_selected():
	if !is_inside_tree():
		return false
	
	$bac.add_stylebox_override("panel", mat_selected)
	
	$tween.interpolate_property($bac, "margin_left",  $bac.margin_left , -8, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.interpolate_property($bac, "margin_right", $bac.margin_right,  8, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.interpolate_property($list/index, "rect_rotation", 90, 0, 1, Tween.TRANS_BACK, Tween.EASE_OUT)
	$tween.start()

func get_deselected():
	if !is_inside_tree():
		return false
	
	$bac.add_stylebox_override("panel", mat_normal)
	
	$tween.interpolate_property($bac, "margin_left",  $bac.margin_left , 0, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.interpolate_property($bac, "margin_right", $bac.margin_right, 0, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.start()


func _on_focus_entered():
	call_deferred("get_selected")

func _on_focus_exited():
	call_deferred("get_deselected")

func _on_begin_pressed() -> void:
	activate()
	grab_focus()

func _on_delete_save_pressed() -> void:
	var new_confirm = obj_delete_confirm.instance()
	new_confirm.index = index
	new_confirm.father = self
	new_confirm.connect("save_deleted", self, "_on_save_deleted")
	father.add_child(new_confirm)
	new_confirm.rect_global_position = $list/delete_save.rect_global_position + $list/delete_save.rect_size/2

func _on_save_deleted():
	emit_signal("save_deleted")
