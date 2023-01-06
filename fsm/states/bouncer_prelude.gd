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
		var has_id = PlayerStats.check_upgrade("fake_id")
		if !WorldSaver.load_data("monologue_performed"):
			WorldSaver.save_data("monologue_performed", true)
			triggered = true
			
			if has_id:
				Game.summon_popup("Sayeth The Bouncer", "I see you have a Fake ID. Bearing the name of my good friend Doctor Fakename, who works in a completely different part of the facility, and whose face I know very well. It is a face that looks nothing like yours.")
				Game.summon_popup("Sayeth The Bouncer", "Congratulations on changing your appearance so completely my friend! If you're up here then surely you are on Important Doctor Business, please hurry! we can chat later.")
			else:
				awoke = true
				Game.summon_popup("Sayeth The Bouncer", "Intruder. Your infiltration has begun and ended.")
				Game.summon_popup("Sayeth The Bouncer", "Foul Southerners. First you come to steal secrets of space travel, now you seek to steal secrets of time travel? Dishonourable and plebian. Get thee hence.")
		elif !has_id:
			awoke = true
