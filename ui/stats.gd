extends Control


func _ready() -> void:
	$list/vertices.text = "Vertices: %04d" % PlayerStats.vertices
	$list/rooms.text = "Rooms visited: %02d" % count_rooms()
	var time = floor( PlayerStats.time )
	var seconds = fmod(time, 60)
	var minutes = fmod( (time - seconds)/60, 60 )
	var hours = time - minutes*60 - seconds
	$list/time.text = "Time: %02d:%02d:%02d" % [hours, minutes, seconds]
	$list/hats.text = "Hats: [ "
	for i in range(PlayerStats.available_hats.size()):
		var this_hat: Hat = PlayerStats.available_hats[i]
		$list/hats.text += this_hat.name
		if i < PlayerStats.available_hats.size()-1:
			$list/hats.text += " | "
	$list/hats.text += " ]"

func _process(delta: float) -> void:
	for i in [
		$list/vertices,
		$list/rooms,
		$list/time,
		$list/hats,
	]:
		var this_label: Label = i
		if this_label.percent_visible < 1:
			this_label.percent_visible += 2*delta


func count_rooms() -> int:
	var count: int = 0
	
	for i in WorldSaver.data:
		if WorldSaver.data[i]["visits"] > 0:
			count += 1
	
	return count
