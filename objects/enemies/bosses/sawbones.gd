extends Boss

var time := 0.0

func ai():
	var target_pos: Vector3 = player.get_global_position()

	if get_global_position().x > target_pos.x:
		look_direction(true)
	else:
		look_direction(false)
		
	var direction = global_position.direction_to(target_pos)
	if direction:
		velocity.z = calc_cos()
		
		if is_on_floor():
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, 0.01)
			velocity.y = lerp(velocity.y, direction.y * SPEED, 0.01)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	time += delta
	ai()
	move_and_slide()


func _on_attack_timer_timeout() -> void:
	var target_pos: Vector3 = player.get_global_position()
	shoot_projectile(projectile, target_pos)

func calc_sin() -> float:
	return deg_to_rad(sin(time * 2) * 1)
	
func calc_cos() -> float:
	return deg_to_rad(cos(time * 4) * 40)
