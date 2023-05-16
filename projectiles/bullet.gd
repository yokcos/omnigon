extends "res://pieces/hurtbox.gd"


export (int) var penetrations = 0
export (bool) var thru_walls = false

export (Texture) var death_particles = null
export (int) var death_particle_frames = 8

var duration: float = 12
var velocity: Vector2 = Vector2()
var acceleration: Vector2 = Vector2()

var obj_ball: PackedScene = load("res://projectiles/bullet_ball.tscn")


func _ready() -> void:
	active = true

func _process(delta: float) -> void:
	position += velocity * delta
	velocity += acceleration * delta
	duration -= delta
	if duration <= 0:
		queue_free()


func hit_enemy(what: Being):
	.hit_enemy(what)
	
	penetrations -= 1
	if penetrations < 0:
		die()

func die():
	queue_free()
	
	if death_particles:
		Game.deploy_fx(death_particles, global_position, death_particle_frames)

func set_sprite(what: Texture, frames: int = 8):
	$auto_sprite.texture = what
	$auto_sprite.hframes = frames


func _on_wall_detector_body_entered(body: Node) -> void:
	if !thru_walls:
		die()

func _on_shift() -> void:
	var new_ball = obj_ball.instance()
	new_ball.linear_velocity = Vector2(0, -16).rotated(rand_range(-PI/2, PI/2))
	Game.replace_instance(self, new_ball)
