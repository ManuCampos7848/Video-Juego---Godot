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

func _on_Button_pressed():
	# Ocultar actual
	get_node("Sprite2D/Sombreros/Sombrero" + str(current_hat)).visible = false
	
	# Cambiar sombrero
	current_hat = (current_hat % total_sombreros) + 1
	print("Cambiando a sombrero: ", current_hat)
	
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
