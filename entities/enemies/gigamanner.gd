extends Enemy


var has_target = false
export (float) var target_longitude = 0
export (float) var blockade_duration = 10

const fx_zapfront = preload("res://fx/zapfront.tscn")
const obj_bullet = preload("res://projectiles/bullet.tscn")
var obj_electrodrill = load("res://entities/enemies/electrodrill.tscn")


func _ready() -> void:
	randomize()
	
	extra_data["target_longitude"] = target_longitude
	extra_data["blockade_duration"] = blockade_duration

func _process(delta: float) -> void:
	if has_target and $fsm/patrol.age > 0.1:
		$fsm/patrol.perform_action_random(["attacc0", "attacc1"])


func get_loaded(data):
	if data:
		.get_loaded(data)
		
		if data.has("target_longitude"):
			target_longitude = data["target_longitude"]
		if data.has("blockade_duration"):
			blockade_duration = data["blockade_duration"]

func perform_attacc0():
	for i in range(8):
		var new_zapfront = fx_zapfront.instance()
		new_zapfront.rotation = i * (PI/4)
		var size = rand_range(0.5, 0.6)
		new_zapfront.scale = Vector2(size, size)
		Game.deploy_instance(new_zapfront, $flippable/zap_centre.global_position)
	
	$flippable/hurtbox0.pulse(0.1)
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_eel_shoot, global_position )

func perform_attacc1():
	var new_bullet = obj_bullet.instance()
	Game.deploy_instance(new_bullet, $flippable/barrel.global_position)
	new_bullet.velocity = Vector2( 100*flip_int, 0 )
	
	velocity = Vector2( -500*flip_int, -200 )
	
	var new_sfx = GlobalSound.play_random_sfx_2d( GlobalSound.sfx_blast, global_position )
	new_sfx.volume_db = -8

func land():
	.land()
	
	if $fsm/attacc1.recovering:
		$fsm/attacc1.set_state("patrol")

func launch_attacc():
	var possibilities = ["attacc0", "attacc1"]
	$fsm/patrol.perform_action_random(possibilities)



func get_shifted():
	var new_electrodrill = obj_electrodrill.instance()
	new_electrodrill.target_longitude = target_longitude
	new_electrodrill.blockade_duration = blockade_duration
	new_electrodrill.ceilingborne = false
	Game.replace_instance(self, new_electrodrill)


func _on_entity_detector_updated(what: Array) -> void:
	has_target = what.size() > 0

