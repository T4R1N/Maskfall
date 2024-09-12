class_name Limb
extends Node3D

@export var sprite_texture: Texture2D

func set_sprite(texture: Texture2D):
	if texture != null:
		$Sprite3D.texture = texture
	
func _ready() -> void:
	set_sprite(sprite_texture)
