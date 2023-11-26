extends Control

@export var mono : Material
@export var no_palette : Material
@export var palette : Material

@export var player_path : NodePath
#var color_shader: ColorRect
@onready var color_shader = $"../../../VSplitContainer/PanelContainer/Renderscene/after_effect/after_viewport/ColorShader"
@onready var viewport = $"../../../VSplitContainer/PanelContainer/Renderscene/first_render/Viewport"

func _ready():
	var player_scene = get_node(player_path)

func _on_mono_chrome_button_up():
	color_shader.material = color_shader.mono
	viewport.debug_draw = 0


func _on_color_palette_button_up():
	color_shader.material = color_shader.palette
	viewport.debug_draw = 0


func _on_color_limit_button_up():
	color_shader.material = color_shader.no_palette
	viewport.debug_draw = 0


func _on_normal_render_button_up():
	color_shader.material = color_shader.normal
	viewport.debug_draw = 5
