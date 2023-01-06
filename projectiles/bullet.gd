extends "res://pieces/hurtbox.gd"


export (int) var penetrations = 0
export (bool) var thru_walls = false

export (Texture) var death_particles = null
export (int) var death_particle_frames = 8

var velocity: Vector2 = Vector2()
var acceleration: Vector2 = Vector2()


func _ready() -> void:
	active = true

func _process(delta: float) -> void:
	position += velocity * delta
	velocity += acceleration * delta


func hit_enemy(what: Being):
	.hit_enemy(what)
	
	penetrations -= 1
	if penetrations < 0:
		die()

func die():
	queue_free()
	
	if death_particles:
		Game.deploy_fx(death_particles, global_position, death_particle_frames)


func _on_wall_detector_body_entered(body: Node) -> void:
	if !thru_walls:
		die()
