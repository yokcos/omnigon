extends Node2D


func _ready() -> void:
	$megalift_holder/megalift.disable_interactable()


func rise():
	$animator.play("rise")

func sink():
	$animator.play("sink")

func enable_megalift():
	$megalift_holder/megalift.enable_interactable()
