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

func obj_is_in_range(obj: Node3D, dist: float) -> bool:
	if get_global_position().distance_to(obj.get_global_position()) <= dist:
		return true
	return false

func shoot_projectile(which_projectile: PackedScene, where_to: Vector3, where_from: Vector3 = self.get_global_position(), dir_offset: Vector3 = Vector3.ZERO,
						xtra_velocity: float = 0.0, dmg: float = 1.0) -> void:
	var proj = which_projectile.instantiate()
	var direction = where_from.direction_to(where_to) # Will need to change for the gun object in the future
	direction += dir_offset
	
	
	
	$'../'.add_child(proj) 
	
	proj.global_position = where_from
	proj.velocity = (proj.spd + xtra_velocity) * direction
	proj.dmg = dmg

func attack_melee(which_mz: PackedScene, where_to: Vector3, where_from: Vector3 = self.get_global_position(), dmg: float = 0.0) -> void:
	var new_mz = which_mz.instantiate()
	new_mz.dmg = dmg
	add_child(new_mz)
	new_mz.global_position = where_from
	new_mz.look_at(where_to)

func look_direction(left: bool = false) -> void:
	$Sprite3D.flip_h = left
	$Accessories.transform.origin.x = switch_offset * float(left)
	var other = get_node("Accessories/OtherAccess")
	if other != null:
		other.transform.origin.x = -switch_offset * float(left)
		if left:
			other.scale.x = -1.0
		else:
			other.scale.x = 1.0

func die() -> void:
	queue_free()

func _process(delta: float) -> void:
	if hp <= 0.0:
		die()
