extends Control


var files: Array = []
var selected_file: int = 0

const obj_file = preload("res://ui/save_file.tscn")


func _ready() -> void:
	catalogue_files()
	display_files()
	show_selection()

func _input(event: InputEvent) -> void:
	var previous_file: int = selected_file
	var file_count = $list.get_child_count()
	
	if event.is_action_pressed("ui_accept"):
		var selection = get_selection()
		if selection >= 0:
			$list.get_child( get_selection() ).activate()
	
	if event.is_action_pressed("ui_cancel"):
		egress()


func catalogue_files():
	files = []
	var i: int = 0
	while true:
		if Game.save_file_exists(i):
			files.append(Game.load_game(i))
		else:
			break
		i += 1

func display_files():
	for i in $list.get_children():
		i.queue_free()
	
	for i in range(files.size()):
		var dict = files[i]
		var new_file = obj_file.instance()
		new_file.set_index(i)
		new_file.set_file(dict)
		new_file.connect("save_deleted", self, "_on_save_deleted")
		new_file.father = self
		$list.add_child(new_file)
	
	var new_file = obj_file.instance()
	new_file.set_index(files.size())
	new_file.make_new()
	new_file.connect("save_deleted", self, "_on_save_deleted")
	new_file.father = self
	$list.add_child(new_file)

func deselect_all():
	for i in $list.get_children():
		i.get_deselected()

func show_selection():
	if selected_file >= 0:
		$list.get_child(selected_file).grab_focus()

func get_selection():
	var entries = $list.get_children()
	for i in range(entries.size()):
		var this_entry: Control = entries[i]
		if this_entry.has_focus():
			return i
	return -1

func egress():
	get_tree().change_scene("res://ui/main_menu.tscn")


func _on_egress_pressed() -> void:
	egress()

func _on_save_deleted():
	selected_file = get_selection()
	selected_file = min( selected_file, files.size()-1 )
	catalogue_files()
	display_files()
	show_selection()
