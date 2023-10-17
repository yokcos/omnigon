extends Control


var textures = [
	preload("res://ui/ovation_thermometer0.png"),
	preload("res://ui/ovation_thermometer1.png"),
	preload("res://ui/ovation_thermometer2.png"),
	preload("res://ui/ovation_thermometer3.png"),
	preload("res://ui/ovation_thermometer4.png"),
]


func _ready() -> void:
	var player = Game.get_player()
	if is_instance_valid(player):
		player.set_stun_duration(1)
		player.set_state("stunned")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		$link.activate()


func set_level(what: int):
	$auto_sprite.texture = textures[what]

func set_score(what: float):
	var i_score = int(what)
	var s_score = str(i_score)
	s_score = s_score.pad_zeros(4)
	$score.text = "SCORE: %s" % s_score
