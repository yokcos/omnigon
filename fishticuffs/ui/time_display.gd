extends Control


var target: Node = null


func _process(delta: float) -> void:
	if is_instance_valid(target):
		var time = target.age
		
		var f_secs = floor( fmod(time, 60) )
		var f_mins = floor( time/60 )
		
		var secs = str(f_secs).pad_zeros(2)
		var mins = str(f_mins).pad_zeros(2)
		
		$label.text = "%s:%s" % [mins, secs]
