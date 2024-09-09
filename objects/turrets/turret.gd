class_name Turret
extends MFCharacter

@onready var player = get_node("../Player")

@export var projectile: PackedScene


func _physics_process(delta: float) -> void:
	var target_pos: Vector3 = player.get_global_position()
	
	if obj_is_in_range(player, 20.0):
		$BarrelBase.look_at(target_pos)

func _on_attack_timer_timeout() -> void:
	$AttackTimer.start()
	var target_pos: Vector3 = player.get_global_position()
	if obj_is_in_range(player, 20.0):
		shoot_projectile(projectile, target_pos, $BarrelBase)
