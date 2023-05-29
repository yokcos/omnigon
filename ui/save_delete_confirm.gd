extends Control


var index: int = 0
var father: Control = null

signal save_deleted


func _ready() -> void:
	$bac/buttons/nay.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		depart()
	if event.is_action_pressed("ui_cancel"):
		depart()


func activate():
	Game.remove_save_file(index)
	emit_signal("save_deleted")
	queue_free()

func depart():
	father.grab_focus()
	$animator.play("depart")


func _on_nay_pressed() -> void:
	depart()

func _on_yea_pressed() -> void:
	activate()
