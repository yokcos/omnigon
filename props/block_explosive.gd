extends StaticBody2D


var exploding: bool = false
var spawn_position: Vector2 = Vector2()

const tex_explosion = preload("res://fx/explosionB.png")


func _ready() -> void:
	add_to_group("explodables")
	
	spawn_position = global_position
	
	if WorldSaver.data.has(Rooms.current_room):
		for dict in WorldSaver.data[Rooms.current_room]:
			if dict is Dictionary and dict["type"] == "removal":
				if dict["pos"].round() == spawn_position.round():
					hide()
					queue_free()

func activate():
	WorldSaver.save_data(
		{
			"type": "removal",
			"pos": spawn_position,
		},
		true
	)
	
	if !exploding:
		$blast_player.pulse(0.1)
		$blast_enemy.pulse(0.2)
		var new_fx = Game.deploy_fx(tex_explosion, global_position, 10)
		if new_fx:
			new_fx.rotation = randf()*2*PI
		Game.shake_cam_random(2)
		$sprite.hide()
		$destroyer.start()
		
		exploding = true
		
		GlobalSound.play_random_sfx_2d(GlobalSound.sfx_blast, global_position)

func chain_explosion():
	for i in $anything_detector.overlapping_entities:
		if i != self:
			i.activate()

func get_shifted():
	activate()


func _on_destroyer_timeout() -> void:
	chain_explosion()
	queue_free()
