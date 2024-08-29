class_name Projectile
extends CharacterBody3D

@export var dmg: float = 1.0
@export var spd: float = 20.0

@onready var proj_zone: Area3D = $ProjZone

func interact() -> void:
	for body in proj_zone.get_overlapping_bodies():
		if body.is_in_group("Obstacles"):
			queue_free()
		elif body.is_in_group("Player"):
			body.take_damage(dmg)
			queue_free()

func _physics_process(delta: float) -> void:
	interact()
	
	move_and_slide()
