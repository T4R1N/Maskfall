extends CharacterBody3D


const SPEED = 11.0
const JUMP_VELOCITY = 15.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 25.0


@onready var player = get_node("../Player")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif abs(velocity.x) <= 1.5:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var target_pos: Vector3 = player.get_global_position()
	
	var direction = global_position.direction_to(target_pos)
	if direction:
		if is_on_floor():
			velocity.x = direction.x * SPEED
			# velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, 0.01)
			# velocity.z = lerp(velocity.z, direction.z * SPEED, 0.001)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
