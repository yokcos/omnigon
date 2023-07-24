extends HBoxContainer


var target: Being = null setget set_target
var start_hp: float = 0 setget set_start_hp
var extra_hp: float = 0 setget set_extra_hp
var true_filling: float = 0
var filling: float = 0

const default_theme: Theme = preload("res://misc/theme_main.tres")

signal filling_changed


func hide_text():
	$title.hide()

func show_text():
	$title.show()

func update_hp():
	if is_instance_valid(target):
		true_filling = clamp(target.hp, $bar.min_value, $bar.max_value) - $bar.min_value
		filling = true_filling + extra_hp
		
		var displayed_hp: float = clamp(target.hp, $bar.min_value, $bar.max_value) + extra_hp
		$bar.value = displayed_hp
		emit_signal("filling_changed", filling)

func adjust_title_width():
	var name_width = Game.get_label_size($title/nameholder/name).x
	var subname_width = Game.get_label_size($title/subnameholder/subname).x
	var min_width = max( name_width, subname_width )
	$title.rect_min_size.x = min_width


func get_bar():
	return $bar

func set_target(what: Being):
	if is_instance_valid(target):
		target.disconnect("hp_changed", self, "_on_hp_changed")
	
	target = what
	
	if is_instance_valid(target):
		$bar.max_value = what.max_hp + start_hp
		update_hp()
		$title/nameholder/name.text = what.title
		$title/subnameholder/subname.text = what.subtitle
		
		target.connect("hp_changed", self, "_on_hp_changed")
		call_deferred("adjust_title_width")

func set_start_hp(what: float):
	start_hp = what
	$bar.min_value = start_hp
	if is_instance_valid(target):
		$bar.max_value = start_hp + target.max_hp

func set_extra_hp(what: float):
	extra_hp = what
	update_hp()


func _on_hp_changed(what: float):
	update_hp()
