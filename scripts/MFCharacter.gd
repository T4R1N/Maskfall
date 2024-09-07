class_name MFCharacter
extends CharacterBody3D

@export var switch_offset: float = 0.0
@export var MAX_HP : float = 20.0

var hp := MAX_HP
var invulnerable := false

func take_damage(dmg: float, body) -> void:
	if not invulnerable:
		hp -= dmg
		body.queue_free()

func shoot_projectile(which_projectile: PackedScene, where_to: Vector3, dir_offset: Vector3 = Vector3.ZERO,
						xtra_velocity: float = 0.0, dmg: float = 1.0) -> void:
	var proj = which_projectile.instantiate()
	var direction = global_position.direction_to(where_to) # Will need to change for the gun object in the future
	print(direction)
	direction += dir_offset
	$'../'.add_child(proj) 
	
	proj.global_position = global_position
	proj.velocity = (proj.spd + xtra_velocity) * direction
	proj.dmg = dmg

func look_direction(left: bool = false) -> void:
	$Sprite3D.flip_h = left
	$Accessories.transform.origin.x = switch_offset * float(left)

func die() -> void:
	queue_free()

func _process(delta: float) -> void:
	if hp <= 0.0:
		die()
