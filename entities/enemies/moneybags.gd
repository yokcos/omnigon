extends "res://entities/enemies/enemy.gd"


var attacks = ["attacc0", "attacc1", "attacc2"]

const obj_rocket = preload("res://projectiles/rocket.tscn")
const obj_stoppy = preload("res://projectiles/stoppy_rocket.tscn")
const obj_explosion = preload("res://fx/explosion.tscn")
const scr_effect_uncontrol = preload("res://pieces/effects/effect_air_uncontrol.gd")


func _ready() -> void:
	coyote_time = 0

func _process(delta: float) -> void:
	if !is_instance_valid($fsm/idle.target):
		$fsm/idle.target = Game.get_player()
		Game.set_boss(self)


func take_damage(dmg: float, source: Being = null):
	var actual_dmg = .take_damage(dmg, source)
	
	return actual_dmg

func shoot(what: PackedScene = obj_rocket):
	var dir: Vector2 = $flippable/barrel.global_transform.x.normalized()
	var rocket_speed: float = 40
	var rocket_acceleration: float = 400
	
	var new_rocket: Projectile = what.instance()
	new_rocket.velocity = rocket_speed * dir
	new_rocket.acceleration = rocket_acceleration * dir
	
	Game.deploy_instance(new_rocket, $flippable/barrel.global_position)
	return new_rocket

func random_attack():
	var these_attacks = attacks.duplicate()
	if hp > max_hp/2:
		these_attacks.append("jump_pre")
	
	var index: int = randi() % these_attacks.size()
	var this_attack: String = these_attacks[index]
	$fsm/idle.set_state(this_attack)


func _on_attacc_timer_timeout() -> void:
	random_attack()

func _on_idle_entered() -> void:
	$attacc_timer.start()

func _on_attacc0_activated() -> void:
	shoot()

func _on_attacc1_activated() -> void:
	var new_rocket = shoot()
	new_rocket.velocity = new_rocket.velocity.normalized() * 200
	new_rocket.velocity.y -= 200
	new_rocket.acceleration.y = 600

func _on_attacc2_activated() -> void:
	shoot(obj_stoppy)

func _on_jump_pre_exited() -> void:
	velocity.y -= 350
	velocity.x += flip_int * 300
	
	var new_effect = scr_effect_uncontrol.new()
	new_effect.duration = 2
	new_effect.multiplier = .1
	add_child(new_effect)
	
	var new_explosion = obj_explosion.instance()
	Game.deploy_instance(new_explosion, $flippable/footsplosion.global_position)
