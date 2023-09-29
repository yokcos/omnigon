extends Node2D


var colours: Array = [Color("fa6a0a"), Color("df3e23")]
var current_colour_index: int = 0
var polygon_expansion_speed: float = 100
var egress_duration: float = .8

const obj_auto_sprite = preload("res://pieces/auto_sprite.tscn")


func _ready() -> void:
	for i in range(8):
		pre_deploy_polygon(7, polygon_expansion_speed*(7-i))
	
	GlobalSound.play_music("ingressment")
	
	$secret_count.text = "Secrets stolen: %s" % PlayerStats.secrets.size()

func _process(delta: float) -> void:
	expand_polyga(delta)
	expand_hats(delta)
	
	if randf()*50 < 1:
		deploy_hat()
	
	$bac/hats.rotation += .5 * delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		begin_egress()
	if event.is_action_pressed("attack"):
		begin_egress()
	if event.is_action_pressed("shift"):
		begin_egress()
	if event.is_action_pressed("jump"):
		begin_egress()


func begin_egress():
	$animator.stop()
	
	$tween.interpolate_property(
		$pbot, "scale", $pbot.scale, Vector2(20, 20),
		egress_duration, Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	$tween.interpolate_property(
		$pbot, "position", $pbot.position, Vector2(80, 624),
		egress_duration, Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	$tween.interpolate_property(
		$blackening, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1),
		egress_duration, Tween.TRANS_QUINT, Tween.EASE_IN
	)
	$tween.interpolate_callback(self, egress_duration, "egress")
	
	$tween.start()

func egress():
	Game.exit_game()

func expand_polyga(delta: float):
	for i in $bac/polyga.get_children():
		i.scale.x += polygon_expansion_speed*delta
		i.scale.y += polygon_expansion_speed*delta
		if i.scale.x >= 800:
			i.queue_free()

func deploy_polygon(sides: int):
	var new_polygon = Polygon2D.new()
	var points = PoolVector2Array()
	var dir: Vector2 = Vector2(1, 0).rotated(randf() * 2*PI)
	for i in range(sides):
		var this_angle: float = float(i)/float(sides) * 2*PI
		points.append( dir.rotated(this_angle) )
	new_polygon.polygon = points
	new_polygon.color = colours[current_colour_index]
	$bac/polyga.add_child(new_polygon)
	
	current_colour_index += 1
	current_colour_index = posmod(current_colour_index, colours.size())
	
	return new_polygon

func expand_hats(delta: float):
	for i in $bac/hats.get_children():
		var this_hat = i as Sprite
		
		var relative_scale = 1 + 3*delta
		this_hat.position *= relative_scale
		this_hat.scale *= relative_scale
		
		if this_hat.position.length_squared() > 800*800:
			this_hat.queue_free()

func deploy_hat():
	if PlayerStats.available_hats.size() <= 0:
		return false
	
	var index = randi() % PlayerStats.available_hats.size()
	var this_hat: Hat = PlayerStats.available_hats[index]
	
	var new_sprite: Sprite = obj_auto_sprite.instance()
	new_sprite.texture = this_hat.large_sprite
	new_sprite.hframes = this_hat.large_frames
	
	$bac/hats.add_child(new_sprite)
	new_sprite.position = Vector2(1, 0).rotated(randf() * 2*PI)
	new_sprite.scale = Vector2(1, 1) * rand_range(.00625, .0125)
	new_sprite.rotation = randf() * 2*PI

func pre_deploy_polygon(sides: int, size: float):
	var new_polygon = deploy_polygon(sides)
	new_polygon.scale = Vector2(size, size)


func _on_polygon_timer_timeout() -> void:
	deploy_polygon(7)
