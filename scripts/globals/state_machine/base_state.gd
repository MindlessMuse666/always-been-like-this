class_name BaseState
extends Node

#region Переменные

var state_machine: StateMachine = null  # Ссылка на state machine будет устанавливаться автоматически
var object: Object = null  # Объект, которым управляет state machine

#endregion

#region Виртуальные методы, которые должны быть переопределены в наследниках

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func input(_event: InputEvent) -> void:
	pass

func unhandled_input(_event: InputEvent) -> void:
	pass

#endregion
