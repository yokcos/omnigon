extends Control


var anchor: Node2D = null
var max_distance: float = 96

var scaling: float = 0 setget set_scaling
var animation_time = 0.2

var egressing = false


func _ready():
	set_scaling(0)
	$tween.interpolate_property(self, "scaling", 0, 1, animation_time, Tween.TRANS_BACK, Tween.EASE_OUT)
	$tween.interpolate_property($stuff/text, "percent_visible", 0, 1, animation_time*4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($stuff/title, "percent_visible", 0, 1, animation_time*2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()
	$stuff/egress.grab_focus()

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		if is_instance_valid(anchor):
			var dist = anchor.global_position.distance_squared_to( players[0].global_position )
			if dist > max_distance*max_distance:
				egress()
	else:
		queue_free()

func egress():
	if !egressing:
		$tween.interpolate_property(self, "scaling", 1, 0, animation_time, Tween.TRANS_BACK, Tween.EASE_IN)
		$tween.interpolate_property(self, "rect_rotation", 0, 7, animation_time, Tween.TRANS_BACK, Tween.EASE_IN)
		$tween.start()
		
		$timer.start(animation_time)
		
		egressing = true

func set_scaling(what: float):
	scaling = what
	
	$stuff.rect_scale = Vector2(scaling, scaling)
	var centre = rect_size/2
	$stuff.rect_position = centre - $stuff.rect_size*scaling/2

func set_title(what: String):
	$stuff/title.text = what

func set_text(what: String):
	$stuff/text.text = what

func set_egress(what: String):
	$stuff/egress.text = what


func _on_egress_pressed() -> void:
	egress()

func _on_timer_timeout() -> void:
	queue_free()
