extends Bullet

@export var sprites: Array[Texture2D] = [null, null]

func _ready() -> void:
	$Sprite3D.texture = sprites[randi_range(0,1)]
