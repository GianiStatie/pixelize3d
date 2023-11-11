extends Control

@export var player_canvas_path: NodePath
@export var file_button_path: NodePath

@export var position_ui_path: NodePath
@export var rotation_ui_path: NodePath
@export var scale_ui_path: NodePath

var player_canvas: SubViewportContainer
var file_button: MenuButton

var position_ui: HBoxContainer
var rotation_ui: HBoxContainer
var scale_ui: HBoxContainer

var player_node: Node3D
var color_shader: ColorRect
var player_transform: Node3D


func _ready():
	player_canvas = get_node(player_canvas_path)
	file_button = get_node(file_button_path)
	position_ui = get_node(position_ui_path)
	rotation_ui = get_node(rotation_ui_path)
	scale_ui = get_node(scale_ui_path)
	
	color_shader = player_canvas.get_node("Viewport/ColorShader")
	player_node = player_canvas.get_node("Viewport/Player")
	file_button.connect("model_load_triggered", _on_model_load_triggered)
	
	player_transform = player_canvas.get_node("Viewport/Player")
	
	var c = Callable(self,"file_drop_path")
	get_tree().get_root().connect('files_dropped',c)
	
	update_player_transform()


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

	update_player_transform()


func update_player_transform():
	player_transform = player_canvas.get_node("Viewport/Player")
	position_ui.transform = player_transform.position
	rotation_ui.transform = player_transform.rotation_degrees
	scale_ui.transform = player_transform.scale

func file_drop_path(files):
	_on_model_load_triggered(files[0])


func _on_position_transform_changed(_transform):
	player_transform.position=_transform


func _on_rotation_transform_changed(_transform):
	player_transform.rotation_degrees=_transform


func _on_scale_transform_changed(_transform):
	player_transform.scale=_transform
