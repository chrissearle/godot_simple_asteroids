class_name Asteroid

extends Area2D


@onready var sprite: = $AsteroidSprite

var direction: = Vector2.ZERO
var rotation_speed: = 0.0
var rotation_max: = 3.0
var speed_max: = 100

var reg_x: = 0
var reg_y: = 0
var large = true

signal kill

func init(x: int, y: int, is_large: bool) -> void:
	large = is_large
	reg_x = x
	reg_y = y

func _ready() -> void:
	randomize()

	rotation = randf() * TAU
	
	direction = Vector2(build_random_direction(), build_random_direction())
	
	rotation_speed = (2 * rotation_max * randf()) - rotation_max

	sprite.region_rect.position.x = reg_x
	sprite.region_rect.position.y = reg_y

func _process(delta: float) -> void:
	position += direction * delta
	rotation += rotation_speed * delta

func build_random_direction() -> float:
	return (1.0 - randf() * 2) * speed_max * (1.0 + randf())

func _on_area_entered(_area: Area2D) -> void:
	kill.emit()
