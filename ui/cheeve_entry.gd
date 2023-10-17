extends Control


var cheeve: Cheeve = null setget set_cheeve

const pan_selected = preload("res://misc/selected_panel.tres")


func _ready() -> void:
	call_deferred("centre_pivots")


func centre_pivots():
	$bac.rect_pivot_offset = $bac.rect_size/2
	$all.rect_pivot_offset = $all.rect_size/2


func set_cheeve( what: Cheeve ):
	cheeve = what
	
	if PlayerStats.cheeves.has(what.id):
		$all/icon.texture = what.achieved_icon
		$animator.play("achieved")
		$bac.add_stylebox_override("panel", pan_selected)
	else:
		$all/icon.texture = what.unachieved_icon
		$animator.play("unachieved")
		if what.secret:
			hide()
	$all/deets/title.text = what.name
	$all/deets/description.text = what.description
