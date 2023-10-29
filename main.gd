extends Control

@export var fps: int = 16
@export var frames_per_row: int = 10

@onready var viewport = $"Mount/MainWindow/HSplitContainer/VSplitContainer/TabContainer/2DPlayer/PlayerCanvas/SubViewport"
@onready var animation_player: AnimationPlayer = $"Mount/MainWindow/HSplitContainer/VSplitContainer/TabContainer/2DPlayer/PlayerCanvas/SubViewport/Player/AnimationPlayer"

var frame_width: int
var frame_height: int




func get_all_animation_frames():
	var img_buffer = []
	for anim in animation_player.get_animation_list():
		animation_player.assigned_animation = anim
		img_buffer.append_array(await capture_current_animation())
	var img = concatenate_images(img_buffer)
	return img

func capture_current_animation():
	var image_buffer = []
	var step = 0.1 / fps
	var animation_length = animation_player.current_animation_length
	var position = 0
	
	while position < animation_length:
		animation_player.seek(position, true)
		await RenderingServer.frame_post_draw
		image_buffer.append(capture_viewport())
		position += step
	
	return image_buffer

func concatenate_images(buffer):
	var nb_of_rows = ceil(len(buffer) / float(frames_per_row))
	var concat_img = Image.create(frame_width * frames_per_row, frame_height * nb_of_rows, false, Image.FORMAT_RGBA8)
	
	var img_idx: int
	for row_idx in range(nb_of_rows):
		for col_idx in range(frames_per_row):
			img_idx = col_idx + row_idx * frames_per_row
			if img_idx > len(buffer) - 1: break
			var src_rect = Rect2i(Vector2.ZERO, Vector2(frame_width, frame_height))
			var dst = Vector2i(col_idx*frame_width, row_idx*frame_height)
			concat_img.blit_rect(buffer[img_idx], src_rect, dst)
	return concat_img

func capture_viewport():
	var img = viewport.get_texture().get_image()
	img.convert(Image.FORMAT_RGBA8)
	return img


func _on_background_shader_toggled(button_pressed):
	var color_rect_node =$"Mount/MainWindow/HSplitContainer/VSplitContainer/TabContainer/2DPlayer/PlayerCanvas/SubViewport/ColorRect"
	
	if not button_pressed:
		color_rect_node.show()
	else:
		color_rect_node.hide()




func _on_run_annimation_button_down():
	var frame_size = viewport.size
	frame_width = frame_size.x
	frame_height = frame_size.y
	
	var img: Image
	img = await get_all_animation_frames()
	img.save_png('test.png')
