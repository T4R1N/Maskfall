class_name HeldItem
extends Node3D

@export var object_to_look_at: Node3D

func change_sprite(texture: Texture2D):
	$Sprite3D.texture = texture

func set_looker(obj: Node3D):
	object_to_look_at = obj

func _physics_process(delta: float) -> void:
	if object_to_look_at != null:
		look_at(object_to_look_at.get_global_position(), Vector3(0, 1, 0), false)
