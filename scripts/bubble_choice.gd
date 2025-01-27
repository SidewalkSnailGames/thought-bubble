extends Area2D

@onready var level_choices: Node2D = $".."
@export var text: String = ""
@onready var label: Label = $Label
@export var moral: morality
static var choice

signal has_chosen

func _ready():
	label.text = text

enum morality{Good, 
			  Bad
			  }

#func disable(child):
	#child.monitoring = false
	#child.visible = false

func disable_children():
	for child in level_choices.get_children():
		print(child.name)
		child.set_deferred("monitoring", false)
		print(child.monitoring)
		child.set_deferred("visible", false)
		#child.visible = false

func _on_body_entered(body: Node2D) -> void:
	if moral == morality.Good:
		choice = "Good"
		print(choice)
		
	else:
		choice = "Bad"
		print(choice)
	
	disable_children()
	has_chosen.emit()
