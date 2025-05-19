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
		
if Global.esSombreroCombinado:
		var sombrero_combinado = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(Global.numeroSombreroCombinado))
		if sombrero_combinado:
			sombrero_combinado.visible = true
		else:
			var sprite_combinado = Sprite2D.new()
			sprite_combinado.texture = load(Global.RUTA_SOMBREROS_NORMALES + "Sombrero" + str(Global.numeroSombreroCombinado) + ".png")
			sprite_combinado.name = "Sombrero" + str(Global.numeroSombreroCombinado)
			$Accesorios/Sombreros.add_child(sprite_combinado)
			
		
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
	# 1. Ocultar todos los sombreros primero
	for i in range(1, 9):
		# Sombreros normales
		var sombrero = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(i))
		if sombrero:
			sombrero.visible = false
		
		# Sombreros laterales
		var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero" + str(i) + "Lateral")
		if sombrero_lateral:
			sombrero_lateral.visible = false
	
	if Global.numeroSombreroCombinado == 2:
		sombreroLateralCombinado(Global.numeroSombreroCombinado)
	
	
	if Global.sombrero_seleccionado == 2:
		if Global.esSombreroCombinado:
			var sombrero_combinado = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(Global.numeroSombreroCombinado))
			if sombrero_combinado:
				sombrero_combinado.visible = true
	if Global.sombrero_seleccionado == 3:
		if Global.esSombreroCombinado:
			var sombrero_combinado = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(Global.numeroSombreroCombinado))
			if sombrero_combinado:
				sombrero_combinado.visible = true
				
	if Global.sombrero_seleccionado == 4:
		if Global.esSombreroCombinado:
			var sombrero_combinado = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(Global.numeroSombreroCombinado))
			if sombrero_combinado:
				sombrero_combinado.visible = true

	
	# 2. Mostrar SIEMPRE el sombrero base seleccionado
	if Global.sombrero_seleccionado == 6:
		# Caso especial para sombrero 6 (versión lateral)
		var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero6Lateral")
		if sombrero_lateral:
			sombrero_lateral.visible = true
		else:
			var sprite_lateral = Sprite2D.new()
			sprite_lateral.texture = load(Global.RUTA_SOMBREROS_LATERALES + "Sombrero6Lateral.png")
			sprite_lateral.name = "Sombrero6Lateral"
			$Accesorios/SombrerosLateral.add_child(sprite_lateral)
	elif  Global.sombrero_seleccionado == 2:
		# Caso especial para sombrero 6 (versión lateral)
		var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero2Lateral")
		if sombrero_lateral:
			sombrero_lateral.visible = true
		else:
			var sprite_lateral = Sprite2D.new()
			sprite_lateral.texture = load(Global.RUTA_SOMBREROS_LATERALES + "Sombrero2Lateral.png")
			sprite_lateral.name = "Sombrero2Lateral"
			$Accesorios/SombrerosLateral.add_child(sprite_lateral)
		
	else:
		# Mostrar sombrero normal base
		var sombrero_base = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(Global.sombrero_seleccionado))
		if sombrero_base:
			sombrero_base.visible = true
		else:
			var sprite = Sprite2D.new()
			sprite.texture = load(Global.RUTA_SOMBREROS_NORMALES + "Sombrero" + str(Global.sombrero_seleccionado) + ".png")
			sprite.name = "Sombrero" + str(Global.sombrero_seleccionado)
			$Accesorios/Sombreros.add_child(sprite)
	
	# 3. Si hay sombrero combinado, mostrarlo ADEMÁS del base
	
	print(" En Prueba player - Cargando - Combinado: ", Global.esSombreroCombinado, " | Número: ", Global.numeroSombreroCombinado)
	print(Global.sombrero_seleccionado)
# -----------------------------------------------


func sombreroLateralCombinado(numeroSombreroCombinado):
	var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero" + str(numeroSombreroCombinado) + "Lateral")
	if sombrero_lateral:
		sombrero_lateral.visible = true

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

