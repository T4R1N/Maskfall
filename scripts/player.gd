extends MFCharacter

#@export var birds: Array[BirdData]
@onready var ingame_ui: CanvasLayer = $"../IngameUI"
@onready var camera = $"../Set1/CameraRails"

@onready var animator: AnimationPlayer = $AnimationPlayer
var anim_flying = false

# HP/stats

# Gen movement
const SPEED = 10.0
var speed = SPEED # for use with both dash and regular movement
const JUMP_VELOCITY := 10.0
var ungrounded_time: float = 0.0
const jump_forgiveness: float = 0.5

# Gravity
const up_grav = 25.0
const down_grav = 45.0
var gravity = up_grav
const reg_max_fall = JUMP_VELOCITY * 1.5
var max_fall = reg_max_fall # MASKFALL reference?


#flight
var fly_velocity = 0.0
const MAX_FV = 8.0
var flight = false
var MAX_FS = 0.5
var fly_stamina = 0.0
var fly_max_fall = 5.0

#dash
const DASH_SPEED = 26.0
var dash = 0.0
const DASH_MAX = 0.2
var dash_cd = 0.0
const DASH_MAXCD = 1.0

#birds
@export var birds: Array[BirdData] = [null, null, null]
@export var obj_bird: PackedScene

#items/weapons
@export var temp_weapon: Array[Weapon] = [null, null]
# @export var item_inventory: Inventory
@export var cursor: Node3D

func receive_birds() -> void:
	pass

func take_damage(dmg: float, body) -> void:
	if not invulnerable:
		hp -= dmg
		ingame_ui.set_hp_bar()
		body.queue_free()

func _ready() -> void:
	pass

func die() -> void:
	get_tree().reload_current_scene()

func attack_with_weapon(weapon: Weapon) -> void:
	match weapon:
		RangedWeapon:
			fire_ranged_weapon(weapon)

func fire_ranged_weapon(weapon: Weapon) -> void:
	var target_pos = cursor.get_global_position()
	match weapon.type:
		"Gun":
			shoot_projectile(weapon.projectiles[0], cursor.get_global_position())
		"Shotgun":
			for p in range(weapon.num_proj):
				shoot_projectile(weapon.projectiles[0], target_pos)
	


func _input(event) -> void:
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or ungrounded_time < jump_forgiveness):
		animator.play("flap")
		velocity.y = JUMP_VELOCITY
		flight = false
		
	if Input.is_action_just_released("Jump") and not flight:
		fly_stamina = MAX_FS
		flight = true
	
	if Input.is_action_just_pressed("Interact1"):
		attack_with_weapon(temp_weapon[0])
	if Input.is_action_just_pressed("Interact2"):
		attack_with_weapon(temp_weapon[1])

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		ungrounded_time += delta
		if velocity.y > 0:
			# animator.play("up")
			gravity = up_grav
		else:
			animator.play("fall")
			anim_flying = false
			gravity = down_grav
		
		max_fall = reg_max_fall
		if Input.is_action_pressed("Jump"):
			max_fall = fly_max_fall
		
		
		if velocity.y > -max_fall:
			velocity.y -= gravity * delta
		else:
			velocity.y = -max_fall
	else:
		ungrounded_time = 0.0
		fly_stamina = 0.0
		anim_flying = false
		animator.play("idle")
	
		
	# Handle jump.
	
	if fly_stamina > 0.0 and Input.is_action_pressed("Jump"):
		if !anim_flying:
			animator.play("flap")
		anim_flying = true
		fly_velocity = lerp(fly_velocity,MAX_FV,0.2)
		velocity.y = fly_velocity
		fly_stamina -= delta
	else:
		max_fall = reg_max_fall
		fly_velocity = 0.0
		
		



	if dash_cd == 0.0 and Input.is_action_just_pressed("Dash"):
		dash = DASH_MAX
		
	if dash > 0.0:
		speed = DASH_SPEED
		dash -= delta
		dash_cd = DASH_MAXCD
		invulnerable = true
		camera.change_fov(dash)
	else:
		speed = SPEED
		invulnerable = false
		dash_cd = max(0.0,dash_cd-delta)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dash_dir = Input.get_vector("Left","Right","Down","Up")
	var direction = Input.get_axis("Left","Right")
	
	if dash > 0.0 and dash_dir:
		# print(dash_dir)
		velocity.y = dash_dir.y  * (speed*0.5)
		rotation.z = lerp(rotation.z, -(dash_dir.y * dash_dir.x), 0.25)
		$Sprite3D.rotate_y(0.45)
		$Accessories.rotate_y(0.45)
		
	else:
		rotation.z = lerp(rotation.z, 0.0, 0.25)
		$Sprite3D.rotation.y = 0
		$Accessories.rotation.y = 0
		
	
	if direction:
		velocity.x = lerp(velocity.x,direction * speed,0.4)
		if velocity.x > 0:
			look_direction(false)
		elif velocity.x < 0:
			look_direction(true)
		
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0.0, speed)
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			
	#if Input.is_action_just_released("Jump") and velocity.y > 0:
	#	velocity.y = 1.0
	

	move_and_slide()




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flap" && anim_flying:
		animator.play("flap")
