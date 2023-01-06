extends State


export (String) var activation_state = ""


func activate():
	if active:
		set_state(activation_state)
		father.send_them()
