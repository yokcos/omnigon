extends Node


var active: bool = false


func _ready() -> void:
	initialise()

func _process(delta: float) -> void:
	if active:
		Steam.run_callbacks()


func initialise():
	if Engine.has_singleton("Steam"):
		var dict = Steam.steamInit()
		if dict["status"] != 1:
			print(dict)
		else:
			print("Connected well")
			Steam.connect("current_stats_received", self, "_on_stats_received")
			Steam.connect("user_stats_received", self, "_on_stats_received")
			active = true
	else:
		print("No steam")

func save_data(where: String, what: PoolByteArray):
	if active and false:
		Steam.fileWriteAsync(where, what)


func _on_stats_received(game: int, result: int, user: int):
	if OS.is_debug_build():
		print("Game: %s, result: %s, user: %s" % [game, result, user])
