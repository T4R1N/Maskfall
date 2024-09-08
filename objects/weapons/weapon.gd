class_name Weapon
extends Item

@export var dmg: float = 0.0
@export var consumable: bool = false

@export_group("Usage Data")
@export var cooldown_time: float = 0.0
@export var can_attack: bool = true

@export var cooldown_timer: NodePath

func attack() -> bool:
	if can_attack:
		return true
	return false
