extends MenuButton

@onready var renderscene = $"../../../VSplitContainer/PanelContainer/Renderscene"

func _ready():
	var popup = get_popup() 
	popup.connect("id_pressed", file_menu)


func file_menu(id):
	match id:
		0:
			renderscene.state = 'one'
			$Label.text  = 'Seperate Animations'
		1:
			renderscene.state = 'all'
			$Label.text = "All as a Spritesheet"
		2:
			renderscene.state = 'eight'
			$Label.text = "Eight directions"
		3:
			get_tree().quit()
