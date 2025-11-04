extends BaseState
class_name PlayerIdleState

@onready var player: Player = $"../.."
@onready var movement: MovementComponent = $"../../MovementComponent"

func enter() -> void:
	"""Вызывается при входе в состояние"""
	SignalBus.player_state_changed.emit(GlobalConstants.PLAYER_STATE.IDLE)

func physics_process(delta: float) -> void:
	"""Обрабатывает физику каждый кадр"""
	# Обработка движения
	var input_vector = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var is_running = Input.is_action_pressed("run")

	movement.process_movement(delta, input_vector, is_running)
	movement.process_gravity(delta)

	player.move_and_slide()

	# Проверка перехода в другие состояния
	if not player.is_on_floor():
		if movement.get_is_jumping():
			state_machine.transition_to("JumpState")
		else:
			state_machine.transition_to("FallState")
	elif movement.get_is_moving():
		if movement.get_is_running():
			state_machine.transition_to("RunState")
		else:
			state_machine.transition_to("WalkState")

func input(event: InputEvent) -> void:
	"""Обрабатывает ввод"""
	if event.is_action_pressed("jump"):
		movement.jump()
	elif event is InputEventMouseMotion:
		movement.process_mouse_input(event)

func exit() -> void:
	"""Вызывается при выходе из состояния"""
	pass
