extends Node2D

const asteroid = preload("res://Asteroid.tscn")

onready var size = get_viewport().size

onready var player = $Player
onready var fire_sound_player = $FireSoundPlayer
onready var kill_sound_player = $KillSoundPlayer

func _ready():
	player.position = size / 2
	
	randomize()
	
	for i in range(7):
		var asteroid_instance = asteroid.instance()
		
		asteroid_instance.position = Vector2(size.x * randf(), size.y * randf())

		add_child(asteroid_instance)

func fire_sound():
	fire_sound_player.play()

func kill_player():
	kill_sound_player.play()
	player.queue_free()

func explode_sound():
	pass
