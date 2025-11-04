class_name MovementComponent
extends Node

#region Переменные

@export_category("Настройки движения")
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var acceleration: float = 10.0
@export var deceleration: float = 15.0
@export var jump_velocity: float = 4.5
@export var air_control: float = .3  # Контроль в воздухе

@export_category("Настройки мыши")
@export var mouse_sensitivity: float = .002
@export var camera_pitch_limit: float = 1.5  # В радианах (~85 градусов)

# Ссылки на узлы
var character_body: CharacterBody3D
var camera_pivot: Node3D
var camera: Camera3D

# Текущие значения
var current_speed: float = .0
var move_direction: Vector3 = Vector3.ZERO
var is_running: bool = false

#endregion

#region Public методы

func initialize(body: CharacterBody3D, pivot: Node3D, cam: Camera3D) -> void:
	"""Инициализирует компонент движения с ссылками на необходимые узлы"""
	character_body = body
	camera_pivot = pivot
	camera = cam

func process_mouse_input(event: InputEventMouseMotion) -> void:
	"""Обрабатывает движение мыши для управления камерой"""
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	# Поворот тела игрока по горизонтали
	character_body.rotate_y(-event.relative.x * mouse_sensitivity)

	# Наклон камеры по вертикали
	camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -camera_pitch_limit, camera_pitch_limit)

func process_movement(delta: float, input_vector: Vector2, is_running_requested: bool) -> void:
	"""Обрабатывает движение персонажа на основе ввода"""
	if not character_body:
		return

	# Определяем, бежит ли персонаж
	is_running = is_running_requested and input_vector != Vector2.ZERO and character_body.is_on_floor()

	# Вычисляем направление движения относительно камеры
	var basis = character_body.global_transform.basis
	move_direction = (basis.z * input_vector.y + basis.x * input_vector.x).normalized()

	# Определяем целевую скорость
	var target_speed = run_speed if is_running else walk_speed
	if input_vector != Vector2.ZERO:
		# Ускорение
		var acceleration_rate = acceleration * (1.0 if character_body.is_on_floor() else air_control)
		current_speed = move_toward(current_speed, target_speed, acceleration_rate * delta)
	else:
		# Замедление
		current_speed = move_toward(current_speed, 0, deceleration * delta)

	# Применяем движение
	if input_vector != Vector2.ZERO:
		character_body.velocity.x = move_direction.x * current_speed
		character_body.velocity.z = move_direction.z * current_speed

func process_gravity(delta: float) -> void:
	"""Обрабатывает гравитацию"""
	if not character_body.is_on_floor():
		character_body.velocity.y -= character_body.gravity * delta

func jump() -> void:
	"""Выполняет прыжок, если персонаж на земле"""
	if character_body.is_on_floor():
		character_body.velocity.y = jump_velocity

func get_is_moving() -> bool:
	"""Возвращает true, если персонаж движется"""
	return move_direction != Vector3.ZERO and current_speed > 0.1

func get_is_running() -> bool:
	"""Возвращает true, если персонаж бежит"""
	return is_running and get_is_moving()

func get_is_falling() -> bool:
	"""Возвращает true, если персонаж падает"""
	return character_body.velocity.y < -0.1

func get_is_jumping() -> bool:
	"""Возвращает true, если персонаж прыгает (движется вверх)"""
	return character_body.velocity.y > 0.1

#endregion
