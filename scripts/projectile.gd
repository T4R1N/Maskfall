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
			body.take_damage(dmg, self)
			

func do_light_visibility() -> void:
	$Light.visible = false
	if abs(get_global_position().z) <= 2.0:
		$Light.visible = true

func do_irrelevance_cleanup() -> void:
	var pos = get_global_position()
	if abs(pos.z) > 17.0 or abs(pos.x) > 100.0 or abs(pos.y) > 100.0:
		queue_free()

func _physics_process(delta: float) -> void:
	interact()
	do_light_visibility()
	do_irrelevance_cleanup()
	move_and_slide()
