extends Area2D


const bullet = preload("res://Player/Bullet.tscn")

onready var tip = $Tip
onready var exhaust = $Exhaust

signal kill

export var speed_max = 200
export var rotation_max = 3

func _ready():
	exhaust.emitting = false

func _process(delta):
	
	var rotate_input = Input.get_axis("ui_left", "ui_right")
	
	rotation += rotation_max * rotate_input * delta
	
	rotation = fmod(rotation, TAU)

	var acceleration = Input.get_action_strength("ui_up")
	
	if acceleration > 0:
		exhaust.emitting = true
		var y = -speed_max * cos(rotation)
		var x = speed_max * sin(rotation)
		
		position += Vector2(x, y) * delta
	else:
		exhaust.emitting = false


	if Input.is_action_just_pressed("ui_select"):
		var bullet_instance = bullet.instance()
		bullet_instance.global_position = tip.global_position
		bullet_instance.set_direction(rotation)
		get_parent().add_child(bullet_instance)
		get_parent().fire_sound()


func _on_Player_area_entered(area):
	if area.is_in_group("Asteroid"):
		emit_signal("kill")
