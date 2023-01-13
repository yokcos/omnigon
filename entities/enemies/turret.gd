extends Enemy


var obj_bullet = preload("res://projectiles/bullet.tscn")
var obj_automaton = load("res://entities/enemies/automaton.tscn")


func _ready() -> void:
	can_flip = false


func shoot():
	var new_bullet = obj_bullet.instance()
	Game.deploy_instance(new_bullet, $flippable/barrel.global_position)
	new_bullet.velocity = Vector2(60, 0) * flip_node.scale
	
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_DT, global_position)

func get_shifted():
	var new_automaton = obj_automaton.instance()
	Game.replace_instance(self, new_automaton)


func _on_shoot_timer_timeout() -> void:
	$animator.play("shoot")

func _on_entity_detector_activated() -> void:
	$fsm/normal.set_state("turn")

func _on_turn_entered() -> void:
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_automaton_turn, global_position)

func _on_turn_exited() -> void:
	invert_flip()
	$animator.play("idle")
	$flippable/sprite.frame = 0

func _on_normal_entered() -> void:
	$shoot_timer.start()

func _on_normal_exited() -> void:
	$shoot_timer.stop()

