extends Enemy


const tex_pop: Texture = preload("res://fx/airhead_pop.png")
var obj_floater: PackedScene = load("res://entities/enemies/floater.tscn")

var ascending: bool = false


func _ready() -> void:
	sfx_death = GlobalSound.sfx_pop

func _process(delta: float) -> void:
	if ascending:
		velocity.y -= 1000 * delta
		velocity.y -= velocity.y * delta * 5


func ascend():
	ascending = true
	velocity.y = 100

func get_shifted():
	Game.replace_instance(self, obj_floater.instnace())


func _on_ceiling_detector_body_entered(body: Node) -> void:
	Game.deploy_fx(tex_pop, global_position, 8)
	die()
