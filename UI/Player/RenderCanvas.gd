extends Control

@export var fps: int = 16
var frames_per_row: int = 25
var state = 'one'

@onready var after_viewport = $after_effect/after_viewport
@onready var player_viewport = $first_render/Viewport

func get_all_animation_frames():
	var animation_names : Array
	var img_array : Array
	var collector_buffer : Array
	var player = $first_render/Viewport/Player as Node3D
	var old_player_transform = player.global_transform
	var animation_player = player_viewport.find_child("AnimationPlayer")
	var img_buffer = []
	for anim in animation_player.get_animation_list():
		animation_player.assigned_animation = anim
		if state == 'all':
			collector_buffer.append_array(await capture_current_animation(animation_player))
		if state == 'one':
			animation_names.append(anim)
			img_buffer.append(await capture_current_animation(animation_player))
		if state == 'eight':
			#render each direction as an array of images and then append it as an array within the image_buffer array
			var eight_buffer : Array
			animation_names.append(anim + "8")
			for i in 8:
				eight_buffer.append_array(await capture_current_animation(animation_player))
				animation_player.seek(0.0)
				player.rotation_degrees.y += 45.0
			img_buffer.append(eight_buffer)
			player.global_transform = old_player_transform
	if state == 'all':
		animation_names.append("All")
		img_buffer.append(collector_buffer)
	img_array = collect_images(img_buffer,animation_names.size())
	return [img_array, animation_names]

func collect_images(buffer : Array, size : int):
	var images : Array
	print(buffer.size())
	for i in size:
		images.append(concatenate_images(buffer[i]))
	return images


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
	var nb_of_rows = int(pow(len(buffer),0.5)) + 1
	frames_per_row = nb_of_rows
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

