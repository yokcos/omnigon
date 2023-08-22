extends State


var awoke: bool = false
var triggered: bool = false


func _step(delta: float):
	._step(delta)
	
	if Game.gameholder:
		if awoke and Game.gameholder.count_popups() <= 0:
			set_state("idle")


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
