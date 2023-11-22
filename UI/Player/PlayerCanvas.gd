extends SubViewportContainer

var fps: int = 16
var frames_per_row: int = 10

@onready var after_viewport = $"../SubViewportContainer/after"
@onready var player_viewport = $Viewport

func get_all_animation_frames():
	var animation_player = player_viewport.find_child("AnimationPlayer")
	var img_buffer = []
	for anim in animation_player.get_animation_list():
		animation_player.assigned_animation = anim
		img_buffer.append_array(await capture_current_animation(animation_player))
	var img = concatenate_images(img_buffer)
	return img

func capture_current_animation(animation_player):
	var image_buffer = []
	var step = 1.0/fps
	var animation_length = animation_player.current_animation_length
	var animation_position = 0
	
	while animation_position < animation_length:
		animation_player.seek(animation_position, true)
		await RenderingServer.frame_post_draw
		image_buffer.append(capture_viewport())
		animation_position += step
	
	return image_buffer

func concatenate_images(buffer):
	var frame_size = player_viewport.size
	var frame_width = frame_size.x
	var frame_height = frame_size.y
	
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
	var img = after_viewport.get_texture().get_image()
	img.convert(Image.FORMAT_RGBA8)
	return img
