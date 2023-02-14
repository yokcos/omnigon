extends Node2D


export (Resource) var secret = null




func _on_interactable_activated() -> void:
	if secret:
		var new_popup = Game.summon_popup_secret(secret)
		new_popup.anchor = self
		PlayerStats.add_secret(secret.id)
	else:
		print("No secret exists in the terminal!")
		get_tree().quit()
