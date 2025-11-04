extends BaseState
class_name PlayerFallState

var player: CharacterBody3D
var movement: MovementComponent

func enter() -> void:
	"""Вызывается при входе в состояние"""
	player = object
	movement = player.movement_component
	SignalBus.player_state_changed.emit(GlobalConstants.PLAYER_STATE.FALL)

func physics_process(delta: float) -> void:
	"""Обрабатывает физику каждый кадр"""
	var input_vector = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var is_running = Input.is_action_pressed("run")

	movement.process_movement(delta, input_vector, is_running)
	movement.process_gravity(delta)

	player.move_and_slide()

	# Проверка перехода в другие состояния
	if player.is_on_floor():
		if movement.get_is_moving():
			if movement.get_is_running():
				state_machine.transition_to("RunState")
			else:
				state_machine.transition_to("WalkState")
		else:
			state_machine.transition_to("IdleState")
	elif movement.get_is_jumping():
		state_machine.transition_to("JumpState")

func input(event: InputEvent) -> void:
	"""Обрабатывает ввод"""
	if event is InputEventMouseMotion:
		movement.process_mouse_input(event)

func exit() -> void:
	"""Вызывается при выходе из состояния"""
	pass
