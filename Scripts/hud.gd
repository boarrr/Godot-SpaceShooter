extends Control

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)
		
@onready var fps_text = $FPS

func _process(delta):
	var fps = Engine.get_frames_per_second()
	fps_text.text = "FPS: " + str(fps)
	
