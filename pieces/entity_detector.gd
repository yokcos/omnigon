extends Area2D


export (Array, int) var target_teams = [0]

var overlapping_entities = []


signal activated
signal deactivated
signal updated


func check():
	var count = count_entities()
	
	if count == 0:
		emit_signal("deactivated")
	else:
		for i in range(count):
			emit_signal("activated")

func count_entities():
	return overlapping_entities.size()


func _on_body_entered(body: Node) -> void:
	if !overlapping_entities.has(body) and body is Entity and target_teams.has(body.team):
		# Apply hat Bin Lid
		var exception: bool = false
		if PlayerStats.has_hat("binlid"):
			if body.team == 0:
				exception = true
		
		if !exception:
			if count_entities() <= 0:
				emit_signal("activated")
			overlapping_entities.append(body)
			emit_signal("updated", overlapping_entities)

func _on_body_exited(body: Node) -> void:
	if overlapping_entities.has(body):
		# Apply hat Bin Lid
		var exception: bool = false
		if PlayerStats.has_hat("binlid"):
			if body.team == 0:
				exception = true
		
		if !exception:
			if count_entities() <= 1:
				emit_signal("deactivated")
			overlapping_entities.erase(body)
			emit_signal("updated", overlapping_entities)
