extends Boss

func ai():
	var target_pos: Vector3 = player.get_global_position()

	if get_global_position().x > target_pos.x:
		look_direction(true)
	else:
		look_direction(false)
		
	var direction = global_position.direction_to(target_pos)
	if direction:
		if is_on_floor():
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, 0.01)
			velocity.y = lerp(velocity.y, direction.y * SPEED, 0.01)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	ai()
	move_and_slide()


func _on_attack_timer_timeout() -> void:
	var target_pos: Vector3 = player.get_global_position()
	shoot_projectile(projectile, target_pos)
