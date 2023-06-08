extends Control


var quiz: Dictionary = {} setget set_quiz
var labels: Array = []
var texts: Array = []
var indices: Array = []
var selection: int = 0
var age: float = 0
onready var cursor_target: float = $all/sides/left/cursor.rect_global_position.y
onready var answer_list: VBoxContainer = $all/sides/list
onready var cursor: Control = $all/sides/left/cursor

const tag_normal = "[tornado radius=2 freq=1]"
const tag_selected = "[tornado radius=3 freq=2]"
const tag_end = "[/tornado]"
const mat_bar = preload("res://misc/bar_orange.tres")

signal selected


func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	age += delta
	cursor.rect_global_position.y = lerp(cursor.rect_global_position.y, cursor_target, delta*5)
	
	var player = Game.get_player()
	if is_instance_valid(Game.camera) and is_instance_valid(player):
		var centre = rect_global_position + rect_size/2
		var cam_shift_ratio: float = 0.8
		Game.camera.target_offset = (centre - Game.camera.global_position) * cam_shift_ratio
		var ratio = clamp( age/4, 0, 1 )
		var cam_movement: Vector2 = Game.camera.target_offset - Game.camera.offset
		Game.camera.offset += cam_movement * ratio

func _input(event: InputEvent) -> void:
	var prev_selection = selection
	
	if event.is_action_pressed("move_up"):
		selection = posmod(selection-1, labels.size())
	if event.is_action_pressed("move_down"):
		selection = posmod(selection+1, labels.size())
	
	if selection != prev_selection:
		for i in range( labels.size() ):
			var this_label: RichTextLabel = labels[i]
			if i == selection:
				selectify_option(i)
				cursor_target = this_label.rect_global_position.y + this_label.rect_size.y/2 - cursor.rect_size.y/2
			if i == prev_selection:
				deselectify_option(i)
	
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"):
		get_selected()


func selectify_option(which: int):
	var this_label: RichTextLabel = labels[which]
	this_label.bbcode_text = "%s%s%s" % [tag_selected, texts[which], tag_end]

func deselectify_option(which: int):
	var this_label: RichTextLabel = labels[which]
	this_label.bbcode_text = "%s%s%s" % [tag_normal, texts[which], tag_end]

func get_selected():
	emit_signal("selected", indices[selection])
	
	if is_instance_valid(Game.camera):
		Game.camera.target_offset = Vector2()

func clear_options():
	for i in answer_list.get_children():
		i.queue_free()

func set_quiz(what: Dictionary):
	quiz = what
	
	labels = []
	texts = []
	indices = []
	
	$all/title.bbcode_text = "%s%s%s" % [tag_normal, what["question"], tag_end]
	var answers: Array = what["answers"]
	var order: Array = range( answers.size() )
	order.shuffle()
	for i in range( order.size() ):
		var j = order[i]
		indices.append(j)
		texts.append(answers[j])
		
		var new_label = RichTextLabel.new()
		new_label.fit_content_height = true
		new_label.rect_clip_content = false
		new_label.size_flags_vertical = SIZE_EXPAND_FILL
		new_label.bbcode_enabled = true
		new_label.bbcode_text = "%s%s%s" % [tag_normal, answers[j], tag_end]
		answer_list.add_child(new_label)
		labels.append(new_label)
		
		if i < order.size() - 1:
			var new_divider = HSeparator.new()
			answer_list.add_child(new_divider)
			new_divider.add_stylebox_override("separator", mat_bar)
	
	selectify_option(selection)
