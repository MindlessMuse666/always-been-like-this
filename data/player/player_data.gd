extends Resource
class_name PlayerData

#region Переменные
@export_group("Личность игрока")
@export var player_name: String = "Karakalbe"
@export var is_familiar: bool = false  # Скрытый параметр - определяется в игре

@export_group("Основные статы")
@export_range(0, 10, 1) var health: int = 10
@export_range(0, 10, 1) var paranoia: int = 0
@export_range(0, 10, 1) var attention: int = 5

@export_group("Отношения")
@export var relationships: Dictionary = {}  # Формат: {npc_id: {trust: 50, irritation: 50}}

@export_group("Прогресс")
@export var current_day: int = 1
@export var anomalies_discovered: int = 0
@export var npcs_suspected: int = 0
#endregion

#region Паранойя
func change_paranoia(amount: int) -> void:
	""" Метод для изменения паранойи. """
	# Если игрок - "Знакомый", паранойя растет медленнее
	var actual_amount = amount * (0.5 if is_familiar else 1.0)
	paranoia = clamp(paranoia + actual_amount, 0, 100)
	SignalBus.player_paranoia_changed.emit(paranoia)
#endregion

#region Внимательность
func change_attention(amount: int) -> void:
	""" Метод для изменения внимательности. """
	attention = clamp(attention + amount, 0, 100)
#endregion

#region Отношения
func update_relationship(npc_id: String, trust_change: int, irritation_change: int) -> void:
	""" Метод для изменения отношения. """
	if not relationships.has(npc_id):
		relationships[npc_id] = {"trust": 50, "irritation": 50}

	relationships[npc_id]["trust"] = clamp(relationships[npc_id]["trust"] + trust_change, 0, 100)
	relationships[npc_id]["irritation"] = clamp(relationships[npc_id]["irritation"] + irritation_change, 0, 100)
#endregion
