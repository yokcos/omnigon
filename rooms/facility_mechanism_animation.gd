extends Node2D


var current_megalift: Node2D = null

const obj_megalift = preload("res://props/megalift.tscn")


func _ready() -> void:
	Events.connect("megalift_created", self, "_on_megalift_created")


func activate():
	WorldSaver.save_global_data("megalift_room", Rooms.current_room)
	var new_megalift = obj_megalift.instance()
	new_megalift.disable_interactable()
	$megalift_holder.add_child(new_megalift)
	new_megalift.position = Vector2()
	current_megalift = new_megalift
	
	$animator.play("arrive")

func enable_megalift():
	if is_instance_valid(current_megalift):
		current_megalift.enable_interactable()

func play_arrive_sound():
	if is_instance_valid(current_megalift):
		current_megalift.play_arrive_sound()

func play_hiss_sound():
	if is_instance_valid(current_megalift):
		current_megalift.play_hiss_sound()


func _on_megalift_created():
	activate()
