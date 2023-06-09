extends KinematicBody2D


var velocity: Vector2 = Vector2()
var gravy: float = 98

const tex_splash = preload("res://fx/vomit_splash.png")


func _ready() -> void:
	$sprite.frame = randi() % $sprite.hframes

func _physics_process(delta: float) -> void:
	move_and_slide(velocity)
	velocity.y += gravy * delta
	
	if get_slide_count() > 0:
		var hit := get_slide_collision(0)
		
		var pos = hit.position
		var norm = hit.normal
		
		var new_fx = Game.deploy_fx(tex_splash, pos)
		new_fx.rotation = norm.angle()
