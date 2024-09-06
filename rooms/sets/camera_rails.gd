extends Path3D

@onready var player = get_node("../../Player")
@onready var cam_cart: PathFollow3D = $CamCart
@onready var camera_3d: Camera3D = $CamCart/Camera

@onready var BASE_FOV = camera_3d.fov

func change_fov(data: float) -> void:
	camera_3d.fov = lerp(camera_3d.fov,BASE_FOV + data*20.0,0.4)

func _physics_process(delta: float) -> void:
	#var target_pos: Vector3 = player.get_global_position()
	var to_progress = player.get_global_position().x - transform.origin.x
	cam_cart.progress = lerp(cam_cart.progress, to_progress, 0.215)
	#transform.origin = lerp(transform.origin, Vector3(target_pos.x, 6.099 - ((6.099 - target_pos.y)/4), 10.232), 0.215)
