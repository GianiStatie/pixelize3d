extends Control

@export var player_canvas_path: NodePath
@export var file_button_path: NodePath

var player_canvas: SubViewportContainer
var file_button: MenuButton

var player_node: Node3D
var color_shader: ColorRect

var player_transform: Node3D
var player_position: Node3D
var line_edit_node_rotation
var line_edit_node_position
var line_edit_node_scale

var scaleVector = Vector3()


func _ready():
	player_canvas = get_node(player_canvas_path)
	file_button = get_node(file_button_path)
	
	color_shader = player_canvas.get_node("Viewport/ColorShader")
	player_node = player_canvas.get_node("Viewport/Player")
	file_button.connect("model_load_triggered", _on_model_load_triggered)
	
	player_transform = player_canvas.get_node("Viewport/Player")
	player_position = player_canvas.get_node("Viewport/Player")
	

func _on_background_shader_toggled(button_pressed):
	if not button_pressed:
		color_shader.show()
	else:
		color_shader.hide()

func _on_run_annimation_button_down():
	var img: Image
	img = await player_canvas.get_all_animation_frames()
	img.save_png('test.png')

func _on_model_load_triggered(path):
	var state = GLTFState.new()
	var importer = GLTFDocument.new()
	importer.append_from_file(path, state)
	var node = importer.generate_scene(state)
	
	node.transform = player_node.transform
	
	var node_parent = player_node.get_parent()
	player_node.queue_free()
	await player_node.tree_exited
	
	node_parent.add_child(node)
	player_node = node
	player_node.name = "Player"




func _on_text_edit_x_text_changed():
	line_edit_node_rotation = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Rotation/LabelRotation/TextEditX
	var rotation_input = line_edit_node_rotation.text.to_float()
	player_transform.rotation_degrees.x = rotation_input

func _on_text_edit_y_text_changed():
	
	line_edit_node_rotation = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Rotation/LabelRotation/TextEditY
	var rotation_input = line_edit_node_rotation.text.to_float()
	player_transform.rotation_degrees.y = rotation_input


func _on_text_edit_z_text_changed():
	line_edit_node_rotation = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Rotation/LabelRotation/TextEditZ
	var rotation_input = line_edit_node_rotation.text.to_float()
	player_transform.rotation_degrees.z = rotation_input


func _on_scale_x_text_changed():
	line_edit_node_scale = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Scale/LabelScale/ScaleX
	var scale_input = line_edit_node_scale.text.to_float()
	player_transform.scale.x = scale_input
	scaleVector.x=scale_input


func _on_scale_y_text_changed():
	line_edit_node_scale = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Scale/LabelScale/ScaleY
	var scale_input = line_edit_node_scale.text.to_float()
	player_transform.scale.y = scale_input
	scaleVector.y=scale_input


func _on_scale_z_text_changed():
	line_edit_node_scale = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Scale/LabelScale/ScaleZ
	var scale_input = line_edit_node_scale.text.to_float()
	player_transform.scale.x = scale_input
	scaleVector.z = scale_input


func _on_position_x_text_changed():
	line_edit_node_position = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Position/LabelPosition/PositionX
	var position_input = line_edit_node_position.text.to_float()
	player_transform.position.x= position_input


func _on_position_y_text_changed():
	line_edit_node_position = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Position/LabelPosition/PositionY
	var position_input = line_edit_node_position.text.to_float()
	player_transform.position.y= position_input


func _on_position_z_text_changed():
	line_edit_node_position = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/Position/LabelPosition/PositionZ
	var position_input = line_edit_node_position.text.to_float()
	player_transform.position.z= position_input
