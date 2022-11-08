extends Node2D

const asteroid = preload("res://Asteroid.tscn")

onready var size = get_viewport().size

onready var player = $Player
onready var fire_sound_player = $FireSoundPlayer
onready var kill_sound_player = $KillSoundPlayer

var alive = true

func _ready():
	player.position = size / 2
	
	randomize()
	
	player.connect("kill", self, "kill_player")
	
	for i in range(7):
		build_asteroid(true, true, null)

func _process(delta):
	if not alive and Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func fire_sound():
	fire_sound_player.play()

func kill_player():
	kill_sound_player.play()
	alive = false
	player.queue_free()

func hit(asteroid_area, pos, large):
	# Play explode
	if large:
		for i in range(3):
			build_asteroid(false, false, pos)

	asteroid_area.queue_free()

func build_asteroid(large, random_position, fixed_position):
	var asteroid_instance = asteroid.instance()
	add_child(asteroid_instance)
	if random_position:
		asteroid_instance.global_position = Vector2(size.x * randf(), size.y * randf())
	else:
		asteroid_instance.global_position = fixed_position
	asteroid_instance.change_size(large)
	asteroid_instance.connect("hit", self, "hit")
