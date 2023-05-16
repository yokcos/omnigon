extends Control


var value: float = 0


func _ready() -> void:
	Events.connect("fishticuffs_score_gained", self, "_on_score_gained")


func _on_score_gained(what):
	value += what
	
	var f_thousands = floor(value/1000)
	var f_ones = floor( fmod(value, 1000) )
	
	var s_thousands = str(f_thousands)
	var s_ones = str(f_ones).pad_zeros(3)
	
	$text.text = "M%s,%s" % [s_thousands, s_ones]
