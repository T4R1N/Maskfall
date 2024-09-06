extends Area3D

@onready var curs = get_node("CursorCol")
@onready var viewport = get_viewport()
@onready var mouse_pos := viewport.get_mouse_position()
@onready var viewport_size := viewport.get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#curs.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# mouse_pos = viewport.get_mouse_position()
	# curs.transform.origin = Vector3(mouse_pos.x, mouse_pos.y, -10.0)
	# print(str(mouse_pos))
	# print(str(curs.transform.origin))
