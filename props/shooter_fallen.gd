extends RigidBody2D


export (float) var shot_speed = 200
export (float) var interval = 2
export (float, 0, 1) var phase = 0

var spawn_position: Vector2 = Vector2()
var rtime = interval

var obj_shooter = load("res://props/shooter.tscn")

const obj_bullet = preload("res://projectiles/bullet.tscn")


func _ready() -> void:
	spawn_position = global_position
	rtime = interval * (1 - phase)

func _process(delta: float) -> void:
	rtime -= delta
	if rtime <= 0:
		rtime += interval
		activate()


func activate():
	$animator.play("shoot")

func shoot():
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(shot_speed, 0).rotated(global_rotation)
	# Cut because hurtbox.source has to be a Being, to allow for things like retaliatory damage
	# Not deleted because I might want to change that sometime
	#new_bullet.source = self
	
	Game.deploy_instance(new_bullet, $barrel.global_position)

func get_shifted():
	var new_shooter = obj_shooter.instance()
	Game.replace_instance(self, new_shooter)
	new_shooter.disable_shiftbox()


