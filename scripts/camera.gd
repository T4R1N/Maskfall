extends Camera3D

# @onready var player = get_node("../../Player")

var BASE_FOV = fov

func change_fov(data: float) -> void:
	fov = lerp(fov,BASE_FOV + data*20.0,0.4)

func _physics_process(delta: float) -> void:
	#var target_pos: Vector3 = player.get_global_position()
	pass
	#transform.origin = lerp(transform.origin, Vector3(target_pos.x, 6.099 - ((6.099 - target_pos.y)/4), 10.232), 0.215)
