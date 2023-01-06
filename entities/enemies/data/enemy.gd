tool
class_name EnemyData
extends Resource


export (String) var id = ""
export (String) var name = ""
export (String, MULTILINE) var desc = ""
export (String, MULTILINE) var lore = ""

export (SpriteFrames) var frames = null
export (Rect2) var sprite_rect = Rect2()

var empty_rect: Rect2 = Rect2()


func get_frame(age: float) -> Texture:
	var animation_name: String = "default"
	
	if frames and frames.has_animation(animation_name):
		var frame_count: int = frames.get_frame_count(animation_name)
		var animation_speed: float = frames.get_animation_speed(animation_name)
		var this_frame: int = int(animation_speed * age) % frame_count
		var tex: Texture = frames.get_frame(animation_name, this_frame)
		
		if sprite_rect == empty_rect:
			return tex
		else:
			var final_tex = ImageTexture.new()
			var full_data = tex.get_data()
			var final_data = Image.new()
			final_data.create(sprite_rect.size.x, sprite_rect.size.y, false, Image.FORMAT_RGBA8)
			final_data.blit_rect( full_data, sprite_rect, Vector2() )
			final_tex.create_from_image(final_data, 0)
			return final_tex
	
	return null
