extends Control


var texts = [
	"Omnigon is in the public domain",
	"Game made by Yokcos",
	"Eat your veggies",
	"Rule 1: Have fun. Or face a hefty fine",
	"Originally failed Metroidvania Month!",
	"What's an omnigon?",
	"The eyes have it",
	"Spring to win",
	"Also try Fishticuffs",
	"Infiltration-themed hat simulator",
	"Hats upon hats!",
	"Fear the Masters of Blades",
	"Made you look!",
	"Made with Godot",
	"Boing Boing!",
	"Merely a demo",
	"Vertices in pipes",
	"Deepest lore in the industry",
	"Default text here",
	"Highly purple",
	"Jumping and punching",
	"Beware the Queen of Bones",
	"Unbreakable embargo",
	"The Day of the Demos!",
	"Breakable pots!",
	"Don't read me!",
	"99% mimic-free",
	"Escaping certain demise",
	"Stealing secrets",
	"Do your homework",
	"Also try Homestuck",
	"Has a Patreon",
	"Survivor of Demo Day",
	"Thanks aggy daggy!",
	"Gears and clockwork",
	"Punchable pots",
	"Shifting shapes",
	"Gears and Clockwork",
	"Lives on itch.io",
	"Lives on steam",
	"The land of Aketrex",
	"Enter text here",
	"Sailing through space",
	"Not a smelly game",
]
var current_texts = {}
var lore = "Your enemies in the NORTH are working out the secrets of TIME TRAVEL! This cannot be allowed, but fortunately your people in the SOUTH have the secrets of SPACE TRAVEL. By which I mean TELEPORTATION, which you have used to enter the very bowels of their research base! Now all that's left is to locate and steal their SECRETS!"

var background_colour = Color("e3e6ff")

const obj_text = preload("res://ui/mainmenu_text.tscn")
const obj_options = preload("res://ui/options/options.tscn")


func _ready() -> void:
	randomize()
	
	GlobalSound.cut_temp_music()
	GlobalSound.play_music("prelude", false)
	
	$column/begin.grab_focus()
	link_pieces()
	
	for i in range(6):
		deploy_text(randf() * $right_half.rect_size.x)
	
	VisualServer.set_default_clear_color(background_colour)
	Game.background_colour = background_colour

func _process(delta: float) -> void:
	if randf()*120 < 1:
		deploy_text()


func link_pieces():
	var links = $column/links.get_children()
	var linkcount = links.size()
	for i in range(linkcount):
		var prev = posmod(i-1, linkcount)
		var next = posmod(i+1, linkcount)
		var this_link: TextureButton = links[i]
		var prev_path: NodePath = this_link.get_path_to(links[prev])
		var next_path: NodePath = this_link.get_path_to(links[next])
		var up_path: NodePath = this_link.get_path_to($column/quit)
		var down_path: NodePath = this_link.get_path_to($column/begin)
		
		this_link.focus_neighbour_right = next_path
		this_link.focus_neighbour_bottom = down_path
		this_link.focus_next = next_path
		
		this_link.focus_neighbour_left = prev_path
		this_link.focus_neighbour_top = up_path
		this_link.focus_previous = prev_path
	
	var end_path = $column/quit.get_path_to($column/links/link_yokcos)
	var start_path = $column/begin.get_path_to($column/links/link_yokcos)
	
	$column/begin.focus_neighbour_top = start_path
	$column/begin.focus_previous = start_path
	
	$column/quit.focus_neighbour_bottom = end_path
	$column/quit.focus_next = end_path

func text_exists(height):
	if !current_texts.has(height):
		return false
	return is_instance_valid(current_texts[height])

func deploy_text(offset = 0):
	var index = randi() % texts.size()
	var new_text = obj_text.instance()
	new_text.text = texts[index]
	var height: float = randf() * ($right_half.rect_size.y - new_text.rect_size.y)
	height = round(height/16) * 16
	
	if !text_exists(height):
		$right_half.add_child(new_text)
		new_text.rect_position.x = $right_half.rect_size.x - offset
		new_text.rect_position.y = height
		
		current_texts[height] = new_text
	else:
		new_text.queue_free()


func _on_begin_pressed() -> void:
	get_tree().change_scene("res://gameholder.tscn")
	PlayerStats.call_deferred("apply_position")
	#Game.call_deferred("summon_popup", "Vital lore", lore, "Oh okay", null)

func _on_options_pressed() -> void:
	var new_options = obj_options.instance()
	new_options.cull_egress_buton()
	$overlay.add_child(new_options)
	new_options.rect_position = Vector2(448, 136)
	
	new_options.connect("tree_exiting", self, "_on_options_slain")

func _on_quit_pressed() -> void:
	if OS.get_name() != "HTML5" or true:
		Game.save_game()
	get_tree().quit()


func _on_options_slain():
	$column/options.grab_focus()


