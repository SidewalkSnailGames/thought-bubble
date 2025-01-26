extends Node2D

@onready var buttonPresser = $Buttonpress
@export var removeObject: Node2D
@export var buttonColor: Color
var buttonPressed = false

func _ready():
	buttonPresser.modulate = buttonColor

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") && !buttonPressed:
		removeObject.queue_free()
		buttonPresser.global_position.y += 5
		buttonPressed = true
