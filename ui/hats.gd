extends Control


var selected_slot: int = 0
var hats: Array = []
var active: bool = false

var list_tpos: float = 0
var preview_spacing: float = 40
onready var list: HBoxContainer = $list_holder/sprites
onready var preview: Control = $list_holder/preview

signal quit


func _ready() -> void:
	clear_hats()
	for i in PlayerStats.available_hats:
		add_hat(i)
	apply_preview()
	
	if hats.size() == 0:
		$list_holder/preview.hide()
		$doff.hide()
		$don.hide()
		$name.text = "Default Hat"
		$description.text = "A plain and serviceable hat that does not look fancy nor act fancily. It does exactly what it needs to do and not a lick more."
	else:
		$list_holder/hatlesness.hide()
	
	call_deferred("select_slot", 0)
	call_deferred("activate")
	
	grab_focus()

func _process(delta: float) -> void:
	list.rect_position.x = lerp(list.rect_position.x, list_tpos, delta*5)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		select_slot(selected_slot - 1)
	if event.is_action_pressed("move_right"):
		select_slot(selected_slot + 1)
	
	if event.is_action_pressed("jump") and active:
		var this_hat = get_selected_hat()
		
		if !PlayerStats.hats.has(this_hat):
			PlayerStats.hats.append(this_hat)
		else:
			PlayerStats.hats.erase(this_hat)
		
		apply_preview()
		update_buttons()


func clear_preview():
	var images = preview.get_children()
	for i in range(1, images.size()):
		images[i].queue_free()
		preview.remove_child(images[i])

func apply_preview():
	clear_preview()
	
	for hat in PlayerStats.hats:
		create_preview_hat(hat)

func create_preview_hat(what: Hat):
	var slots = preview.get_child_count()
	var new_tex = TextureRect.new()
	new_tex.texture = what.large_sprite
	
	preview.add_child(new_tex)
	new_tex.rect_position.y = -preview_spacing * slots

func get_selected_hat() -> Hat:
	return hats[selected_slot]

func select_slot(what: int):
	if hats.size() > 0:
		selected_slot = wrapi( what, 0, hats.size() )
		
		var sprite = list.get_children()[selected_slot]
		list_tpos = rect_size.x/2 - sprite.rect_position.x - sprite.rect_size.x/2
		
		$name.text = hats[selected_slot].name
		$description.text = hats[selected_slot].description
		
		update_buttons()

func update_buttons():
	var this_hat = get_selected_hat()
	if PlayerStats.hats.has(this_hat):
		$doff.disabled = false
		$don.disabled = true
	else:
		$doff.disabled = true
		$don.disabled = false

func clear_hats():
	hats = []
	var sprites = list.get_children()
	for sprite in sprites:
		sprite.queue_free()

func add_hat(what: Hat):
	hats.append(what)
	
	var new_tex = TextureRect.new()
	new_tex.texture = what.large_sprite
	list.add_child(new_tex)

func activate():
	active = true



func _on_don_pressed() -> void:
	var this_hat = get_selected_hat()
	
	if !PlayerStats.hats.has(this_hat):
		PlayerStats.hats.append(this_hat)
	
	apply_preview()
	update_buttons()

func _on_doff_pressed() -> void:
	var this_hat = get_selected_hat()
	
	if PlayerStats.hats.has(this_hat):
		PlayerStats.hats.erase(this_hat)
	
	apply_preview()
	update_buttons()

func _on_egress_pressed() -> void:
	emit_signal("quit")
	PlayerStats.emit_signal("hats_changed", PlayerStats.hats)
	queue_free()
