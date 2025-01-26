extends Area2D

signal player_entered
signal player_exited

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_entered")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_exited")
