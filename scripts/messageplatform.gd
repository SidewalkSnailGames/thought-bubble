extends MarginContainer

enum Type {
	BLUE,
	GRAY,
	GREEN,
}
var msg
@export var msgText : Label
@export var msgType : Type

func _ready():
	msg = $msgBox
	msg.modulate = Color (0.48, 0.72, 0.99)
	msgText.add_theme_color_override("font_color", Color(1, 1, 1))
