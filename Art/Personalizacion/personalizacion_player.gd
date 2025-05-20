extends Control

var total_sombreros = 8
var current_hat = 1
var available_hats = []  # Lista de sombreros disponibles para combinar

func _ready():
	current_hat = Global.sombrero_seleccionado
	update_available_hats()
	update_hat_display()
	$CombinarSombrero.disabled = false  # Siempre activo

func update_available_hats():
	# Creamos lista de sombreros disponibles (todos excepto el actual)
	available_hats = []
	for i in range(1, total_sombreros + 1):
		if i != current_hat:
			available_hats.append(i)
	
	# Si no hay sombrero combinado, reiniciamos el índice
	if not Global.esSombreroCombinado:
		Global.numeroSombreroCombinado = 0

func update_hat_display():
	# Ocultamos todos los sombreros primero
	for i in range(1, total_sombreros + 1):
		var hat_node = get_node_or_null("Sprite2D/Sombreros/Sombrero" + str(i))
		if hat_node:
			hat_node.visible = false
	
	# Mostramos el sombrero principal
	var main_hat = get_node_or_null("Sprite2D/Sombreros/Sombrero" + str(current_hat))
	if main_hat:
		main_hat.visible = true
	
	# Mostramos el sombrero combinado si existe
	if Global.esSombreroCombinado && Global.numeroSombreroCombinado > 0:
		var combined_hat = get_node_or_null("Sprite2D/Sombreros/Sombrero" + str(Global.numeroSombreroCombinado))
		if combined_hat:
			combined_hat.visible = true

func _on_BotonSiguienteSombrero_pressed():
	# Reiniciamos combinación al cambiar de sombrero principal
	Global.esSombreroCombinado = false
	Global.numeroSombreroCombinado = 0
	
	# Cambiamos al siguiente sombrero
	current_hat = (current_hat % total_sombreros) + 1
	Global.sombrero_seleccionado = current_hat
	update_available_hats()
	update_hat_display()
	Global.save_settings()

func _on_CombinarSombrero_pressed():
	if available_hats.size() == 0:
		return  # No hay sombreros para combinar
	
	if Global.esSombreroCombinado:
		# Buscamos el índice del sombrero actualmente combinado
		var current_index = available_hats.find(Global.numeroSombreroCombinado)
		
		# Calculamos el próximo sombrero a combinar
		var next_index = (current_index + 1) % available_hats.size()
		Global.numeroSombreroCombinado = available_hats[next_index]
		
		# Si volvemos al principio, desactivamos la combinación
		if next_index == 0:
			Global.esSombreroCombinado = false
			Global.numeroSombreroCombinado = 0
	else:
		# Activamos combinación con el primer sombrero disponible
		Global.esSombreroCombinado = true
		Global.numeroSombreroCombinado = available_hats[0]
	
	update_hat_display()
	Global.save_settings()

func _on_Iniciar_pressed():
	Global.save_settings()
	get_tree().change_scene_to_file("res://mundo.tscn")
