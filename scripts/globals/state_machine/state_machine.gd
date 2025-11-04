class_name StateMachine
extends Node


#region ПЕРЕМЕННЫЕ
@export var initial_state: BaseState

var current_state: BaseState
var states: Dictionary = {}
var object: Object
#endregion


#region Переопределённые методы
func _ready() -> void:
	"""Инициализирует state machine, собирая все дочерние состояния"""
	object = get_parent()

	# Автоматически собираем все дочерние состояния
	for child in get_children():
		if child is BaseState:
			states[child.name] = child
			child.state_machine = self
			child.object = object  # Передаем object в состояния

	if initial_state:
		initial_state.enter()
		current_state = initial_state
		_log_state_change(initial_state.get_state_name())
	else:
		push_error("StateMachine: initial_state не установлен!")

func _process(delta: float) -> void:
	"""Передает вызов process текущему состоянию

	Args:
		delta (float): Время с последнего кадра
	"""
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	"""Передает вызов physics_process текущему состоянию

	Args:
		delta (float): Время с последнего физического кадра
	"""
	if current_state:
		current_state.physics_process(delta)

func _input(event: InputEvent) -> void:
	"""Передает ввод текущему состоянию

	Args:
		event (InputEvent): Событие ввода
	"""
	if current_state:
		current_state.input(event)

func _unhandled_input(event: InputEvent) -> void:
	"""Передает необработанный ввод текущему состоянию

	Args:
		event (InputEvent): Событие ввода
	"""
	if current_state:
		current_state.unhandled_input(event)
#endregion


#region Публичные методы
func transition_to(state_name: String) -> void:
	"""Переключает на указанное состояние

	Args:
		state_name (String): Имя состояния для переключения
	"""
	if not states.has(state_name):
		push_error("StateMachine: Состояние '%s' не существует!" % state_name)
		return

	if current_state:
		current_state.exit()

	current_state = states[state_name]
	current_state.enter()
	_log_state_change(current_state.get_state_name())

func get_current_state_name() -> String:
	"""Возвращает имя текущего состояния для отладки

	Returns:
		String: Имя текущего состояния
	"""
	if current_state:
		return current_state.get_state_name()
	return "NONE"
#endregion


#region Приватные методы
func _log_state_change(new_state: String) -> void:
	"""Логирует смену состояния для отладки

	Args:
		new_state (String): Имя нового состояния
	"""
	print("StateMachine: Переключение на состояние '%s'" % new_state)
#endregion
