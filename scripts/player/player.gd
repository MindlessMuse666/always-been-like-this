extends CharacterBody3D

# Компоненты
@onready var movement_component: MovementComponent = $MovementComponent
@onready var interaction_component: InteractionComponent = $InteractionComponent
@onready var state_machine: StateMachine = $StateMachine

# Ссылки на дочерние узлы
@onready var visuals: Node3D = $Visuals
@onready var camera_pivot: Node3D = $Visuals/CameraPivot
@onready var camera: Camera3D = $Visuals/CameraPivot/Camera3D
@onready var interaction_ray: RayCast3D = $InteractionRayCast

# Параметры
@export_category("Player Physics")
@export var gravity: float = 9.8

func _ready() -> void:
    """Инициализирует игрока при создании сцены"""
	# Инициализируем компоненты
	movement_component.initialize(self, camera_pivot, camera)
	interaction_component.initialize(interaction_ray)

	# Настраиваем State Machine
	state_machine.object = self

	# Захватываем мышь
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Сигнал о готовности игрока
	SignalBus.player_data_initialized.emit()

func _input(event: InputEvent) -> void:
    """Передает ввод в state machine"""
	state_machine.input(event)

func _physics_process(delta: float) -> void:
    """Передает физику в state machine"""
	state_machine.physics_process(delta)

# Публичные методы для доступа из состояний
func get_movement_component() -> MovementComponent:
    """Возвращает компонент движения"""
	return movement_component

func get_interaction_component() -> InteractionComponent:
    """Возвращает компонент взаимодействия"""
	return interaction_component
