class_name Meteor extends Area2D

signal exploded

var movement_vector := Vector2(0, -1)

@onready var sprite = $MeteorSprite

var speed := 200

func _ready():
	rotation = randf_range(0, 2*PI)
	pass
	

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var screen_size = get_viewport_rect().size
	var radius := 100
	
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
