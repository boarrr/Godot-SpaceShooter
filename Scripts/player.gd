class_name Player extends CharacterBody2D

signal laser_shoot(laser)
signal died

@export var speed := 10.0
@export var max_speed := 500.0
@export var rotation_speed := 200.0
@export var fire_rate := 0.25

@onready var barrel = $Barrel

var laser_scene = preload("res://Scenes/laser.tscn")
var shoot_on_cd = false
var alive = true


func _process(delta):
	if Input.is_action_pressed("shoot") and !shoot_on_cd:
		shoot()


func _physics_process(delta):
	var input_vector := Vector2(0, Input.get_axis("up", "down"))
	var screen_size := get_viewport_rect().size

	velocity += input_vector.rotated(rotation) * speed
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	if Input.is_action_pressed("right"):
		rotate(deg_to_rad(rotation_speed * delta))
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide()
	
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0



func shoot():
	var laser = laser_scene.instantiate()
	shoot_on_cd = true
	
	laser.global_position = barrel.global_position
	laser.rotation = rotation
	
	emit_signal("laser_shoot", laser)
	
	await get_tree().create_timer(fire_rate).timeout
	
	shoot_on_cd = false


func die():
	if alive:
		alive = false
		emit_signal("died")
		queue_free()
