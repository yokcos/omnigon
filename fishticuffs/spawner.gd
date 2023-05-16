extends Node


var spawnpower: float = 2
var age: float = 0
var room_size: Vector2 = Vector2(512, 288)

const obj_fish = preload("res://fishticuffs/fish/fish.tscn")
const obj_fish_great = preload("res://fishticuffs/fish/fish_great.tscn")
const obj_fish_greater = preload("res://fishticuffs/fish/fish_greater.tscn")
const obj_starfish = preload("res://fishticuffs/fish/starfish.tscn")
const obj_angler = preload("res://fishticuffs/fish/angler.tscn")
const obj_fisht = preload("res://fishticuffs/fish/fisht.tscn")

var fish_types = [
	obj_fish, obj_fish_great, obj_fish_greater,
	obj_starfish, obj_angler, obj_fisht
]
var fish_values = [1, 3, 5, 8, 12, 15]
var fish_queue = []


func _ready() -> void:
	call_deferred("spawn_wave")

func _process(delta: float) -> void:
	spawnpower += delta * (1 + age/50.0)
	age += delta
	
	if randf()*60 < 1:
		if fish_queue.size() > 0:
			spawn_enemy( fish_queue.pop_front() )


func attempt_spawn():
	var indices = range( fish_values.size() )
	indices.shuffle()
	for i in indices:
		if spawnpower > fish_values[i]:
			spawnpower -= fish_values[i]
			fish_queue.append(fish_types[i])
			return true
	return false

func spawn_enemy(what: PackedScene):
	var y = 16 + randf() * (room_size.y - 32)
	var x = -8
	if randf() < .5:
		x = room_size.x + 8
	
	var new_enemy: Being = what.instance()
	if x > 0:
		new_enemy.flipped = true
	Game.deploy_instance( new_enemy, Vector2(x, y) )

func spawn_wave():
	var successful = true
	while successful:
		successful = attempt_spawn()


func _on_timer_timeout() -> void:
	spawn_wave()
