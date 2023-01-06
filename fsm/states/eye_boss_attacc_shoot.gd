extends State


export (float) var duration = 8

var reload: float = 0.75
var rtime: float = reload
var current_hand: int = 0


func _begin():
	._begin()
	
	rtime = reload

func _step(delta: float):
	._step(delta)
	
	rtime -= delta
	if rtime <= 0:
		shoot(100, 3, 40, [current_hand])
		current_hand = 1 - current_hand
		rtime = reload
	
	if age >= duration:
		set_state(auto_proceed)


func shoot(speed: float = 100, quantity: int = 5, spread: float = 20, hands: Array = [0, 1]):
	for i in range(quantity):
		var pos: float = float(i) - float(quantity)/2.0 + 0.5
		father.shoot(speed, spread*pos, hands)
	father.particulate_hands(hands)
	father.recoil_hands(hands)
	if father.has_hand(hands[0]):
		var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_eyesaac_shoot, father.global_position)
		new_sfx.max_distance = 600
