class_name Enemy
extends MFCharacter

@export var projectile: PackedScene

@export var SPEED: float = 3.0
@export var JUMP_VELOCITY: float = 15.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 25.0


@onready var player = get_node("../Player")





func shoot_projectile(which_projectile: PackedScene, where_to: Vector3) -> void:
	var proj = which_projectile.instantiate()
	var direction = global_position.direction_to(where_to) # Will need to change for the gun object in the future
	$'../'.add_child(proj) 
	
	proj.position = global_position
	proj.velocity = proj.spd * direction



func standard_ai(delta: float) -> void:
	var target_pos: Vector3 = player.get_global_position()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif abs(velocity.x) <= 1.5:
		velocity.y = JUMP_VELOCITY
		
	
	
	if get_global_position().x > target_pos.x:
		look_direction(true)
	else:
		look_direction(false)
		
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
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	standard_ai(delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	
	
	
		# velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
