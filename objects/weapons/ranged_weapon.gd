class_name RangedWeapon
extends Weapon

@export var projectiles: Array[PackedScene] = [null]
@export var num_proj: int = 1

@export var velocity: float = 0.0
@export var inaccuracy: float = 0.0

@export var magazine_size: int = 1
@export var ammo: int = magazine_size
@export var reload_time: float = 1.0
@export var reload_timer: NodePath

@export var automatic: bool = false

@export_enum("Pistol", "Shotgun", "Rifle", "Bazooka") var type: int


func reload() -> void:
	ammo = magazine_size
	can_attack = true

func attack() -> bool:
	if can_attack:
		ammo -= 1
		return true
	return false
