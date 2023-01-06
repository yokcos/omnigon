extends HSlider


var textures = [
	preload("res://ui/options/grabber_volume1.png"),
	preload("res://ui/options/grabber_volume2.png"),
	preload("res://ui/options/grabber_volume3.png"),
	preload("res://ui/options/grabber_volume4.png"),
	preload("res://ui/options/grabber_volume5.png"),
]
var textures_highlight = [
	preload("res://ui/options/grabber_volume_highlight1.png"),
	preload("res://ui/options/grabber_volume_highlight2.png"),
	preload("res://ui/options/grabber_volume_highlight3.png"),
	preload("res://ui/options/grabber_volume_highlight4.png"),
	preload("res://ui/options/grabber_volume_highlight5.png"),
]
var textures_disabled = [
	preload("res://ui/options/grabber_volume_disabled1.png"),
	preload("res://ui/options/grabber_volume_disabled2.png"),
	preload("res://ui/options/grabber_volume_disabled3.png"),
	preload("res://ui/options/grabber_volume_disabled4.png"),
	preload("res://ui/options/grabber_volume_disabled5.png"),
]


func _ready() -> void:
	connect("value_changed", self, "_on_value_changed")


func _on_value_changed(new_value: float):
	var index: float = new_value * textures.size() / max_value
	index = clamp( floor(index), 0, textures.size()-1 )
	
	add_icon_override("grabber", textures[index])
	add_icon_override("grabber_highlight", textures_highlight[index])
	add_icon_override("grabber_disabled", textures_disabled[index])
