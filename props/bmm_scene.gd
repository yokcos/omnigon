extends Node2D


func _ready() -> void:
	hide()
	
	Events.connect("bmm_interrupted", self, "_on_bmm_interrupted")


func activate():
	if !visible:
		show()
		
		for i in get_children():
			if i.has_node("animator"):
				var animator: AnimationPlayer = i.get_node("animator")
				animator.play("arrive")


func _on_bmm_interrupted():
	activate()
