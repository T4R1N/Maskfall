extends MFCharacter

@export var bird: BirdData
@onready var player = get_node("../Player")

var speed := 0.0
var time := 0.0

var id: int # will be used only for finding a home, probably.
var perch_destination: Vector3 = Vector3(0.0, 0.0, 0.0)

func load_bird_data() -> void:
	if bird != null:
		speed = bird.speed
		print(id)
		match id:
			0:
				perch_destination = Vector3(-3.0, 4.0, 0.0)
			1:
				perch_destination = Vector3(0.0, 5.0, 0.0)
			2:
				perch_destination = Vector3(3.0, 4.0, 0.0)

func _ready():
	load_bird_data()
	

func _physics_process(delta: float) -> void:
	time += delta
	
	var og_target_pos = player.get_global_position()
	var target_pos = og_target_pos + perch_destination
	#self.global_position = lerp(self.global_position, target_pos, speed)
	if velocity.x < 0:
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
