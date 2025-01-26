extends Area2D

@onready var camera = $"../Player/Camera2D"

func _ready():
	var area_size = $CollisionShape2D.shape.extents * 2
	
	camera.limit_left = $CollisionShape2D.global_position.x - area_size.x / 2
	camera.limit_top = $CollisionShape2D.global_position.y - area_size.y / 2
	camera.limit_right = $CollisionShape2D.global_position.x + area_size.x / 2
	camera.limit_bottom = $CollisionShape2D.global_position.y + area_size.y / 2
