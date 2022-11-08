extends Node2D

const asteroid = preload("res://Asteroid/Asteroid.tscn")

onready var size = get_viewport().size

onready var player = $Player
onready var fire_sound_player = $FireSoundPlayer
onready var kill_sound_player = $KillSoundPlayer
onready var boom_sound_player = $BoomSoundPlayer
onready var label_container = $LabelContainer

var asteroid_count = 0

func _ready():
	label_container.visible = false

	player.position = size / 2
	
	randomize()
	
	player.connect("kill", self, "kill_player")
	
	for _i in range(7):
		build_asteroid(true, true, null)

func _process(_delta):
	if asteroid_count == 0:
		label_container.visible = true
	
	if label_container.visible and Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func fire_sound():
	fire_sound_player.play()

func kill_player():
	kill_sound_player.play()
	label_container.visible = true
	player.queue_free()

func hit(asteroid_area, pos, large):
	boom_sound_player.play()
	if large:
		for _i in range(3):
			build_asteroid(false, false, pos)

	asteroid_count -= 1
	asteroid_area.queue_free()

func build_asteroid(large, random_position, fixed_position):
	var asteroid_instance = asteroid.instance()
	asteroid_count += 1
	add_child(asteroid_instance)
	if random_position:
		asteroid_instance.global_position = Vector2(size.x * randf(), size.y * randf())
	else:
		asteroid_instance.global_position = fixed_position
	asteroid_instance.change_size(large)
	asteroid_instance.connect("hit", self, "hit")
