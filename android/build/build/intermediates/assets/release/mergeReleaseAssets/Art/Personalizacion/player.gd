extends Node2D

@onready var body_sprite = $Body

func _ready():
	# Testeo automático al cargar
	test_color_changes()
	
func test_color_changes():
	# Lista de colores de prueba
	var test_colors = [
		Color(1, 0, 0),    # Rojo
		Color(0, 1, 0),    # Verde
		Color(0, 0, 1),    # Azul
		Color(1, 1, 0),    # Amarillo
		Color(0.8, 0.5, 0.3) # Color piel
	]
	
	# Cambia de color cada segundo
	for i in range(test_colors.size()):
		await get_tree().create_timer(1.0).timeout
		change_skin_color(test_colors[i])
	
	# Vuelve al original después
	await get_tree().create_timer(1.0).timeout
	change_skin_color(Color(1, 1, 1))

func change_skin_color(new_color: Color):
	var material = body_sprite.material as ShaderMaterial
	material.set_shader_parameter("skin_color", new_color)
	print("Color cambiado a: ", new_color)
