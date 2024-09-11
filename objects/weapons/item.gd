class_name Item
extends Resource

@export var texture: Texture2D
@export var name: String
@export var tooltip: String
@export_enum("Cheap", "Standard", "Unique", "Artisanal", "Masterpiece", "Monstrous") var rarity: int = 0
