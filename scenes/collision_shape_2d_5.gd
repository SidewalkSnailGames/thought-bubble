extends CollisionShape2D

@onready var respawn_point = $"../../Respawn point"
@onready var player = $"../../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	#print("ded")
	if body.name == "Player":
		body.global_position = respawn_point.global_position
		#print(str(body.position.y) + " " + str(respawn_point.position.y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
