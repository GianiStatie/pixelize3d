extends MenuButton

@onready var load_model_file_dialog = $LoadModelFileDialog
signal model_load_triggered(path)

func _ready():
	var popup = get_popup() 
	popup.connect("id_pressed", file_menu)

func file_menu(id):
	match id:
		0:
			load_model_file_dialog.show()
		1:
			print("open")
		2:
			print("save")
		3:
			get_tree().quit()

func _on_load_model_file_dialog_file_selected(path):
	emit_signal("model_load_triggered", path)
