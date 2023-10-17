extends State


var awoke: bool = false
var triggered: bool = false

var interrupted: bool = false
var interruption_time: float = 4


func _step(delta: float):
	._step(delta)
	
	if Game.gameholder:
		if awoke and Game.gameholder.count_popups() <= 0:
			set_state(auto_proceed)
	
	if interrupted:
		interruption_time -= delta
		if interruption_time <= 0:
			Game.cull_popups()
			awoke = true


func activate():
	if active and !triggered:
		if !WorldSaver.load_data("monologue_performed"):
			WorldSaver.save_data("monologue_performed", true)
			
			triggered = true
			awoke = true
			
			Game.summon_popup("Sayeth Lord Moneybags", "And exactly who in tarnation are you?", "I'm Pbot!")
			Game.summon_popup("Sayeth Lord Moneybags", "Oh. then I have some humble pie to eat.")
			Game.summon_popup("Sayeth Lord Moneybags", "But first: You're intruding, and so you must be destroyed to death.")
		else:
			awoke = true


func _on_damage_taken(dmg: float) -> void:
	if active and triggered:
		interrupted = true
		Game.cull_popups()
		Game.summon_popup("Sayeth Lord Moneybags", "OI! You don't get to shoot me while I'm monologuing you charlatan, you knave!", "Oh, sorry")
