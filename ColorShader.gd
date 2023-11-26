extends ColorRect


@export var mono : ShaderMaterial
@export var no_palette : ShaderMaterial
@export var palette : ShaderMaterial
@export var normal : ShaderMaterial

func _ready():
	var c = Callable(self,"change_texture")
	get_tree().get_root().connect('files_dropped',c)

func change_texture(files):
	var path = files[0] as String
	if path.ends_with(".png"):
		palette.set_shader_parameter("palette",load_external_tex(path))

func load_external_tex(path):
	var tex_file = FileAccess.open(path, FileAccess.READ)
	var bytes = tex_file.get_buffer(tex_file.get_length())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.create_from_image(img)
	tex_file.close()
	return imgtex
