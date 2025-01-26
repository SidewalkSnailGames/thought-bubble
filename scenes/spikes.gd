extends Area2D

@onready var player = $Player
@export var respawn_point: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
#causes the player to be respawned on contact
func _on_body_entered(body: Node2D) -> void:
	#print("ded")
	if body.name == "Player":
		body.global_position = respawn_point.global_position
		#print(str(body.position.y) + " " + str(respawn_point.position.y))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
