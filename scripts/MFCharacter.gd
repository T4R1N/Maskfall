class_name MFCharacter
extends CharacterBody3D

@export var switch_offset: float = 0.0

func shoot_projectile(which_projectile: PackedScene, where_to: Vector3) -> void:
	var proj = which_projectile.instantiate()
	var direction = global_position.direction_to(where_to) # Will need to change for the gun object in the future
	$'../'.add_child(proj) 
	
	proj.position = global_position
	proj.velocity = proj.spd * direction

func look_direction(left: bool = false) -> void:
	$Sprite3D.flip_h = left
	$Accessories.transform.origin.x = switch_offset * float(left)
