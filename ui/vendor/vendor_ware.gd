extends Control


var ware: VendorWare = null setget set_ware
var selected: bool = false

const mat_normal   = preload("res://misc/unselected_panel.tres")
const mat_selected = preload("res://misc/selected_panel.tres"  )

signal purchased
signal too_poor


func _ready() -> void:
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		purchase()


func purchase():
	if ware.get_purchased():
		emit_signal("purchased")

func set_ware(what: VendorWare):
	ware = what
	
	$all/image.texture = ware.image
	$all/deets/name.text = ware.name
	$all/deets/desc.text = ware.description
	$all/deets/cost/number.text = str(ware.cost)
	
	ware.connect("too_poor", self, "_on_too_poor")

func get_selected():
	$bac.add_stylebox_override("panel", mat_selected)
	
	$tween.interpolate_property($bac, "margin_left",  $bac.margin_left , -8, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.interpolate_property($bac, "margin_right", $bac.margin_right,  8, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.start()
	
	selected = true

func get_deselected():
	$bac.add_stylebox_override("panel", mat_normal)
	
	$tween.interpolate_property($bac, "margin_left",  $bac.margin_left , 0, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.interpolate_property($bac, "margin_right", $bac.margin_right, 0, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.start()
	
	selected = false

func _on_focus_entered():
	#call_deferred("get_selected")
	pass

func _on_focus_exited():
	#call_deferred("get_deselected")
	pass

func _on_too_poor():
	emit_signal("too_poor")
