extends Interactable


export (PackedScene) var popup = null


func summon_popup():
	var new_thing = popup.instance()
	Game.deploy_ui_instance(new_thing, Vector2())
	get_tree().paused = true
	
	PlayerStats.check_pos = Rooms.get_world_position(global_position)
	PlayerStats.hp = PlayerStats.max_hp
	
	var player = Game.get_player()
	if player:
		player.disconnect("sitting_complete", self, "summon_popup")

func activate():
	.activate()
	
	var player = Game.get_player()
	if player:
		player.connect("sitting_complete", self, "summon_popup")
		player.sit_at_art(self)
	
	WorldSaver.unsave_beings()
