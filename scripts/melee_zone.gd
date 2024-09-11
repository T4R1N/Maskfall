class_name MeleeZone
extends Area3D

@export var exist_time: float = 0.2
@export var dmg: float

@onready var death_timer: Timer = $DeathTimer

func interact() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			body.take_damage(dmg, self)
			queue_free()

func _ready() -> void:
	death_timer.wait_time = exist_time
	death_timer.start()

func _physics_process(delta: float) -> void:
	interact()

func _on_death_timer_timeout() -> void:
	queue_free()
