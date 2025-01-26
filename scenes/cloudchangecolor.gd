extends Sprite2D

@export var cloudColor : Color

func _ready():
	self.modulate = cloudColor
