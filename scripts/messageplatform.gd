@tool
extends MarginContainer

enum Type {
	BLUE,
	GRAY,
	GREEN,
}

#hash map for color values
var color_map = {
	Type.BLUE: [Color(0.48, 0.72, 0.99), Color(1, 1, 1)],
	Type.GRAY: [Color(0.8, 0.8, 0.8), Color(0, 0, 0)],
	Type.GREEN: [Color(0.0, 1, 0.0), Color(1, 1, 1)],
}

var msg
var msgLabel
@export var msgText : String = "Hello! This is a message!"
@export var msgType : Type


func _ready():
	#Declare variables
	msg = $msgBox
	msgLabel = $MarginContainer/Label
	
	#Box color
	msg.modulate = color_map[msgType][0]
	
	#Text color
	msgLabel.add_theme_color_override("font_color", color_map[msgType][1])


func _process(delta):
	msgLabel.text = msgText

	if Engine.is_editor_hint():
		print("running??")
		_size_collision_shape()
	

func _size_collision_shape():
	var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
	
	collision_shape_2d.shape.size.x = size.y
	collision_shape_2d.shape.size.y = size.x
	
	collision_shape_2d.position.x = size.x / 2
	collision_shape_2d.position.y = size.y / 2
