extends CanvasLayer


#region ПЕРЕМЕННЫЕ
@onready var state_label: Label = $MarginContainer/VBoxContainer/StateInfo
@onready var position_label: Label = $MarginContainer/VBoxContainer/PositionInfo
@onready var stats_label: Label = $MarginContainer/VBoxContainer/StatsInfo

var player: Player
var player_data: PlayerData
#endregion


func _ready() -> void:
	"""Инициализирует отладочный интерфейс"""
	visible = false  # Скрываем интерфейс пока игрок не инициализирован

	await get_tree().process_frame  # Ждем пока игрок будет готов
	_find_player()

	if player:
		player_data = ResourceLoader.load(GlobalConstants.PATH_PLAYER_DATA)
		visible = true
		print("Debug UI: Инициализирован")
	else:
		print("Debug UI: Игрок не найден")

	# Подписываемся на сигналы
	SignalBus.player_state_changed.connect(_on_player_state_changed)
	SignalBus.player_paranoia_changed.connect(_on_player_paranoia_changed)
	SignalBus.player_data_initialized.connect(_on_player_data_initialized)

func _process(_delta: float) -> void:
	"""Обновляет отладочную информацию каждый кадр"""
	if not visible or not player:
		return

	# Позиция игрока
	if position_label:
		var pos = player.global_position
		position_label.text = "Позиция: X:%.1f Y:%.1f Z:%.1f" % [pos.x, pos.y, pos.z]

	# Статы игрока
	_update_stats_display()


func _on_player_data_initialized() -> void:
	"""Вызывается когда данные игрока инициализированы"""
	player = get_tree().get_first_node_in_group(GlobalConstants.GROUP_PLAYER)
	player_data = ResourceLoader.load(GlobalConstants.PATH_PLAYER_DATA)
	visible = true

func _on_player_state_changed(new_state: GlobalConstants.PLAYER_STATE) -> void:
	"""Обновляет отображение состояния игрока"""
	if state_label:
		state_label.text = "Состояние: %s" % GlobalConstants.PLAYER_STATE.keys()[new_state]

func _on_player_paranoia_changed(_new_value: int) -> void:
	"""Обновляет отображение паранойи"""
	_update_stats_display()


func _find_player() -> void:
	"""Находит игрока в сцене"""
	var players = get_tree().get_nodes_in_group(GlobalConstants.GROUP_PLAYER)
	if players.size() > 0:
		player = players[0]
		print("Debug UI: Игрок найден")

func _update_stats_display() -> void:
	"""Обновляет отображение статистики игрока"""
	if stats_label and player_data:
		stats_label.text = "Паранойя: %d\nВнимание: %d\nЗдоровье: %d" % [
			player_data.paranoia,
			player_data.attention,
			player_data.health
		]
