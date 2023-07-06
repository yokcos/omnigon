extends HBoxContainer


export (int) var air_per_bubble = 1

const tex_full = preload("res://ui/air.png")

var target: Entity = null
var current_bubbles: int = 0


func _ready() -> void:
	update_air()

func _process(delta: float) -> void:
	if !is_instance_valid(target):
		target = Game.get_player()
	
	if current_bubbles != calculate_bubbles():
		update_air()


func calculate_bubbles() -> int:
	if is_instance_valid(target):
		if target.air >= target.max_air:
			return 0
		
		return int( target.air / float(air_per_bubble) )
	
	return 0

func update_air():
	clear_air()
	deploy_air()

func clear_air():
	for i in get_children():
		if i is TextureRect:
			i.queue_free()
	current_bubbles = 0

func deploy_air():
	if is_instance_valid(target):
		if target.air >= target.max_air:
			return false
		
		current_bubbles = calculate_bubbles()
		for i in range(current_bubbles):
			var new_rect = TextureRect.new()
			new_rect.rect_size = Vector2()
			new_rect.size_flags_vertical = 4
			new_rect.texture = tex_full
			
			add_child(new_rect)

