class_name StateMachine
extends Node

#region Переменные

@export var initial_state: BaseState

var current_state: BaseState
var states: Dictionary = {}

#endregion

#region Override методы

func _ready() -> void:
	# Автоматически собираем все дочерние состояния
	for child in get_children():
		if child is BaseState:
			states[child.name] = child
			child.state_machine = self
			child.object = get_parent()  # Родитель StateMachine - это управляемый объект

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.unhandled_input(event)

#endregion

#region Public методы

func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		push_error("❌ Состояния '%s' не существует в StateMachine" % state_name)
		return

	if current_state:
		current_state.exit()

	current_state = states[state_name]
	current_state.enter()

#endregion
