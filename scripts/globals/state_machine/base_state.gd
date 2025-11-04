class_name BaseState
extends Node


#region ПЕРЕМЕННЫЕ
var state_machine: StateMachine = null  # Ссылка на state machine будет устанавливаться автоматически
var object: Object = null  # Объект, которым управляет state machine
#endregion


#region Виртуальные методы
func enter() -> void:
	"""Вызывается при входе в состояние"""
	pass

func exit() -> void:
	"""Вызывается при выходе из состояния"""
	pass

func process(_delta: float) -> void:
	"""Вызывается каждый кадр в _process

	Args:
		delta (float): Время с последнего кадра
	"""
	pass

func physics_process(_delta: float) -> void:
	"""Вызывается каждый кадр в _physics_process

	Args:
		delta (float): Время с последнего физического кадра
	"""
	pass

func input(_event: InputEvent) -> void:
	"""Вызывается при получении ввода

	Args:
		event (InputEvent): Событие ввода
	"""
	pass

func unhandled_input(_event: InputEvent) -> void:
	"""Вызывается при получении необработанного ввода

	Args:
		event (InputEvent): Событие ввода
	"""
	pass
#endregion


#region Вспомогательные методы
func get_state_name() -> String:
	"""Возвращает имя состояния для отладки

	Returns:
		String: Имя состояния
	"""
	return name.replace("State", "")
#endregion
