class_name HealthComponent
extends Node

@export var max_health: int = 100
@export var invulnerable: bool = false
@onready var health := max_health
@export var health_bar: ProgressBar
@export var health_label: Label

signal death

func _ready() -> void:
    update_health_bar()
    connect("death", get_parent().die)

# Getters/Setters

func get_max_health() -> int:
    return max_health

func set_max_health(hp: int) -> void:
    max_health = hp
    health = max_health

func get_health() -> int:
    return health

func set_health(hp: int) -> void:
    health = min(max_health, hp)

func get_health_deficit() -> int:
    return max_health - health

# Common Functions

func heal(hp: int) -> void:
    if hp < 0:
        hp = 0
    health = min(get_max_health(), get_health() + hp)
    update_health_bar()
    # health_label.change_value(health, max_health)

func take_damage(dmg: int, body: Node3D, destroy: bool = true) -> void:
    if not invulnerable: # then actually take damage
        if dmg < 0:
            dmg = 0
        health = max(0, get_health() - dmg)
        update_health_bar()
        # health_label.change_value(health, max_health)
    
        if destroy:
            body.queue_free()
    
    print("My health " + str(get_health()))
    
    if get_health() == 0:
        die()

# Internal Functions

func update_health_bar() -> void:
    if health_bar != null:
        health_bar.max_value = get_max_health()
        health_bar.value = get_health()

func die() -> void:
    print("I am death 1")
    death.emit()