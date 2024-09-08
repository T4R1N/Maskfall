extends Node3D

@export var bird_object: PackedScene

@onready var player = get_node("Player")

func _ready() -> void:
	make_birds()

func make_birds() -> void:
	for i in range(player.birds.size()): # No enumeration in GDScript? Hello?
		var bird: BirdData = player.birds[i]
		if bird != null:
			var b = bird_object.instantiate()
			b.bird = bird # Insert the player's bird data into this bird.
			b.id = i
			add_child(b)
			b.position = player.global_position
			
	
