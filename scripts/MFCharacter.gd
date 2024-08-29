class_name MFCharacter
extends CharacterBody3D

@export var switch_offset: float = 0.0

func look_direction(left: bool = false) -> void:
	$Sprite3D.flip_h = left
	$Accessories.transform.origin.x = switch_offset * float(left)
