class_name CameraZone
extends Area3D


@onready var camera = get_node("../../../Camera3D")
@export_enum("Horizontal", "Vertical") var zone_type: int
# @export_flags("Left","Right","Up","Down") var keep_exit_locked: int
@export_group("Exit Locks")
@export var left: bool = false
@export var right: bool = false
@export var up: bool = false
@export var down: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#for body in get_overlapping_bodies():
		#if body.is_in_group("Player"):
			#camera.camera_lock(self)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		camera.camera_lock(self)
		


func _on_body_exited(body: Node3D) -> void:
	camera.camera_unlock()
	#var exit_side: String
	#if body.is_in_group("Player"):
		#if body.get_global_position().x < position.x:
			#if !left:
				#
	
