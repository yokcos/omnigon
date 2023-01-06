extends "res://fsm/states/stunned.gd"


var side: int = 0
var targets_x: Array = []
var room_margin: float = 96
var has_positioned_hands: bool = false
var reload: float = 1
var rtime: float = reload


func _ready():
	var room_width: float = Rooms.room_size.x
	if Game.world:
		room_width *= Game.world.room_size.x
	
	targets_x = [room_margin, room_width - room_margin]

func _enter():
	._enter()
	
	side = randi() % 2
	has_positioned_hands = false

func _step(delta: float):
	._step(delta)
	
	# Horizontalise
	var relative_x = targets_x[side] - father.global_position.x
	father.velocity.x = relative_x * delta * 80
	
	# Verticalify
	var factor = max(abs(relative_x), 1)
	father.velocity.y = 500 / factor
	
	if relative_x < 16:
		if !has_positioned_hands:
			position_hands()
			has_positioned_hands = true
		
		rtime -= delta
		if rtime < 0:
			father.shoot(100, 0, [0, 1])
			father.particulate_hands([0, 1])
			father.recoil_hands([side], 90)
			father.recoil_hands([1-side], -90)
			
			rtime += reload
			
			if father.has_hand(0) or father.has_hand(1):
				var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_eyesaac_shoot, father.global_position)
				new_sfx.max_distance = 600

func _exit():
	._exit()
	
	father.reset_hands()


func position_hands():
	# SIDE is the upper hand
	father.position_hands([side], Vector2(0, -48))
	father.position_hands([1-side], Vector2(48, 32))
	father.rotate_hands([side], PI - 0.05)
	father.rotate_hands([1-side], 0)



func _on_father_damage_taken(what: float) -> void:
	age += what*2
