extends Resource
class_name PlayerData

#region ПЕРЕМЕННЫЕ
@export_group("Личность игрока")
@export var player_name: String = "Karakalbe"
@export var is_familiar: bool = false  # Скрытый параметр - определяется в игре

@export_group("Основные статы")
@export_range(0, 10, 1) var health: int = 10
@export_range(0, 10, 1) var paranoia: int = 0
@export_range(0, 10, 1) var attention: int = 5
@export_range(0, 100, 1) var stamina: int = 100  # TODO: Для бега и особых действий

@export_group("Отношения")
@export var relationships: Dictionary = {}  # Формат: {npc_id: {trust: 50, irritation: 50}}

@export_group("Прогресс")
@export var current_day: int = 1
@export var anomalies_discovered: int = 0
@export var npcs_suspected: int = 0
#endregion

#region Паранойя
func change_paranoia(amount: int) -> void:
	"""Изменяет уровень паранойи с учетом особенностей "Знакомого"

	Args:
		amount (int): Величина изменения (положительная или отрицательная)
	"""
	# Если игрок - "Знакомый", паранойя растет медленнее
	var actual_amount = amount * (0.5 if is_familiar else 1.0)
	paranoia = clamp(paranoia + actual_amount, 0, 100)
	SignalBus.player_paranoia_changed.emit(paranoia)
#endregion

#region Внимательность
func change_attention(amount: int) -> void:
	"""Изменяет уровень внимательности игрока

	Args:
		amount (int): Величина изменения (положительная или отрицательная)
	"""
	attention = clamp(attention + amount, 0, 100)
#endregion

#region Стамина
func change_stamina(amount: int) -> void:
	"""Изменяет уровень выносливости игрока

	Args:
		amount (int): Величина изменения (положительная или отрицательная)
	"""
	stamina = clamp(stamina + amount, 0, 100)
#endregion

#region Отношения
func update_relationship(npc_id: String, trust_change: int, irritation_change: int) -> void:
	"""Обновляет отношения с NPC по указанному идентификатору

	Args:
		npc_id (String): Уникальный идентификатор NPC
		trust_change (int): Изменение уровня доверия
		irritation_change (int): Изменение уровня раздражения
    """
	if not relationships.has(npc_id):
		relationships[npc_id] = {"trust": 50, "irritation": 50}

	relationships[npc_id]["trust"] = clamp(relationships[npc_id]["trust"] + trust_change, 0, 100)
	relationships[npc_id]["irritation"] = clamp(relationships[npc_id]["irritation"] + irritation_change, 0, 100)

func get_relationship(npc_id: String) -> Dictionary:
	"""Возвращает текущие отношения с NPC

	Args:
		npc_id (String): Уникальный идентификатор NPC

	Returns:
		Dictionary: Словарь с trust и irritation, или значения по умолчанию если NPC не найден
    """
	if relationships.has(npc_id):
		return relationships[npc_id].duplicate()
	else:
		return {"trust": 50, "irritation": 50}
#endregion

# TODO
#region Ежедневные параметры
func reset_daily_stats() -> void:
	"""Сбрасывает ежедневные статистические данные"""
	pass
#endregion
