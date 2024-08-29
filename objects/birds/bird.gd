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
	
	var target_pos = player.get_global_position()
	target_pos = Vector3(target_pos.x - 3.0, target_pos.y + 4.0, target_pos.z)
	self.global_position = lerp(self.global_position, target_pos, speed)
	
	transform.origin.y += calc_sin()
	
	move_and_slide()

func calc_sin() -> float:
	return deg_to_rad(sin(time * 2) * 1)
