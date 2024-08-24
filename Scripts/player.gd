extends CharacterBody3D


const SPEED = 10.0
var speed = SPEED
const JUMP_VELOCITY = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
const up_grav = 25.0
const down_grav = 45.0
var gravity = up_grav

#flight
var fly_velocity = 0.0
const MAX_FV = 8.0
var flight = false
var MAX_FS = 1.0
var fly_stamina = 0.0

#dash
const DASH_SPEED = 20.0
var dash = 0.0
const DASH_MAX = 0.2
var dash_cd = 0.0
const DASH_MAXCD = 1.0

func _input(event):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		flight = false
		
	if Input.is_action_just_released("Jump") and not flight:
		fly_stamina = MAX_FS
		flight = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			gravity = up_grav
		else:
			gravity = down_grav
		velocity.y -= gravity * delta
	else:
		fly_stamina = 0.0

	# Handle jump.
	if fly_stamina > 0.0 and Input.is_action_pressed("Jump"):
		fly_velocity = lerp(fly_velocity,MAX_FV,0.2)
		velocity.y = fly_velocity
		fly_stamina -= delta
	else:
		fly_velocity = 0.0

	if dash_cd == 0.0 and Input.is_action_just_pressed("Dash"):
		dash = DASH_MAX
		
	if dash > 0.0:
		speed = DASH_SPEED
		dash -= delta
		dash_cd = DASH_MAXCD
	else:
		speed = SPEED
		dash_cd = max(0.0,dash_cd-delta)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dash_dir = Input.get_vector("Left","Right","Down","Up")
	var direction = Input.get_axis("Left","Right")
	
	if dash > 0.0 and dash_dir:
		velocity.y = dash_dir.y  * (speed*0.5)
	
	if direction:
		velocity.x = lerp(velocity.x,direction * speed,0.4)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0.0, speed)
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
		

	move_and_slide()
