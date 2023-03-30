extends Node2D


func _ready() -> void:
	$megalift_holder/megalift.disable_interactable()


func rise():
	$animator.play("rise")

func sink():
	$animator.play("sink")

func enable_megalift():
	$megalift_holder/megalift.enable_interactable()

func play_arrive_sound():
	$megalift_holder/megalift.play_arrive_sound()

func play_hiss_sound():
	$megalift_holder/megalift.play_hiss_sound()
