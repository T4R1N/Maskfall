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

@onready var w_cooldown: Timer = $WCooldown
@onready var w_reload: Timer = $WReload

var attack_primed := false
var priming := false

func prime_attack() -> void:
	held_item.prime()
	priming = true

func do_weapon_cooldown() -> void:
	weapon.can_attack = false
	w_cooldown.start()

func do_weapon_logic(target_pos: Vector3) -> void:
	if weapon is RangedWeapon:
		shoot_ranged_weapon(target_pos)
	elif weapon is MeleeWeapon:
		strike_melee(target_pos)

func shoot_ranged_weapon(target_pos: Vector3) -> void:
	if weapon.attack():
		pass

func strike_melee(target_pos: Vector3) -> void:
	if weapon.attack() and obj_is_in_range(player, weapon.range + 1.0):
		if attack_primed:
			do_weapon_cooldown()
			attack_melee(weapon.melee_zone, target_pos, self.get_global_position(), weapon.dmg, "Player")
			held_item.animate_melee()
			attack_primed = false
			priming = false
		elif priming:
			pass
		else:
			prime_attack()
	#else:
		#attack_primed = false

func load_weapons() -> void:
	held_item.change_sprite(weapon.texture)
	held_item.object_to_look_at = player
	
	weapon.cooldown_timer = get_path_to(w_cooldown)
	w_cooldown.wait_time = weapon.cooldown_time
	
	if weapon is RangedWeapon:
		weapon.reload_timer = get_path_to(w_reload)
		w_reload.wait_time = weapon.reload_time

func _ready() -> void:
	load_weapons()
	

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
	
	strike_melee(target_pos)

func _physics_process(delta: float) -> void:
	standard_ai(delta)
	move_and_slide()


func _on_w_cooldown_timeout() -> void:
	weapon.can_attack = true


func _on_held_item_primed() -> void:
	attack_primed = true
