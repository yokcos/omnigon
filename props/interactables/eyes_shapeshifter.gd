extends Interactable


func activate():
	.activate()
	add_eyes()


func add_eyes():
	if PlayerStats.eyes == PlayerStats.EYES_NONE:
		PlayerStats.eyes = PlayerStats.EYES_SHAPESHIFTER
		var egress_string: String = "Horr[A]y!"
		var shift_string: String = Game.get_input_string("shift")
		if Game.get_input_string("shift") != "A":
			egress_string = "Horray!"
		Game.summon_popup(
			"Vital info",
			"Gadzooks! You have acquired the EYES OF THE SHAPESHIFTER! Press [%s] in order to use them to SHAPESHIFT!" % shift_string,
			egress_string,
			self
		)
	else:
		Game.summon_popup(
			"ERROR",
			"Unfortunately you lack the necessary EMPTY EYE SOCKETS to obtain these fresh new eyeballs.",
			"Oh no!",
			self
		)
