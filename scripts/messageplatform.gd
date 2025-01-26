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

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
var prev_x = 1
var prev_y = 1

var _collision_shape_dirty = 1

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
		if _collision_shape_dirty == 1:
			_size_collision_shape()
			_collision_shape_dirty = 0


func _physics_process(delta):
	pass
	#if Engine.is_editor_hint():
	
	
func _size_collision_shape():
	if not Engine.is_editor_hint():
		print('testtt')
	
	collision_shape_2d = $StaticBody2D/CollisionShape2D
	collision_shape_2d.shape = RectangleShape2D.new()
	
	collision_shape_2d.shape.size.x = $msgBox.size.x
	collision_shape_2d.shape.size.y = $msgBox.size.y
	#
	collision_shape_2d.position.x = $msgBox.size.x / 2
	collision_shape_2d.position.y = $msgBox.size.y / 2


func set_collision_shape_dirty_flag():
	'''
	This is the beginning of a long chain of hasty and nasty workarounds...
	Essentially, we set the collision shape dirty flag to 1, but we have to
	wait until it does become 1, so we manually create a 0.01 sec timer for
	this function to wait until we return, which will be helpful for when we
	want to get the updated size of the chat bubble after we fill in James'
	choices.
	'''
	set_deferred("_collision_shape_dirty", 1)
	await get_tree().create_timer(0.01).timeout
	print(_collision_shape_dirty)
	
func set_enabled(value: bool):
	set_deferred("visible", value) # set visible value to enabled value
	collision_shape_2d.set_deferred("disabled", !value) # if enabled value == false, set disabled to true
