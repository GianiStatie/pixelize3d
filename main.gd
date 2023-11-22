extends Control

var dir = ''
@export var player_canvas_path: NodePath
@export var file_button_path: NodePath

@export var position_ui_path: NodePath
@export var rotation_ui_path: NodePath
@export var scale_ui_path: NodePath


@onready var menu_button = $Mount/MarginContainer/MainWindow/HSplitContainer/PanelContainer/VBoxContainer/MenuButton

var player_canvas: Control
var file_button: MenuButton

var position_ui: HBoxContainer
var rotation_ui: HBoxContainer
var scale_ui: HBoxContainer

var player_node: Node3D
var color_shader: ColorRect
var player_transform: Node3D


signal path_update

func _ready():
	player_canvas = get_node(player_canvas_path)
	file_button = get_node(file_button_path)
	position_ui = get_node(position_ui_path)
	rotation_ui = get_node(rotation_ui_path)
	scale_ui = get_node(scale_ui_path)
	
	color_shader = player_canvas.find_child("ColorShader")
	player_node = player_canvas.find_child("Player")
	file_button.connect("model_load_triggered", _on_model_load_triggered)
	
	player_transform = player_canvas.find_child("Player")
	
	var c = Callable(self,"file_drop_path")
	get_tree().get_root().connect('files_dropped',c)
	update_player_transform(player_node)


func _on_background_shader_toggled(button_pressed):
	if not button_pressed:
		color_shader.hide()
	else:
		color_shader.show()


func _on_run_annimation_button_down():
	Render()

func Render():
	var arr : Array
	menu_button.file_menu(1)
	dir = await path_update
	dir += '/'
	arr = await player_canvas.get_all_animation_frames()
	print(arr.size())
	var anime_names = arr[1] as Array
	var images = arr[0] as Array
	for i in anime_names.size():
		var img: Image
		img = images[i]
		var path = dir + anime_names[i] + ".png"
		img.save_png(path)
func _on_model_load_triggered(path : String):
	if path.ends_with(".gltf") or path.ends_with(".glb"):
		var state = GLTFState.new()
		var importer = GLTFDocument.new()
		importer.append_from_file(path, state)
		var node = importer.generate_scene(state)
		
		node.transform = player_node.transform
		
		var node_parent = player_node.get_parent()
		player_node.queue_free()
		#await player_node.tree_exited
		
		node_parent.add_child(node)
		node.set_owner(node_parent)
		player_node = node
		player_node.name = "Player"
		update_player_transform(node)


func update_player_transform(node):
	player_transform = node as Node3D
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


func _on_file_dialog_dir_selected(dir):
	emit_signal('path_update',str(dir))
