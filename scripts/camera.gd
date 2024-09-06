extends Camera3D

# @onready var player = get_node("../../Player")
@onready var cursor_3d = get_node("Cursor")

var BASE_FOV = fov

var export_collider = null

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_length = 30
	var ray_from = project_ray_origin(mouse_pos)
	var ray_to = ray_from + project_ray_normal(mouse_pos) * ray_length
	
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.set_collision_mask(pow(2, 4-1)) #+ pow(2, 2-1) + pow(2, 3-1)) # Makes the ray check for collisions in layer 1, 2, & 3
	ray_query.from = ray_from
	ray_query.to = ray_to
	
	var raycast_result = space.intersect_ray(ray_query)
	var collider = raycast_result.get("collider")
	
	export_collider = null # This will make it so that nothing is exported except for gombs and resources
	if !raycast_result.is_empty():
		var rr_pos = raycast_result["position"]
		rr_pos = Vector3(rr_pos.x, rr_pos.y, 0.0)
		cursor_3d.set_global_position(rr_pos)
		
		#if collider.is_in_group("Enemy"):
		#	cursor_3d.set_global_position(collider.get_global_position())
		#	export_collider = collider

func change_fov(data: float) -> void:
	fov = lerp(fov,BASE_FOV + data*20.0,0.4)

func _process(delta: float) -> void:
	#var target_pos: Vector3 = player.get_global_position()
	shoot_ray()
	#transform.origin = lerp(transform.origin, Vector3(target_pos.x, 6.099 - ((6.099 - target_pos.y)/4), 10.232), 0.215)
