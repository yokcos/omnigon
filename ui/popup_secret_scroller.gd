extends ScrollContainer


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		if randf()*1 < 1:
			var output = "["
			for i in $all.get_children():
				output += " %s " % i.rect_min_size.x
				output += "|"
			if output.ends_with("|"):
				output = output.substr(0, output.length() - 2)
				output += " "
			output += "]"
			print(output)
			print($all.rect_size.x)
			print(" %s <-> %s " % [$all.margin_left, $all.margin_right])
		if get_v_scrollbar().visible:
			$all.margin_right = 256


