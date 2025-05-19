extends Control

var total_sombreros = 6
var current_hat = 1

func _ready():
	current_hat = Global.sombrero_seleccionado
	update_hat_display()

func update_hat_display():
	# Debug
	print("Actualizando visualización con sombrero: ", current_hat)
	
	for i in range(1, total_sombreros + 1):
		var hat_node = get_node_or_null("Sprite2D/Sombreros/Sombrero" + str(i))
		if hat_node:
			hat_node.visible = (i == current_hat)
			print("Sombrero", i, " visible: ", hat_node.visible)


func verificarDisponibilidad(current_hat):
	
	match current_hat:
		1: return true
		2: return true
		3: return true
		4: return true
		
func reiniciarSombreros():
	for i in range(1, total_sombreros + 1	):
		#print(get_node("Sombreros/Sombrero" + str(i)))
		var sombrero = get_node("Sprite2D/Sombreros/Sombrero" + str(i))
		sombrero.visible = false
	Global.esSombreroCombinado = false
	Global.numeroSombreroCombinado = 0
	
func _on_Button_pressed():
	
	reiniciarSombreros()
	
	# Ocultar actual
	get_node("Sprite2D/Sombreros/Sombrero" + str(current_hat)).visible = false
	
	# Cambiar sombrero
	current_hat = (current_hat % total_sombreros) + 1
	print("Cambiando a sombrero: ", current_hat)
	
	if verificarDisponibilidad(current_hat):
		print("carolo")
		$CombinarSombrero.disabled = false
	else:
		$CombinarSombrero.disabled = true
		
	# Mostrar nuevo
	get_node("Sprite2D/Sombreros/Sombrero" + str(current_hat)).visible = true
	
	# Actualizar Global
	Global.sombrero_seleccionado = current_hat
	Global.save_settings()

func _on_iniciar_pressed():
	# Guardar solo una vez
	Global.sombrero_seleccionado = current_hat
	var save_result = Global.save_settings()
	
	if save_result == OK:
		get_tree().change_scene_to_file("res://mundo.tscn")
	else:
		printerr("Error al guardar: ", save_result)
		# Muestra un mensaje de error al jugador si lo deseas


func _on_combinar_sombrero_pressed():

	match current_hat:
		
		1:
			get_node("Sprite2D/Sombreros/Sombrero2").visible = true
			Global.esSombreroCombinado = true
			Global.numeroSombreroCombinado = 2
		2:
			get_node("Sprite2D/Sombreros/Sombrero5").visible = true
			Global.esSombreroCombinado = true
			Global.numeroSombreroCombinado = 5
		3:
			get_node("Sprite2D/Sombreros/Sombrero7").visible = true
			Global.esSombreroCombinado = true
			Global.numeroSombreroCombinado = 7
		# 4 con el 5
		4:
			get_node("Sprite2D/Sombreros/Sombrero5").visible = true
			Global.esSombreroCombinado = true
			Global.numeroSombreroCombinado = 5
	
	# Guardar cambios después de combinar
	var save_result = Global.save_settings()
	if save_result != OK:
		printerr("Error al guardar sombrero combinado")
	pass # Replace with function body.
