extends AnimationPlayer


func _ready() -> void:
	Events.connect("moneybags_incapacitated", self, "_on_moneybags_incapacitated")


func _on_moneybags_incapacitated():
	play("timegun_arrive")
