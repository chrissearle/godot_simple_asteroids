extends Node2D

const asteroid_load = preload("res://asteroid/asteroid.tscn")

# Regions
const asteroids = [
	[0, 192], [0, 256], [128, 192], [128, 256]
]
const small_asteroids = [
	[64, 192], [64, 256], [192, 192], [192, 256]
]

@export var start_count = 7

@onready var screen_size: Vector2i = get_viewport().size

@onready var player: = $Player
@onready var time_display: = $TimeDisplay
@onready var restart_display: = $RestartDisplay

var asteroid_count: = 0
var break_count: = 3

var alive: = true

func _ready() -> void:
	restart_display.visible = false
	
	player.position = screen_size / 2

	for _i in range(start_count):
		build_asteroid(true)
	
	ScoreTime.reset()

func _process(delta: float) -> void:
	if (asteroid_count <= 0 or not alive):
		restart_display.visible = true

		if Input.is_action_pressed("ui_accept"):
			get_tree().reload_current_scene()
	else:
		ScoreTime.add(delta)

func kill_player():
	AudioManager.play("res://sounds/die.wav")
	player.queue_free()
	alive = false

func hit(area: Asteroid):
	var large = area.large
	var pos = area.global_position
	
	asteroid_count -= 1
	area.queue_free()

	if large:
		for _i in range(break_count):
			call_deferred("build_asteroid", false, pos)
	
	if asteroid_count <= 0:
		player.queue_free()

func build_asteroid(large: bool, fixed_position = Vector2.ZERO ) -> void:
	var coords: = [0, 0]

	if large:
		coords = asteroids.pick_random()
	else:
		coords = small_asteroids.pick_random()

	var asteroid = asteroid_load.instantiate()
	
	asteroid.init(coords[0], coords[1], large)
	
	asteroid_count += 1
	
	add_child(asteroid)
	
	var pos = fixed_position
	
	if pos == Vector2.ZERO:
		pos = Vector2(screen_size.x * randf(), screen_size.y * randf())
	
	asteroid.global_position = pos
	asteroid.kill.connect(kill_player)
