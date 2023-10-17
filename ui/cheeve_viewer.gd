extends Control


var scroll_speed: float = 48
var scroll_target: float = 0
var max_scroll: float = 0

const obj_cheeve = preload("res://ui/cheeve_entry.tscn")


func _ready() -> void:
	call_deferred("deploy_cheeves")
	$animator.play("ingress")

func _process(delta: float) -> void:
	$scroller.scroll_vertical = lerp($scroller.scroll_vertical, scroll_target, delta*5)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
		scroll_target += scroll_speed
	if event.is_action_pressed("move_up"):
		scroll_target -= scroll_speed
	
	scroll_target = clamp( scroll_target, 0, max_scroll )


func calculate_max_scroll():
	max_scroll = $scroller/cheeves.rect_size.y - $scroller.rect_size.y
	max_scroll = max( max_scroll, 0 )

func deploy_cheeves():
	for i in Game.cheeves:
		var this_cheeve: Cheeve = Game.cheeves[i]
		var new_cheeve = obj_cheeve.instance()
		new_cheeve.cheeve = this_cheeve
		$scroller/cheeves.add_child(new_cheeve)
	
	call_deferred("calculate_max_scroll")

func die():
	$animator.play("egress")


func _on_egress_pressed() -> void:
	die()
