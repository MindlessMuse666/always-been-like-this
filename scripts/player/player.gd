extends CharacterBody3D
class_name Player


#region ПЕРЕМЕННЫЕ
# Параметры
@export_category("Настройки игрока")
@export var player_data: PlayerData
@export_subgroup("Физика игрока")
@export var gravity: float = 9.8

# Компоненты
@onready var movement: MovementComponent = $MovementComponent
@onready var interaction: InteractionComponent = $InteractionComponent
@onready var state_machine: StateMachine = $StateMachine

# Ссылки на дочерние узлы
@onready var visuals: Node3D = $Visuals
@onready var camera_pivot: Node3D = $Visuals/CameraPivot
@onready var camera: Camera3D = $Visuals/CameraPivot/Camera
@onready var interaction_ray: RayCast3D = $InteractionRayCast
#endregion


#region ОСНОВНЫЕ МЕТОДЫ
func _ready() -> void:
	"""Инициализирует игрока при создании сцены"""
	add_to_group(GlobalConstants.GROUP_PLAYER)

	if not player_data:
		player_data = ResourceLoader.load(GlobalConstants.PATH_PLAYER_DATA)

	# Инициализируем компоненты
	movement.initialize(self, camera_pivot, camera)
	interaction.initialize(interaction_ray)

	# Захватываем мышь
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Сигнал о готовности игрока
	SignalBus.player_data_initialized.emit()
	print("Player: инициализирован")

func _input(event: InputEvent) -> void:
	"""Передает ввод в state machine"""
	if event.is_action_pressed("exit"):  # Esc для выхода
		get_tree().quit()

	state_machine._input(event)

func _physics_process(delta: float) -> void:
	"""Передает физику в state machine"""
	state_machine._physics_process(delta)
#endregion
