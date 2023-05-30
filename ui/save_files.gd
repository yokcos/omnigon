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
	var file_count = $clipper/scroller/list.get_child_count()
	
	if event.is_action_pressed("ui_accept"):
		var selection = get_selection()
		if selection >= 0:
			$clipper/scroller/list.get_child( get_selection() ).activate()
	
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
	for i in $clipper/scroller/list.get_children():
		i.queue_free()
	
	for i in range(files.size()):
		var dict = files[i]
		var new_file = obj_file.instance()
		new_file.set_index(i)
		new_file.set_file(dict)
		new_file.connect("save_deleted", self, "_on_save_deleted")
		new_file.father = self
		$clipper/scroller/list.add_child(new_file)
	
	var new_file = obj_file.instance()
	new_file.set_index(files.size())
	new_file.make_new()
	new_file.connect("save_deleted", self, "_on_save_deleted")
	new_file.father = self
	$clipper/scroller/list.add_child(new_file)
	
	connect_files()

func connect_files():
	var things = []
	for i in $clipper/scroller/list.get_children():
		things.append(i)
	things.append($egress)
	
	for i in range(things.size()):
		var this_thing: Control = things[i]
		var next_thing: Control = things[posmod(i+1, things.size())]
		var this_path: NodePath = next_thing.get_path_to(this_thing)
		var next_path: NodePath = this_thing.get_path_to(next_thing)
		
		this_thing.focus_neighbour_bottom = next_path
		this_thing.focus_next = next_path
		
		next_thing.focus_neighbour_top = this_path
		next_thing.focus_previous = this_path

func deselect_all():
	for i in $clipper/scroller/list.get_children():
		i.get_deselected()

func show_selection():
	if selected_file >= 0:
		$clipper/scroller/list.get_child(selected_file).grab_focus()

func get_selection():
	var entries = $clipper/scroller/list.get_children()
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
	selected_file = int( min( selected_file, files.size()-1 ) )
	catalogue_files()
	display_files()
	show_selection()
