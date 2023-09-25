extends Node2D


var prev_world = null
var prev_paused: bool = false
var score: float = 0
var age: float = 0
var bubble_sfx: SFX = null
var score_threshholds = [0, 15, 30, 80, 150]

const obj_thermometer = preload("res://ui/ovation_thermometer.tscn")

signal ended


func _ready() -> void:
	prev_world = Game.world
	Game.world = self
	connect("tree_exiting", self, "_on_tree_exiting")
	Events.connect("fishticuffs_score_gained", self, "_on_score_gained")
	
	$ui/health_display.target = $hook
	$ui/time_display.target = self
	
	GlobalSound.play_temp_music("fc_ocean")
	GlobalSound.play_random_sfx(GlobalSound.sfx_fc_splash)
	bubble_sfx = GlobalSound.play_random_sfx(GlobalSound.sfx_fc_bubblies)
	bubble_sfx.volume_db = -15
	
	prev_paused = get_tree().paused
	get_tree().paused = true
	Physics2DServer.set_active(true)

func _process(delta: float) -> void:
	age += delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("interact"):
		end()


func deploy_instance(what, where):
	what.position = where
	call_deferred("add_child", what)

func end():
	queue_free()
	emit_signal("ended", score)


func _on_tree_exiting():
	if is_instance_valid(bubble_sfx):
		bubble_sfx.queue_free()
	Game.world = prev_world
	GlobalSound.reset_music()
	get_tree().paused = prev_paused
	
	var ovation_level: int = 0
	for i in range( score_threshholds.size() ):
		if score >= score_threshholds[i]:
			ovation_level = i
	var this_popup = Game.summon_popup_world( obj_thermometer, "Witness the audience reaction" )
	this_popup.anchor = Game.get_player()
	this_popup.world.set_level(ovation_level)
	this_popup.world.set_score(score)

func _on_score_gained(what: float):
	score += what

func _on_hook_died() -> void:
	end()
