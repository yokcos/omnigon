extends Node2D


var type = "vertices_collected"
var count: float = 0


func _ready() -> void:
	add_to_group("savers")
	
	var data = WorldSaver.load_data("savers")
	if data and data.has("vertices_collected"):
		count = data["vertices_collected"]
	
	PlayerStats.connect("vertices_collected", self, "_on_vertices_collected")


func _on_vertices_collected(quantity: float):
	count += quantity
