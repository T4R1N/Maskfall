extends MFCharacter

#@export var birds: Array[BirdData]
@onready var ingame_ui: CanvasLayer = $"../IngameUI"
@onready var camera = get_node("../Camera3D")

@onready var animator: AnimationPlayer = $AnimationPlayer
var anim_flying = false

# HP/stats
var elegance := 0.0
var ele_grade: int = 0

# Gen movement
var SPEED = 10.0
var speed = SPEED # for use with both dash and regular movement
var JUMP_VELOCITY := 10.0
var ungrounded_time: float = 0.0
const jump_forgiveness: float = 0.5

# Gravity
const up_grav = 25.0
const down_grav = 45.0
var gravity = up_grav
var reg_max_fall = JUMP_VELOCITY * 1.5
var max_fall = reg_max_fall # MASKFALL reference?


#flight
var fly_velocity = 0.0
var MAX_FV = 8.0
var flight = false
var MAX_FS = 0.5
var fly_stamina = 0.0
var fly_max_fall = 5.0

#dash
var DASH_SPEED = 26.0
var dash = 0.0
var DASH_MAX = 0.2
var dash_cd = 0.0
var DASH_MAXCD = 1.0

#birds
@export var birds: Array[BirdData] = [null, null, null]
@export var obj_bird: PackedScene

#items/weapons
@export var temp_weapon: Array[Weapon] = [null, null]
# @export var item_inventory: Inventory
@export var cursor: Node3D

var w1cdtimer: Timer
var w2cdtimer: Timer 
var w1rldtimer: Timer
var w2rldtimer: Timer 

@onready var held_items: Array[HeldItem] = [$Accessories/HeldItem1, $Accessories/HeldItem2]


func receive_birds() -> void:
	for bird in birds:
		if bird != null:
			MAX_HP += bird.hp_increase
			SPEED += bird.speed_boost
			JUMP_VELOCITY += bird.jump_boost
			DASH_SPEED += bird.dash_boost
			DASH_MAXCD -= bird.dash_cooldown
			MAX_FV += bird.flight_boost
			MAX_FS += bird.flight_stamina
			
			hp = MAX_HP
			reg_max_fall = MAX_FV * 1.5
			max_fall = reg_max_fall

func load_weapon_data() -> void:
	# Set node paths
	temp_weapon[0].cooldown_timer = ^"W1TimerCD" 
	temp_weapon[1].cooldown_timer = ^"W2TimerCD"
	
	# Store timers for each weapon's nodepath
	w1cdtimer = get_node(temp_weapon[0].cooldown_timer)
	w2cdtimer = get_node(temp_weapon[1].cooldown_timer)
	
	# Set the timers
	w1cdtimer.wait_time = temp_weapon[0].cooldown_time
	w2cdtimer.wait_time = temp_weapon[1].cooldown_time
	
	# Do the same for reload timers
	if temp_weapon[0] is RangedWeapon:
		temp_weapon[0].reload_timer = ^"W1TimerRLD"
		w1rldtimer = get_node(temp_weapon[0].reload_timer)
		w1rldtimer.wait_time = temp_weapon[0].reload_time
		
	
	if temp_weapon[1] is RangedWeapon:
		temp_weapon[1].reload_timer = ^"W2TimerRLD"
		w1rldtimer = get_node(temp_weapon[1].reload_timer)
		w1rldtimer.wait_time = temp_weapon[1].reload_time
	
func init_hold() -> void: # Called by camera object upon cursor init
	for h in range(held_items.size()):
		var item = held_items[h]
		item.set_looker(cursor)
		
		item.change_sprite(temp_weapon[h].texture)
		
		print(cursor)
	
func look_direction(left: bool = false) -> void:
	$Sprite3D.flip_h = left
	$Accessories.transform.origin.x = switch_offset * float(left)
	var other = get_node("Accessories/OtherAccess")
	if other != null:
		other.transform.origin.x = float(left) * -0.25
		if left:
			other.scale.x = -1
		else:
			other.scale.x = 1
			

func take_damage(dmg: float, body) -> void:
	if not invulnerable:
		hp -= dmg
		ingame_ui.set_hp_bar()
		body.queue_free()
	else:
		elegance += dmg

