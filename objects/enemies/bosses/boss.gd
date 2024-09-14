class_name Boss
extends Enemy

@export var boss_ui: PackedScene

var ingame_ui: Control #

func take_damage(dmg: float, body) -> void:
	if not invulnerable:
		hp -= dmg
		ingame_ui.change_hp_bar(100.0 * (hp / MAX_HP))
		body.queue_free()

func _ready() -> void:
	set_hp()
	
	var b = boss_ui.instantiate()
	add_child(b)
	b.set_label_text(name)
	b.change_hp_bar(100.0 * (hp / MAX_HP))
	
	ingame_ui = $BossUI
	
