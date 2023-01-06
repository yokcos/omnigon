extends TextureButton


export (String) var url = "http://yokcos.co.uk"


func _pressed() -> void:
	OS.shell_open(url)