func _ready() -> void:
	randomize()
	receive_birds()
	load_weapon_data()
	init_hold()

func die() -> void:
	get_tree().reload_current_scene()

func start_cooldown(weapon: Weapon) -> void:
	var timer = get_node(weapon.cooldown_timer)
	
	weapon.can_attack = false
	timer.start()

func stop_cooldown(weapon: Weapon) -> void:
	var timer = get_node(weapon.cooldown_timer)
	timer.stop()

func start_reload(weapon: RangedWeapon) -> void:
	var timer = get_node(weapon.reload_timer)
	weapon.can_attack = false
	timer.start()

	
func attack_with_weapon(weapon: Weapon, which_id: int) -> void:
	if weapon.attack():
		start_cooldown(weapon)
		if weapon is RangedWeapon:
			fire_ranged_weapon(weapon, which_id)
			if weapon.ammo == 0:
				start_reload(weapon)
				stop_cooldown(weapon)
		elif weapon is MeleeWeapon:
			strike_melee_weapon(weapon, which_id)

func strike_melee_weapon(weapon: MeleeWeapon, which_id: int) -> void:
	var target_pos = cursor.get_global_position()
	
	attack_melee(weapon.melee_zone, target_pos, self.get_global_position(), weapon.dmg)
	held_items[which_id].animate_melee()
	
	

func fire_ranged_weapon(weapon: RangedWeapon, which_id: int) -> void:
	var target_pos = cursor.get_global_position()
	
	var spread_offset: Vector3
	var so_amount = weapon.inaccuracy
	var num = weapon.num_proj + randi_range(-weapon.num_proj_variation,weapon.num_proj_variation)
	for p in range(num):
		spread_offset = Vector3(randf_range(-so_amount, so_amount), randf_range(-so_amount, so_amount), 0.0)
		# print(spread_offset)
		shoot_projectile(weapon.projectiles[0], target_pos, held_items[which_id].get_global_position(), spread_offset, weapon.velocity, weapon.dmg)

	#match weapon.type:
		#0:
			#shoot_projectile(weapon.projectiles[0], target_pos, held_items[which_id], Vector3.ZERO, weapon.velocity, weapon.dmg)
		#1:
			#
		#2:
			#var spread_offset: Vector3
			#var so_amount = weapon.inaccuracy
			#for p in range(weapon.num_proj):
				#spread_offset = Vector3(randf_range(-so_amount, so_amount), randf_range(-so_amount, so_amount), 0.0)
				# print(spread_offset)
				#shoot_projectile(weapon.projectiles[0], target_pos, held_items[which_id], spread_offset, weapon.velocity, weapon.dmg)


func _input(event) -> void:
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or ungrounded_time < jump_forgiveness):
		animator.play("flap")
		velocity.y = JUMP_VELOCITY
		flight = false
		
	if Input.is_action_just_released("Jump") and not flight:
		fly_stamina = MAX_FS
		flight = true
	
	
func _process(delta: float) -> void:
	if hp <= 0.0:
		die()
	
	if temp_weapon[0].can_attack:
		if temp_weapon[0].automatic:
			if Input.is_action_pressed("Interact1"): #Hold
				# temp_weapon[1].can_attack = false
				attack_with_weapon(temp_weapon[0], 0)
		else:
			if Input.is_action_just_pressed("Interact1"): #Click
				attack_with_weapon(temp_weapon[0], 0)
	if temp_weapon[1].can_attack:
		if temp_weapon[1].automatic:
			if Input.is_action_pressed("Interact2"): #Hold
				# temp_weapon[0].can_attack = false
				attack_with_weapon(temp_weapon[1], 1)
		else:
			if Input.is_action_just_pressed("Interact2"): #Click
				attack_with_weapon(temp_weapon[1], 1)

func _physics_process(delta) -> void:
	# Add the gravity.
	velocity.z = 0.0
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


func _on_w_1_timer_cd_timeout() -> void:
	temp_weapon[0].can_attack = true


func _on_w_1_timer_rld_timeout() -> void:
	temp_weapon[0].reload()


func _on_w_2_timer_cd_timeout() -> void:
	temp_weapon[1].can_attack = true


func _on_w_2_timer_rld_timeout() -> void:
	temp_weapon[1].reload()
