extends RigidBody2D


var base_bar = null
var target = null
var all_bars = []
var obj_hp_bar = load("res://entities/extra_hp.tscn")


func _ready() -> void:
	apply_central_impulse( Vector2(0, -100).rotated(rand_range(-1, 1)) )
	angular_velocity = rand_range(-1, 1)


func _on_shift() -> void:
	if is_instance_valid(target):
		target.hp += target.max_hp
		print("Boss HP is now %s" % target.hp)
		
		var new_hp_bar = obj_hp_bar.instance()
		new_hp_bar.base_bar = base_bar
		new_hp_bar.target = target
		new_hp_bar.all_bars = all_bars
		new_hp_bar.pos = all_bars.size()
		all_bars.append(new_hp_bar)
		Game.replace_instance(self, new_hp_bar)
	else:
		queue_free()

func _on_punch() -> void:
	var player = Game.get_player()
	if is_instance_valid(player):
		player.hp += 1
		queue_free()
