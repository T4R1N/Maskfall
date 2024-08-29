extends Node

@export var stage_1: PackedScene
@export var menu: PackedScene

var current_room: PackedScene
@onready var current_scene: Node = $CurrentScene

func _ready():
	go_to_room("Home")


func go_to_room(room: String) -> void:
	match room:
		"Stage1":
			current_room = stage_1
		"Home":
			current_room = menu
	
	$TransitionScreen.transition()
	
func connect_signals() -> void:
	match current_room:
		menu:
			current_scene.get_node("Menu").begin.connect(_on_menu_begin)
	
func make_scene() -> void:
	if current_scene.get_children().size() == 1:
		current_scene.get_child(0).queue_free()
		current_scene.add_child(current_room.instantiate())
	else:
		current_scene.add_child(current_room.instantiate())

func _on_menu_begin():
	go_to_room("Stage1")
	

func _on_transition_screen_transitioned():
	make_scene()
	connect_signals()
