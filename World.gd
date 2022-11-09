extends Node2D

const asteroid = preload("res://Asteroid/Asteroid.tscn")

onready var size = get_viewport().size

onready var player: = $Player
onready var fire_sound_player: = $FireSoundPlayer
onready var kill_sound_player: = $KillSoundPlayer
onready var boom_sound_player: = $BoomSoundPlayer
onready var restart_label: = $RestartLabel
onready var time_display: = $TimeDisplay
onready var final_time_label: = $FinalTime

var asteroid_count = 0
var time_elapsed := 0.0

export var start_count = 7
export var break_count = 3

func _ready():
	restart_label.visible = false
	final_time_label.visible = false

	player.position = size / 2
	
	randomize()
	
	player.connect("kill", self, "kill_player")
	
	for _i in range(start_count):
		build_asteroid(true, true, null)
	
	time_elapsed = 0.0

func _process(delta):
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var milliseconds = fmod(time_elapsed, 1) * 100
	
	if asteroid_count == 0:
		restart_label.visible = true
		final_time_label.visible = true
		player.visible = false
		final_time_label.text = "Time %02d:%02d:%02d" % [minutes, seconds, milliseconds]
	
	if not restart_label.visible:
		time_elapsed += delta
	
	time_display.set_time(minutes, seconds, milliseconds)
	
	if restart_label.visible and Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func bullet_fired():
	time_elapsed += 5
	fire_sound_player.play()

func kill_player():
	kill_sound_player.play()
	restart_label.visible = true
	player.queue_free()

func hit(asteroid_area, pos, large):
	boom_sound_player.play()
	if large:
		for _i in range(break_count):
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
