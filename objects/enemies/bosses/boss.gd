class_name Boss
extends Enemy

@export var boss_ui: PackedScene

var ingame_ui: Control #

func _ready() -> void:
	var b = boss_ui.instantiate()
	add_child(b)
	b.set_label_text(name)

	ingame_ui = $BossUI

	health_comp.health_bar = ingame_ui.get_node("ProgressBar")


	
