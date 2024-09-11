class_name MeleeWeapon
extends Weapon

# I will have to look up how to do combo chaining. For now, a simple script shall do.

@export_enum("Sword", "Spear") var type: int = 0

@export var melee_zone: PackedScene

@export var special_projectile: PackedScene
