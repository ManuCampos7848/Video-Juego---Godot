extends CharacterBody2D

'''
# -----------------------------------------------
signal barreraBajaPierde
signal caer
# -----------------------------------------------

# -----------------------------------------------
const SPEED = 160.0
const JUMP_VELOCITY = -178.0
const EDGE_FORGIVENESS = 200  # Píxeles de margen para saltar desde bordes
# -----------------------------------------------

# -----------------------------------------------
# Gravedad
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# -----------------------------------------------

# -----------------------------------------------
func _ready():
	cargar_sombrero()
	# Configurar detector de bordes
	$FloorDetector.target_position = Vector2(0, EDGE_FORGIVENESS)
	$FloorDetector.enabled = true
# -----------------------------------------------

# -----------------------------------------------
# Funcion para cargar el sombrero seleccionado por el player
func cargar_sombrero():
	# Debug: Verificar valor cargado
	print("Cargando sombrero desde Global: ", Global.sombrero_seleccionado)
	
	# 1. Ocultar todos los sombreros
	for i in range(1, 9):  # Ajusta según tu total_sombreros
		var sombrero = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(i))
		if sombrero:
			sombrero.visible = false
			print("Ocultando sombrero ", i)
	
	# 2. Mostrar solo el seleccionado
	var sombrero_actual = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(Global.sombrero_seleccionado))
	if sombrero_actual:
		sombrero_actual.visible = true
		print("Mostrando sombrero ", Global.sombrero_seleccionado)
	else:
		printerr("Error: No se encontró Sombrero", Global.sombrero_seleccionado)
# -----------------------------------------------

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Sistema de salto con piso fantasma
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or $FloorDetector.is_colliding()):
		velocity.y = JUMP_VELOCITY

	# Movimiento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# Animaciones
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
		$Accesorios.scale.x = 1
	elif velocity.x < 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true
		$Accesorios.scale.x = -1

	move_and_slide()

	# Debug (opcional)
	print("En suelo:", is_on_floor(), " | Detectando borde:", $FloorDetector.is_colliding())

func _on_area_2d_body_entered(body):
	if body.name == "Perder":
		print("cayo")
		barreraBajaPierde.emit()
'''

# -----------------------------------------------
signal barreraBajaPierde
signal caer
# -----------------------------------------------


# -----------------------------------------------
const SPEED = 155.0
const JUMP_VELOCITY = -300.0
# -----------------------------------------------


# -----------------------------------------------
# Gravedad
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# -----------------------------------------------


# -----------------------------------------------
func _ready():
	cargar_sombrero()  # Cambié el nombre para mayor claridad
# -----------------------------------------------


# -----------------------------------------------
# Funcion para cargar el sombrero seleccionado por el player
func cargar_sombrero():
	# 1. Ocultar todos los sombreros normales primero
	for i in range(1, 9):
		var sombrero = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(i))
		if sombrero:
			sombrero.visible = false
	
	# 2. Ocultar todos los sombreros laterales (si los tienes como nodos)
	for i in range(1, 9):
		var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero" + str(i) + "Lateral")
		if sombrero_lateral:
			sombrero_lateral.visible = false
	
	# 3. Caso especial para sombrero 6 (usar versión lateral)
	if Global.sombrero_seleccionado == 6:
		var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero6Lateral")
		if sombrero_lateral:
			sombrero_lateral.visible = true
		else:
			# Si no existe como nodo, lo cargamos como textura
			var sprite_lateral = Sprite2D.new()
			sprite_lateral.texture = load(Global.RUTA_SOMBREROS_LATERALES + "Sombrero6Lateral.png")
			sprite_lateral.name = "Sombrero6Lateral"
			$Accesorios/SombrerosLateral.add_child(sprite_lateral)
	else:
		# Mostrar sombrero normal
		var sombrero_actual = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(Global.sombrero_seleccionado))
		if sombrero_actual:
			sombrero_actual.visible = true
# -----------------------------------------------


const SUAVIDAD_FRENADO = 1  # Valor entre 0 (lento) y 1 (instantáneo)

func _physics_process(delta):
	# (Mantén tu lógica de movimiento existente)
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# Animaciones
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
		# Asegurar que los accesorios también se volteen
		$Accesorios.scale.x = 1
	elif velocity.x < 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true
		# Voltear accesorios junto con el personaje
		$Accesorios.scale.x = -1

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Perder":
		print("cayo")
		barreraBajaPierde.emit()

