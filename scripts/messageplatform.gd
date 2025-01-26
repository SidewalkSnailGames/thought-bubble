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
@onready var msgTriangle = $Control/Messagetrianglething
var msgLabel

@export var msgText : String = "Hello! This is a message!"
@export var msgType : Type

var collision_shape_2d: CollisionShape2D
var prev_x = 1
var prev_y = 1

var flag = 1

func _ready():
	msgLabel = $MarginContainer/Label
	#Text label
	msgLabel.text = msgText
	
	#Text color
	msgLabel.add_theme_color_override("font_color", color_map[msgType][1])
	
	#Box color
	msg.modulate = color_map[msgType][0]
	msgTriangle.modulate = color_map[msgType][0]

func _process(delta):
	msgLabel = $MarginContainer/Label
	
	if Engine.is_editor_hint():
		#Text label
		msgLabel.text = msgText
		
		#Text color
		msgLabel.add_theme_color_override("font_color", color_map[msgType][1])
		
		#Box color
		msg.modulate = color_map[msgType][0]
		_size_collision_shape()
	else:
		if flag == 1:
			_size_collision_shape()
			flag = 2


func _physics_process(delta):
	pass
	#if Engine.is_editor_hint():
	
	
func _size_collision_shape():
	# is this a binary search problem??
	#msgLabel.custom_minimum_size = set_best_size()
	
	collision_shape_2d = $StaticBody2D/CollisionShape2D
	collision_shape_2d.shape = RectangleShape2D.new()
	
	collision_shape_2d.shape.size.x = $msgBox.size.x
	collision_shape_2d.shape.size.y = $msgBox.size.y
	#
	collision_shape_2d.position.x = $msgBox.size.x / 2
	collision_shape_2d.position.y = $msgBox.size.y / 2


func set_best_size():
	var max_iterations = 5
	msgLabel.size.x = 1
	prev_y = msgLabel.size.y
	
	var i = 0
	while i < max_iterations:
		if msgLabel.size.y > prev_y:
			# if too many rows, size up on x
			msgLabel.size.x *= 2
		elif msgLabel.size.y < prev_y:
			msgLabel.size.x /= 2
		else: # y == prev_y
			break
			
		prev_y = msgLabel.size.y
		i += 1
