extends Node2D


var tex_leap = preload("res://fx/gremlin_leap.png")


func _ready() -> void:
	deploy_leap(true)


func deploy_leap(coming: bool = false):
	var dir = randf() * 2*PI
	
	var new_fx = Game.obj_fx.instance()
	new_fx.texture = tex_leap
	new_fx.hframes = 4
	new_fx.rotation = dir
	new_fx.flip_h = coming
	Game.deploy_instance_instant(new_fx, global_position + Vector2(48, 0).rotated(dir))


func _on_timer_timeout() -> void:
	deploy_leap(false)
	queue_free()
