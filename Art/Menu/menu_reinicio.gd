extends Control

# -----------------------------------------------------------
# Metodo que reinicia el nivel mundo #1
func _on_button_pressed():
	Global.vidas_persistentes = 5
	get_tree().change_scene_to_file("res://mundo.tscn")
# -----------------------------------------------------------
