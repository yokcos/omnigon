extends WindowDialog


var anchor: Node2D = null
var max_distance: float = 96

export (bool) var centred = true


func _ready() -> void:
	connect("popup_hide", self, "_on_popup_hide")

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		if anchor:
			var dist = anchor.global_position.distance_squared_to( players[0].global_position )
			if dist > max_distance*max_distance:
				egress()
	else:
		queue_free()
	
	if centred and Game.gameholder:
		var scale: float = Game.gameholder.screen_scale
		rect_position = OS.window_size/2/scale - (rect_size/2)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		egress()


func egress():
	queue_free()


func _on_popup_hide() -> void:
	egress()
