extends Node2D

@onready var final_time_label: = $FinalTime

func _process(_delta: float) -> void:
	final_time_label.text =  "Time %02d:%02d:%02d" % [ScoreTime.minutes(), ScoreTime.seconds(), ScoreTime.milliseconds()]
