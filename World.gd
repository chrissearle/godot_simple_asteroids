extends Node2D

const asteroids = [
	preload("res://Asteroid/Asteroid.tscn"),
	preload("res://Asteroid/Asteroid2.tscn"),
	preload("res://Asteroid/Asteroid3.tscn"),
	preload("res://Asteroid/Asteroid4.tscn")
]

const smallAsteroids = [
	preload("res://Asteroid/SmallAsteroid.tscn"),
	preload("res://Asteroid/SmallAsteroid2.tscn"),
	preload("res://Asteroid/SmallAsteroid3.tscn"),
	preload("res://Asteroid/SmallAsteroid4.tscn")
]

@export var start_count = 7

@onready var screen_size: Vector2i = get_viewport().size

@onready var player: = $Player
@onready var bulletSound: = $BulletSoundPlayer
@onready var killSound: = $KillSoundPlayer
@onready var hitSound: = $HitSoundPlayer
@onready var time_display: = $TimeDisplay
@onready var restart_label: = $RestartLabel
@onready var final_time_label: = $FinalTime

var asteroid_count: = 0
var break_count: = 3

var time_elapsed := 0.0

var alive: = true

func _ready() -> void:
	restart_label.visible = false
	final_time_label.visible = false
	
	player.position = screen_size / 2

	for _i in range(start_count):
		build_asteroid(true)
	
	time_elapsed = 0.0

func _process(delta: float) -> void:
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var milliseconds = fmod(time_elapsed, 1) * 100
	
	if (asteroid_count <= 0 or not alive):
		restart_label.visible = true
		final_time_label.visible = true
		final_time_label.text = "Time %02d:%02d:%02d" % [minutes, seconds, milliseconds]

		if Input.is_action_pressed("ui_accept"):
			get_tree().reload_current_scene()
	else:
		time_elapsed += delta
	
		time_display.set_time(minutes, seconds, milliseconds)


func kill_player():
	killSound.play()
	player.queue_free()
	alive = false

func bullet_fired() -> void:
	time_elapsed += 5
	bulletSound.play()

func hit(area: Asteroid):
	var large = area.large
	var pos = area.global_position
	
	asteroid_count -= 1
	hitSound.play()
	area.queue_free()

	if large:
		for _i in range(break_count):
			build_asteroid(false, pos)
	
	if asteroid_count <= 0:
		player.queue_free()

func build_asteroid(large: bool, fixed_position = Vector2.ZERO ) -> void:
	var asteroid_instance: Node

	if large:
		asteroid_instance = asteroids.pick_random().instantiate()
	else:
		asteroid_instance = smallAsteroids.pick_random().instantiate()

	asteroid_count += 1
	
	add_child(asteroid_instance)
	
	var pos = fixed_position
	
	if pos == Vector2.ZERO:
		pos = Vector2(screen_size.x * randf(), screen_size.y * randf())
	
	asteroid_instance.global_position = pos
	asteroid_instance.kill.connect(kill_player)
