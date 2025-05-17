extends Node2D

# -----------------------------------------------------------
#  Atributos para colisiones y animaciones
@onready var player = $Finn
@onready var contadorVida = $ContadorVida/Vidas
@onready var elevador = $Elevador
# -----------------------------------------------------------

# -----------------------------------------------------------
# Variables para meteoritos
@export var meteorito_scene: PackedScene  # Asigna Meteorito.tscn en el inspector
@export var intervalo_meteoritos: float = 2.0  # Tiempo entre meteoritos (segundos)
var timer_meteoritos: Timer
# -----------------------------------------------------------

# -----------------------------------------------------------
# Persistencia de la vida
var vidas = Global.vidas_persistentes  # Usar el valor persistente
# -----------------------------------------------------------



# -----------------------------------------------------------
# Variables locales necesarias
var nubes_caidas = {}
var tween
var elevador_moviendose_abajo = true
var posicion_superior = 400
var posicion_inferior = 500
# -----------------------------------------------------------


# -----------------------------------------------------------
func _ready():
	tween  = create_tween()
	contadorVida.text = str(vidas)
	iniciar_movimiento_elevador()
	configurar_meteoritos()  # Inicializar generación de meteoritos
	#caerNube("hola", true)
	pass # Replace with function body.
# -----------------------------------------------------------

# -----------------------------------------------------------
# Configura el temporizador para generar meteoritos
func configurar_meteoritos():
	timer_meteoritos = Timer.new()
	add_child(timer_meteoritos)
	timer_meteoritos.wait_time = intervalo_meteoritos
	timer_meteoritos.timeout.connect(_generar_meteorito)
	timer_meteoritos.start()
# -----------------------------------------------------------

# -----------------------------------------------------------
# Genera un meteorito en posición aleatoria (dentro de la cámara visible)
func _generar_meteorito():
	if not meteorito_scene:
		return

	var meteorito = meteorito_scene.instantiate()
	add_child(meteorito)

	# Obtener la posición FUTURA del jugador (estimación)
	var player = get_node("Finn")
	var camera = get_viewport().get_camera_2d()
	
	if not player or not camera:
		meteorito.queue_free()
		return

	# Calcular posición de spawn considerando movimiento
	var viewport_size = get_viewport().size
	var player_velocity = player.velocity
	var spawn_distance_ahead = 1.5  # Segundos adelante (ajustable)
	
	# Posición futura estimada del jugador
	var future_player_pos = player.global_position + (player_velocity * spawn_distance_ahead)
	var camera_offset = future_player_pos - camera.get_screen_center_position()

	# Generar en el borde superior con margen
	var spawn_x = randf_range(
		future_player_pos.x - viewport_size.x/2 + 100,
		future_player_pos.x + viewport_size.x/2 - 100
	)
	var spawn_y = future_player_pos.y - viewport_size.y/2 - 100
	
	meteorito.global_position = Vector2(spawn_x, spawn_y)

	# Dirección hacia la posición futura estimada
	meteorito.direction = (future_player_pos - meteorito.global_position).normalized()
#print("Meteorito generado en posición de cámara: ", meteorito.position)
# -----------------------------------------------------------

# -----------------------------------------------------------
# Funcion para que la nube funcione como un elevador
func iniciar_movimiento_elevador():
	var target_position
	
	if elevador_moviendose_abajo:
		target_position = posicion_inferior
	else:
		target_position = posicion_superior
	var tween = create_tween()
	tween.tween_property(elevador, "position:y", target_position, 2.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_tween_completed)
# -----------------------------------------------------------




# -----------------------------------------------------------
# Funcion complementaria al elevador
func _on_tween_completed():
	# Cambiar la dirección cuando el tween termina
	elevador_moviendose_abajo = !elevador_moviendose_abajo
	iniciar_movimiento_elevador()
# -----------------------------------------------------------





# -----------------------------------------------------------
# Proces delta que mira la posicion del jugador para hacer caer las nubes
func _process(delta):
	#_generar_meteorito()
	# -----------------------------------------------------------
	# Actualizar la posición del jugador en cada frame
	var posicionPlayer = player.position
	# Teletransporte si el jugador pasa cierta posición
	if posicionPlayer.x >= 1965 and posicionPlayer.y >= 456:
			
		player.position = Vector2(1870, 397)
		# Obtener todas las nubes en el grupo "bloqueDesprendido"
	for nube in get_tree().get_nodes_in_group("bloqueDesprendido"):
		if nube.position.y > get_viewport_rect().size.y + 100:  # 100px de margen
			nube.queue_free()  # Elimina la nube si está muy abajo
		caerNube(nube, nube.position.x, posicionPlayer)
	# -----------------------------------------------------------
# -----------------------------------------------------------
		


# -----------------------------------------------------------
# Funcion para hacer caer las nubes cuando el jugador pase sobre ellas
func caerNube(nube, posicionNube, posicionPlayer):
	# Verificar si la nube ya cayó
	if nubes_caidas.get(nube, false):
		return  # Si ya cayó, no hacer nada

	# Si el jugador pasa la posición de la nube, hacerla caer
	if posicionPlayer.x >= posicionNube+10:
		var nuevaPos = nube.position.y + 100
		nubes_caidas[nube] = true  # Marcar la nube como caída

		var tween = get_tree().create_tween()
		tween.tween_property(nube, "position:y", nuevaPos, 0.5).set_trans(Tween.TRANS_LINEAR)
# -----------------------------------------------------------


# -----------------------------------------------------------
# Funcion game over del personaje 
func _on_finn_barrera_baja_pierde():
	if vidas <= 1:
		get_tree().change_scene_to_file("res://Art/Menu/menu_reinicio.tscn")
	else:
		vidas -= 1
		Global.vidas_persistentes = vidas  # Guardar el valor antes de recargar
		contadorVida.text = str(vidas)
		# Recargar la escena actual
		get_tree().reload_current_scene()
# -----------------------------------------------------------

