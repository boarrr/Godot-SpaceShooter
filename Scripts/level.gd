extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var meteors = $Meteors
@onready var hud = $UI/HUD
@onready var game_over = $UI/GameOver

@export var meteor_count := 25
@export var meteor_spawn_time := 1

var score := 0:
	set(value):
		score = value
		hud.score = score

var meteor_scene = preload("res://Scenes/meteor.tscn")
var spawn_wait = false

func _ready():
	game_over.visible = false 
	score = 0
	player.connect("laser_shoot", _on_player_laser_shoot)
	player.connect("died", _on_player_died)


func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	while (meteors.get_child_count() < meteor_count) and spawn_wait == false:
		spawn_meteor()
		spawn_wait = true
		await get_tree().create_timer(meteor_spawn_time).timeout
		spawn_wait = false


func spawn_meteor():
	var meteor = meteor_scene.instantiate()
	meteor.global_position = Vector2(randf_range(100, 1800), -100)
	meteor.connect("exploded", _on_meteor_explode)
	meteors.add_child(meteor)


func _on_player_laser_shoot(laser):
	$LaserShoot.play()
	lasers.add_child(laser)


func _on_player_died():
	game_over.visible = true


func _on_meteor_explode():
	$MeteorDie.play()
	score += 1
