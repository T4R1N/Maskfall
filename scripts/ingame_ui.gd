extends CanvasLayer

@onready var player = get_node("../Player")
@onready var hp_bar: ProgressBar = $Control/HPBar

func set_hp_bar() -> void:
	hp_bar.value = 100.0 * (player.hp / player.max_hp)

func _ready():
	set_hp_bar()
