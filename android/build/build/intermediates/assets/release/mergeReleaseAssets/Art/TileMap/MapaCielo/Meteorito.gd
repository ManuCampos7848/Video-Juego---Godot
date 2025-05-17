extends Area2D

@export var speed: float = 180
var direction := Vector2.DOWN

func _physics_process(delta):
	position += direction * speed * delta
	
	# Eliminar si sale de pantalla (versión mejorada)
	var viewport = get_viewport().get_visible_rect()
	if global_position.y > viewport.end.y + 100 or \
	   global_position.x < viewport.position.x - 100 or \
	   global_position.x > viewport.end.x + 100:
		queue_free()
