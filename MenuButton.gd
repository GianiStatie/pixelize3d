extends MenuButton

@onready var file_dialog = $FileDialog
signal model_load_triggered(path)

func _ready():
	var popup = get_popup() 
	popup.connect("id_pressed", file_menu)

func file_menu(id):
	match id:
		0:
			file_dialog.file_mode = 0
			file_dialog.add_filter('glb')
			file_dialog.add_filter('gltf')
			file_dialog.ok_button_text = 'Select 3D model'
			file_dialog.show()
		1:
			file_dialog.file_mode = 2
			file_dialog.clear_filters()
			file_dialog.ok_button_text = 'Select directory to save sprite sheets'
			file_dialog.show()
			print("open")
		2:
			print("save")
		3:
			get_tree().quit()


func get_dir():
	file_dialog.show()

func _on_load_model_file_dialog_file_selected(path):
	emit_signal("model_load_triggered", path)



