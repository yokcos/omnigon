extends TextureButton


export (String) var url = "http://yokcos.co.uk"
export (String) var title = "Yokcos' site"


func _pressed() -> void:
	OS.shell_open(url)
