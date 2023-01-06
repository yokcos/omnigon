tool
extends Control


export (Resource) var enemy = null setget set_enemy

var age: float = 0


func _ready() -> void:
	display_enemy(enemy)

func _process(delta: float) -> void:
	age += delta
	
	apply_frame()

func apply_frame():
	if enemy:
		$bac/column/upper/sprite_holder/sprite.texture = enemy.get_frame(age)

func display_enemy(what: EnemyData):
	if what and is_inside_tree():
		$bac/column/upper/name.text = what.name
		$bac/column/desc.text = what.desc
		$bac/column/lore.text = what.lore
		$bac/column/stats.text = "%s killed" % PlayerStats.get_kills(what)

func appearify():
	$animator.stop()
	$animator.play("appear")


func set_enemy(what: Resource):
	if what is EnemyData:
		enemy = what
		display_enemy(what)
	else:
		enemy = null
		print("Enemy needs to be an EnemyData resource")
