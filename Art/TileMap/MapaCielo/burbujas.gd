extends Area2D

# Called when the node enters the scene tree for the first time.
# Arrancan las animaciones de las burbujas
func _ready():
	$AnimatedSprite2D.play("burbujas")
# ---------------------------------------------------------
