class_name MeleeZone
extends Area3D

@export var exist_time: float = 0.2
@export var dmg: float
@export var group_to_damage: StringName = "Enemy"

@onready var death_timer: Timer = $DeathTimer

func set_range(range: float = 4.0):
	$CollisionShape3D.shape.size = Vector3(1, 1, range)
	$CollisionShape3D.transform.position.z = -(range * 0.3)

func interact() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group(group_to_damage):
			body.take_damage(dmg, self)
			queue_free()

func _ready() -> void:
	death_timer.wait_time = exist_time
	death_timer.start()

func _physics_process(delta: float) -> void:
	interact()

func _on_death_timer_timeout() -> void:
	queue_free()
