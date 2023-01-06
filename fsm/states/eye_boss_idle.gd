extends State


var upper_attacks: Array = ["attacc_shoot", "attacc_laser"]
var lower_attacks: Array = ["attacc_guns", "attacc_dive"]
var attacks: Array = [upper_attacks, lower_attacks]
var stage = 0


func _ready() -> void:
	randomize()
	stage = randi() % 2

func _step(delta: float):
	._step(delta)
	
	var target_velocity: Vector2 = Vector2()
	
	if father.target:
		var relative: float = father.target.global_position.x - father.global_position.x
		target_velocity.x = relative
	
	if father.global_position.y > father.target_height:
		target_velocity.y = -30
	if father.global_position.y < father.target_height:
		target_velocity.y =  5
	
	father.velocity = father.velocity.linear_interpolate(target_velocity, delta*2)
	
	if age > 4:
		attack()


func attack():
	var possible_attacks: Array = attacks[stage]
	stage = 1 - stage
	var index = randi() % possible_attacks.size()
	set_state(possible_attacks[index])
