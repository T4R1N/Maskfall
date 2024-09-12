class_name HeldItem
extends Node3D

@export var object_to_look_at: Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_sprite(texture: Texture2D):
	$Sprite3D.texture = texture

func set_looker(obj: Node3D):
	object_to_look_at = obj

func _physics_process(delta: float) -> void:
	if object_to_look_at != null:
		look_at(object_to_look_at.get_global_position(), Vector3(0, 1, 0), false)

func animate_melee() -> void:
	if bool(randi_range(0,1)):
		animation_player.play("spear_melee")
	else:
		animation_player.play("swing_melee")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play("RESET")
