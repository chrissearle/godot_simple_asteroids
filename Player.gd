extends Area2D

const rotation_amount = 2

const bullet = preload("res://Bullet.tscn")

onready var tip = $Tip

signal kill

func _process(delta):
	
	var rotate_input = Input.get_axis("ui_left", "ui_right")
	
	rotation += rotation_amount * rotate_input * delta
	
	rotation = fmod(rotation, TAU)

	var acceleration = Input.get_action_strength("ui_up")
	
	if acceleration > 0:
		var y = -100 * cos(rotation)
		var x = 100 * sin(rotation)
		
		position += Vector2(x, y) * delta

	if Input.is_action_just_pressed("ui_select"):
		var bullet_instance = bullet.instance()
		bullet_instance.global_position = tip.global_position
		bullet_instance.set_direction(rotation)
		get_parent().add_child(bullet_instance)
		get_parent().fire_sound()


func _on_Player_area_entered(area):
	if area.is_in_group("Asteroid"):
		emit_signal("kill")
