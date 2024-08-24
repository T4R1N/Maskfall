extends Camera3D

@onready var player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_pos: Vector3 = player.get_global_position()
	
	transform.origin = lerp(transform.origin, Vector3(target_pos.x, 6.099 - ((6.099 - target_pos.y)/4), 10.232), 0.15)
