class_name RangedWeapon
extends Weapon

@export var projectiles: Array[PackedScene] = [null]
@export var num_proj: int = 1

@export var velocity: float = 0.0
@export var inaccuracy: float = 0.0

@export var automatic: bool = false

@export_enum("Pistol", "Shotgun", "Rifle", "Bazooka") var type: int
