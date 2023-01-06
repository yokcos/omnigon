extends Control


var target: Being = null setget set_target


func set_target(what: Being):
	if is_instance_valid(target):
		target.disconnect("hp_changed", self, "_on_hp_changed")
	
	target = what
	
	if is_instance_valid(target):
		$bar.max_value = what.max_hp
		$bar.value = what.hp
		$name.text = what.title
		
		target.connect("hp_changed", self, "_on_hp_changed")


func _on_hp_changed(what: float):
	$bar.value = what
