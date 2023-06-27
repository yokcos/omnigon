extends Interactable


export (Texture) var image = null
export (Array) var wares = []

const obj_vending_screen = preload("res://ui/vendor/vendor.tscn")


func _ready() -> void:
	connect("activated", self, "_on_activated")

func deploy_vending_screen():
	var new_vending_screen = obj_vending_screen.instance()
	new_vending_screen.wares = wares
	new_vending_screen.set_image(image)
	Game.deploy_ui_instance(new_vending_screen, Vector2())


func _on_activated() -> void:
	deploy_vending_screen()
