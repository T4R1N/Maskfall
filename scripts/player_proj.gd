class_name PlayerProjectile
extends Projectile

func interact() -> void:
	for body in proj_zone.get_overlapping_bodies():
		if body.is_in_group("Obstacles"):
			queue_free()
		elif body.is_in_group("Player"):
			body.take_damage(dmg, self)

func _physics_process(delta: float) -> void:
	interact()
	do_irrelevance_cleanup()
	move_and_slide()
