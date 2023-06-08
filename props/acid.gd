tool
extends "res://props/water.gd"


const tex_geyser = preload("res://fx/geyser.png")


func _process(delta: float) -> void:
	if !Engine.editor_hint and randf()*60 < 1:
		var pos = global_position
		pos.y -= size.y/2 * cell_size.y
		pos.x += rand_range(-size.x, size.x) / 2 * cell_size.x
		pos.y -= 64
		var new_fx = Game.deploy_fx(tex_geyser, pos)
		
		if randf()*2 < 1:
			new_fx.scale.x = -1


func _on_body_entered(body: Node) -> void:
	if body.has_method("get_acided"):
		body.get_acided()
