class_name Meteor extends Area2D

signal exploded

@onready var sprite = $MeteorSprite

var movement_vector := Vector2(0, -1)
var speed := 200

func _ready():
	rotation = randf_range(0, 2*PI)


func _physics_process(delta):
	var screen_size = get_viewport_rect().size
	var radius := 100
	
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	if (global_position.y + radius) < 0:
		global_position.y = (screen_size.y + radius)
	elif (global_position.y - radius) > screen_size.y:
		global_position.y = -radius
	
	if (global_position.x + radius) < 0:
		global_position.x = (screen_size.x + radius)
	elif (global_position.x - radius) > screen_size.x:
		global_position.x = -radius


func explode():
	emit_signal("exploded")
	queue_free()


func _on_body_entered(body):
	if body is Player:
		body.die()
