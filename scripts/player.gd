extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -650.0

var can_jump = true
@onready var animator = $AnimatedSprite2D
var jump_count = 0
var max_jump = 2

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jump and can_jump:
		animator.play("jump")
		velocity.y = JUMP_VELOCITY
		jump_count =+ 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animator.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func disable_jump():
	can_jump = false

func enable_jump():
	can_jump = true
