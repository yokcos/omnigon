extends Control


var enemy: EnemyData = null setget set_enemy
var age: float = 0


func _process(delta: float) -> void:
	age += delta
	
	display_frame()

func display_frame():
	if enemy:
		$image.texture = enemy.get_frame(age)

func display_enemy(what: EnemyData):
	if what:
		$name.text = what.name


func set_enemy(what: EnemyData):
	enemy = what
	
	if what:
		display_enemy(what)


func get_selected() -> void:
	$bac.show()

func get_deselected() -> void:
	$bac.hide()
