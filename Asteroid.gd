extends Area2D

onready var large_sprite_a: = $LargeSpriteA
onready var large_sprite_b: = $LargeSpriteB
onready var small_sprite_a: = $SmallSpriteA
onready var small_sprite_b: = $SmallSpriteB

onready var large_collision_shape: = $LargeCollisionShape
onready var small_collision_shape: = $SmallCollisionShape

var current_sprite
var is_large = true

export var rotation_max = 3.0
export var speed_max = 100

var direction = Vector2.ZERO
var rotation_speed = 0

func _ready():
	randomize()
	
	rand_sprite()

	current_sprite.rotation = randf() * TAU
	
	direction = Vector2(build_direction(), build_direction())
	
	rotation_speed = (2 * rotation_max * randf()) - rotation_max

func rand_sprite():
	var choose_a = randi() % 2 == 0
	
	if is_large:
		small_collision_shape.disabled = true
		
		if choose_a:
			current_sprite = large_sprite_a
		else:
			current_sprite = large_sprite_b
	else:
		large_collision_shape.disabled = true
		
		if choose_a:
			current_sprite = small_sprite_a
		else:
			current_sprite = small_sprite_b
	
	current_sprite.visible = true
	
	for s in [small_sprite_a, small_sprite_b, large_sprite_a, large_sprite_b]:
		if not s == current_sprite:
			s.visible = false

func _process(delta):
	position += direction * delta
	current_sprite.rotation += rotation_speed * delta

func build_direction():
	return (1.0 - randf() * 2) * speed_max * (1.0 + randf())


func _on_Asteroid_area_entered(area):
	if area.is_in_group("Bullet"):
		area.queue_free()
		if is_large:
			is_large = false
			get_parent().explode_sound()
			rand_sprite()
		else:
			get_parent().explode_sound()
			queue_free()

