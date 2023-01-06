extends Label


export (NodePath) var fsm_path = ""
var fsm: StateMachine = null


func _ready() -> void:
	if has_node(fsm_path) and get_node(fsm_path) is StateMachine:
		fsm = get_node(fsm_path)
		fsm.connect("state_changed", self, "_on_state_changed")
		update_text()
	else:
		print_tree_pretty()
		print("State Revealer error: No FSM at %s" % fsm_path)
		queue_free()


func update_text():
	reveal_state(fsm.current_state)

func reveal_state(what: State):
	text = "Stt: %s" % what.name


func _on_state_changed(old_state: State, new_state: State):
	reveal_state(new_state)
