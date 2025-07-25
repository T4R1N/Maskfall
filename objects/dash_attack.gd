extends Area3D

@export var dmg: float = 15.0
@export var group_to_damage: StringName = "Enemy"
@export var safe_bodies: Array[Node3D]

func begin_attack() -> void:
	monitoring = true
	#$MeshInstance3D.visible = true

func end_attack() -> void:
	monitoring = false
	safe_bodies = []
	#$MeshInstance3D.visible = false

func interact() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group(group_to_damage) and not safe_bodies.has(body):
			body.health_comp.take_damage(dmg, self, false)
			safe_bodies.append(body)

func _physics_process(delta: float) -> void:
	if monitoring:
		interact()