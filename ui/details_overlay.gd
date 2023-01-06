extends Control


const obj_map = preload("res://ui/map/map.tscn")
const obj_bestiary = preload("res://ui/bestiary.tscn")

var current_overlay = 0
var overlay_object: Control = null
var overlays = [
	obj_map,
	obj_bestiary,
]


func _ready() -> void:
	deploy_overlay(0)
	
	get_tree().paused = true
	connect("tree_exiting", self, "_on_slain")
	
	$animator.play("arrive")
	GlobalSound.play_random_sfx(GlobalSound.sfx_bleh)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		current_overlay += 1
		current_overlay = posmod(current_overlay, overlays.size())
		switch_overlay(current_overlay)


func cull_overlay():
	if is_instance_valid(overlay_object):
		overlay_object.disconnect("tree_exiting", self, "_on_overlay_slain")
		overlay_object.die()
		overlay_object = null

func deploy_overlay(which: int):
	var new_overlay = overlays[which].instance()
	new_overlay.connect("tree_exiting", self, "_on_overlay_slain")
	$contents/overlay.add_child(new_overlay)
	overlay_object = new_overlay

func switch_overlay(which: int):
	current_overlay = which
	overlay_object.connect("tree_exiting", self, "_on_switch_complete")
	
	cull_overlay()
	
	#$animator.stop()
	#$animator.play("spin")
	
	yield(get_tree().create_timer(0.5), "timeout")
	GlobalSound.play_random_sfx(GlobalSound.sfx_bleh)


func _on_overlay_slain():
	$animator.play("depart")
	var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_bleh)
	new_sfx.pitch_scale = 0.7

func _on_switch_complete():
	deploy_overlay(current_overlay)

func _on_slain():
	get_tree().paused = false
