@tool
extends MarginContainer

enum Type {
	BLUE,
	GRAY,
	GREEN,
}

#hash map for color values
var color_map = {
	Type.BLUE: [Color(57.0/255.0, 161.0/255.0, 249.0/255.0), Color(1, 1, 1)],
	Type.GRAY: [Color(203.0/255.0, 202.0/255.0, 197.0/255.0), Color(0, 0, 0)],
	Type.GREEN: [Color(42.0/255.0, 189.0/255.0, 72.0/255.0), Color(1, 1, 1)],
}

@onready var msg = $msgBox
@onready var msgLabel = $MarginContainer/Label

@export var msgText : String = "Hello! This is a message!"
@export var msgType : Type

var collision_shape_2d: CollisionShape2D

var flag = 1

func _ready():
	#Text label
	msgLabel.text = msgText
	
	#Text color
	msgLabel.add_theme_color_override("font_color", color_map[msgType][1])
	
	#Box color
	msg.modulate = color_map[msgType][0]
	

func _process(delta):
	if Engine.is_editor_hint():
		_size_collision_shape()
	else:
		if flag == 1:
			_size_collision_shape()
			flag = 2


func _physics_process(delta):
	pass
	#if Engine.is_editor_hint():
	
	
func _size_collision_shape():	
	collision_shape_2d = $StaticBody2D/CollisionShape2D
	collision_shape_2d.shape = RectangleShape2D.new()
	
	collision_shape_2d.shape.size.x = $MarginContainer.size.x
	collision_shape_2d.shape.size.y = $MarginContainer.size.y
	#
	collision_shape_2d.position.x = $MarginContainer.size.x / 2
	collision_shape_2d.position.y = $MarginContainer.size.y / 2
