extends Area2D

var direction = Vector2.ZERO
var moved = 0

func set_direction(rads):
	rotation = rads
	direction = Vector2.UP.rotated(rotation)

func _process(delta):
	moved += 1
	
	if moved > 240:
		queue_free()
	
	position += direction * delta * 200
	rotation += 10 * delta
	rotation = fmod(rotation, TAU)
