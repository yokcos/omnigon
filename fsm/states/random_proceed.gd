extends State


export (Array, String) var options = []
export (Array, float) var weights = []


func _ready() -> void:
	auto_proceed = ""
	randomize()

func _enter():
	._enter()
	roll()


func roll():
	if weights.size() == options.size():
		var total_weight = 0
		for this_weight in weights:
			total_weight += this_weight
		
		var result = randf() * total_weight
		
		for i in weights.size():
			result -= weights[i]
			if result <= 0:
				auto_proceed = options[i]
				break
	else:
		var index = randi() % options.size()
		auto_proceed = options[index]
