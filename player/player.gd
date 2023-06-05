extends Area2D

@export var rotation_max: = 3
@export var speed_max: = 200

@onready var tip: = $Tip
@onready var exhaust: = $Exhaust
@onready var engineSound: = $EngineSoundPlayer

const bullet_load: = preload("res://bullet/bullet.tscn")

func _process(delta: float) -> void:
	var rotate_input = Input.get_axis("ui_left", "ui_right")
	
	rotation += rotation_max * rotate_input * delta
	
	rotation = fmod(rotation, TAU)

	var acceleration = Input.get_action_strength("ui_up")
	
	if acceleration > 0:
		exhaust.emitting = true
		if engineSound.playing == false:
			engineSound.play()
			
		var direction = Vector2.from_angle(rotation - (PI/2))
		position += direction.normalized() * speed_max * delta
	else:
		engineSound.stop()
		exhaust.emitting = false
	
	if Input.is_action_just_pressed("ui_select"):
		add_bullet()
		AudioManager.play("res://sounds/shoot.wav")
		ScoreTime.add(5)

func bullet_hit(area: Asteroid) -> void:
	AudioManager.play("res://sounds/boom.wav")
	get_parent().hit(area)

func add_bullet() -> void:
	var bullet = bullet_load.instantiate()
	bullet.global_position = tip.global_position
	bullet.set_direction(rotation)
	get_parent().add_child(bullet)
	bullet.hit.connect(bullet_hit)
	
