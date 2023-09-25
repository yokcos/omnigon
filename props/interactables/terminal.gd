extends Node2D


export (Resource) var secret = null
export (Resource) var alternate_secret = null

var mode: int = 0


func _on_interactable_activated() -> void:
	var secrets = [secret, alternate_secret]
	var this_secret = secrets[mode]
	
	if this_secret:
		var new_popup = Game.summon_popup_secret(this_secret)
		if is_instance_valid(new_popup):
			new_popup.anchor = self
			PlayerStats.add_secret(this_secret.id)
	else:
		print("No secret exists in the terminal!")
		get_tree().quit()

func _on_shift() -> void:
	mode = 1 - mode
	$sprite.frame = mode
