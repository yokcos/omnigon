extends Node2D


export (Vector2) var camera_position = Vector2()

var active: bool = false
var current_vignette: Control = null

const obj_vignette = preload("res://ui/binoculars_vignette.tscn")


func _process(delta: float) -> void:
	if active:
		var player = Game.get_player()
		var cam = Game.camera
		if is_instance_valid(player) and is_instance_valid(cam):
			cam.target_pos = camera_position - player.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if active:
			call_deferred("deactivate")


func cull_vignette():
	if is_instance_valid(current_vignette):
		current_vignette.queue_free()
	current_vignette = null

func activate():
	var player = Game.get_player()
	var cam = Game.camera
	
	if is_instance_valid(player) and is_instance_valid(cam):
		active = true
		
		player.long_stun()
		cam.target_pos = camera_position - player.global_position
		
		var new_vignette = obj_vignette.instance()
		Game.deploy_ui_instance(new_vignette, Vector2())
		current_vignette = new_vignette
		
		$interactable.active = false

func deactivate():
	var player = Game.get_player()
	var cam = Game.camera
	
	if is_instance_valid(player) and is_instance_valid(cam):
		active = false
		
		player.set_state("normal")
		cam.target_pos = Vector2()
		cam.position = Vector2()
		cull_vignette()
		
		$interactable.active = true


func _on_interactable_activated() -> void:
	call_deferred("activate")
