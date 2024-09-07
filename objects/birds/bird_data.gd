extends Resource

class_name BirdData

# Metadata
@export_enum("Pigeon", "Dove", "Robin") var species: int
@export var name: String

# Bird object data
@export var speed: float

@export var sprite: Texture2D
@export var sprite_up_wing: Texture2D
@export var sprite_down_wing: Texture2D

# Player Data

@export var speed_boost: float = 0.0
@export var jump_boost: float = 0.0

@export var dash_boost: float = 0.0
@export var dash_cooldown: float = 0.0

@export var flight_boost: float = 0.0
@export var flight_stamina: float = 0.0
