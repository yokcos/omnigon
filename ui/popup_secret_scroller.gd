extends ScrollContainer


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		if get_v_scrollbar().visible:
			$all.margin_right = 256


