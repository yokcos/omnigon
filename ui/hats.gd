extends Control


var selected_slot: int = 0
var hats: Array = []
var active: bool = false

var list_tpos: float = 0
var preview_spacing: float = 8
var full_height: float = 0

onready var list: HBoxContainer = $list_holder/sprites
onready var preview: Control = $preview
onready var buttons: VBoxContainer = $underthings/buttons

const hat_width: float = 64.0
const scr_auto_sprite = preload("res://pieces/auto_sprite.gd")

signal quit


func _ready() -> void:
	clear_hats()
	for i in PlayerStats.available_hats:
		add_hat(i)
	apply_preview()
	
	if hats.size() == 0:
		$preview.hide()
		$doff.hide()
		$don.hide()
		$name.text = "Default Hat"
		$description.text = "A plain and serviceable hat that does not look fancy nor act fancily. It does exactly what it needs to do and not a lick more."
	else:
		$list_holder/hatlesness.hide()
	
	call_deferred("select_slot", 0)
	call_deferred("activate")
	$underthings/buttons/don.grab_focus()

func _process(delta: float) -> void:
	list.rect_position.x = lerp(list.rect_position.x, list_tpos, delta*5)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		select_slot(selected_slot - 1)
	if event.is_action_pressed("move_right"):
		select_slot(selected_slot + 1)
	
	if active:
		if event.is_action_pressed("jump") and false:
			if get_button("don").has_focus() or get_button("doff").has_focus():
				call_deferred("toggle_hat")
			if get_button("egress").has_focus():
				egress()


func clear_preview():
	var images = preview.get_children()
	for i in range(1, images.size()):
		images[i].queue_free()
		preview.remove_child(images[i])
	
	full_height = 0

func apply_preview():
	clear_preview()
	
	var anvil_crush_factor = 0.5
	
	var anvil_position: int = -1
	for i in range(PlayerStats.hats.size()):
		if PlayerStats.hats[i].id == "anvil":
			anvil_position = i
	
	for i in range(PlayerStats.hats.size()):
		var hat: Hat = PlayerStats.hats[i]
		var this_scale: float = anvil_crush_factor if anvil_position > i else 1
		var new_sprite = create_preview_hat(hat, this_scale)

func create_preview_hat(hat: Hat, this_scale: float = 1):
	var slots = preview.get_child_count()
	var new_sprite = Sprite.new()
	new_sprite.texture = hat.large_sprite
	new_sprite.hframes = hat.large_frames
	new_sprite.centered = false
	new_sprite.set_script(scr_auto_sprite)
	
	preview.add_child(new_sprite)
	
	full_height += (preview_spacing + hat.height * 4) * this_scale
	new_sprite.position.y = -full_height + 10
	
	if this_scale != 1:
		new_sprite.scale.y = this_scale
		new_sprite.position.y += 32 * (1 - this_scale) / 2
	
	return new_sprite

func get_selected_hat() -> Hat:
	return hats[selected_slot]

func select_slot(what: int):
	if hats.size() > 0:
		selected_slot = wrapi( what, 0, hats.size() )
		
		var sprite = list.get_children()[selected_slot]
		list_tpos = rect_size.x/2 - sprite.position.x - hat_width/2
		
		$underthings/deets/name.text = hats[selected_slot].name
		$underthings/deets/description.text = hats[selected_slot].description
		
		update_buttons()

func update_buttons():
	var this_hat = get_selected_hat()
	if PlayerStats.hats.has(this_hat):
		get_button("doff").show()
		get_button("don").hide()
		
		get_button("doff").grab_focus()
	else:
		get_button("doff").hide()
		get_button("don").show()
		
		get_button("don").grab_focus()

func clear_hats():
	hats = []
	var sprites = list.get_children()
	for sprite in sprites:
		sprite.queue_free()

func add_hat(what: Hat):
	hats.append(what)
	var existing_hats = list.get_child_count()
	
	var new_tex = Sprite.new()
	new_tex.set_script(scr_auto_sprite)
	new_tex.texture = what.large_sprite
	new_tex.hframes = what.large_frames
	new_tex.position.x = hat_width*existing_hats
	new_tex.centered = false
	list.add_child(new_tex)
	new_tex.position.y -= (what.height*4 - 32)

func toggle_hat():
	var this_hat = get_selected_hat()
	
	if !PlayerStats.hats.has(this_hat):
		if !PlayerStats.don_hat(this_hat):
			$animator.play("warn")
	else:
		PlayerStats.doff_hat(this_hat)
	
	apply_preview()
	update_buttons()

func activate():
	active = true

func egress():
	if active:
		active = false
		emit_signal("quit")
		PlayerStats.emit_signal("hats_changed", PlayerStats.hats)
		queue_free()

func get_button(what: String):
	return buttons.get_node(what)



func _on_don_pressed() -> void:
	var this_hat = get_selected_hat()
	
	if !PlayerStats.don_hat(this_hat):
		$animator.play("warn")
	
	apply_preview()
	call_deferred("update_buttons")

func _on_doff_pressed() -> void:
	var this_hat = get_selected_hat()
	
	PlayerStats.doff_hat(this_hat)
	
	apply_preview()
	call_deferred("update_buttons")

func _on_egress_pressed() -> void:
	egress()
