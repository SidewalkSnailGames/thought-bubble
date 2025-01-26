extends AnimatedSprite2D

@onready var player = $".."
@onready var animator = $"."
var falling = false

func _process(delta: float) -> void:
	if player.is_on_floor() && not falling:
		if player.velocity.x != 0:
			animator.play("run-loop")
		else:
			animator.play("idle-loop")
	elif player.is_on_floor() && falling:
		falling = false
		animator.play("landing")
	else:
		if player.velocity.y > 0 &&  animator.animation != "jump":
			falling = true
			animator.play("fall-loop")
