class_name Enemy
extends MFCharacter

@export var projectile: PackedScene
@export var weapon: Weapon

@export var SPEED: float = 3.0
@export var JUMP_VELOCITY: float = 15.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 25.0


@onready var player = get_node("../Player")

@onready var held_item: HeldItem = $Accessories/HeldItem


func load_weapons() -> void:
	held_item.change_sprite(weapon.texture)
	held_item.object_to_look_at = player

func _ready() -> void:
	load_weapons()
	
func strike_melee_weapon(weapon: MeleeWeapon, which_id: int) -> void:
	var target_pos = player.get_global_position()
	
	attack_melee(weapon.melee_zone, target_pos, self.get_global_position(), weapon.dmg)
	weapon.animate_melee()

func look_direction(left: bool = false) -> void:
	$Sprite3D.flip_h = left
	$Accessories.transform.origin.x = switch_offset * float(left)
	var other = get_node("Accessories/OtherAccess")
	if other != null:
		#other.transform.origin.x = float(left) * -0.15
		if left:
			other.scale.x = -1
		else:
			other.scale.x = 1

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
