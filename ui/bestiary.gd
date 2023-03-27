extends Control


var all_enemies: Array = []
var selected_slot: int = 0

const obj_list_entry = preload("res://ui/bestiary_list_entry.tscn")
var target_scroll: float = 0

onready var scroller = $listscroller
onready var list = $listscroller/list


signal slain


func _ready() -> void:
	populate_list()
	if all_enemies.size() == 0:
		$nothing.show()
		$enemy_entry.hide()
		$underbuttons.rect_position.x = 0
		$underbuttons.rect_size.x = rect_size.x
	else:
		select_slot(0)
	$animator.play("arrive")

func _process(delta: float):
	scroller.scroll_vertical = lerp(scroller.scroll_vertical, target_scroll, delta*5)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		select_slot(selected_slot - 1)
	if event.is_action_pressed("move_down"):
		select_slot(selected_slot + 1)
	if event.is_action_pressed("map"):
		die()


func populate_list():
	all_enemies = get_all_enemies()
	for i in all_enemies:
		add_entry(i)

func add_entry(what: EnemyData):
	var new_list_entry = obj_list_entry.instance()
	list.add_child(new_list_entry)
	new_list_entry.enemy = what

func get_all_enemies() -> Array:
	var path = "res://entities/enemies/data/"
	var enemies = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var loaded_thing = load(path + file)
			if loaded_thing is EnemyData:
				if PlayerStats.get_kills(loaded_thing) > 0:
					enemies.append(loaded_thing)
	
	dir.list_dir_end()
	
	return enemies

func deselect_all():
	for i in list.get_children():
		i.get_deselected()

func select_slot(what: int):
	deselect_all()
	
	what = wrapi(what, 0, all_enemies.size())
	selected_slot = what
	
	$enemy_entry.enemy = all_enemies[what]
	$enemy_entry.appearify()
	
	var this_entry = list.get_children()[what]
	this_entry.get_selected()
	target_scroll = this_entry.rect_position.y - scroller.rect_size.y/2 + this_entry.rect_size.y/2

func egress():
	queue_free()

func die():
	$animator.play("depart")
	emit_signal("slain")


func _on_egress_pressed() -> void:
	egress()
