extends MFCharacter

@export var bird: BirdData
@onready var player = get_node("../Player")

var speed := 0.0
var time := 0.0

func load_bird_data() -> void:
	if bird != null:
		speed = bird.speed

func _ready():
	load_bird_data()

func _physics_process(delta: float) -> void:
	time += delta
	
	var og_target_pos = player.get_global_position()
	var target_pos = Vector3(og_target_pos.x - 3.0, og_target_pos.y + 4.0, og_target_pos.z)
	#self.global_position = lerp(self.global_position, target_pos, speed)
	if get_global_position().x > og_target_pos.x:
		look_direction(true)
	else:
		look_direction(false)
		
	var direction = global_position.direction_to(target_pos)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, 0.02)
		velocity.y = lerp(velocity.y, direction.y * speed, 0.02)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	transform.origin.y += calc_sin()
	
	move_and_slide()

func calc_sin() -> float:
	return deg_to_rad(sin(time * 2) * 1)
