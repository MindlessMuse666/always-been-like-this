class_name InteractionComponent
extends Node

#region ПЕРЕМЕННЫЕ
@export var interaction_range: float = 3.0
@export var interaction_layer: int = 1  # Слой для взаимодействия
#endregion

var ray_cast: RayCast3D

func initialize(ray_cast_node: RayCast3D) -> void:
	"""Инициализирует компонент взаимодействия с RayCast узлом

	Args:
		ray_cast_node (RayCast3D): RayCast узел для обнаружения взаимодействий
	"""
	ray_cast = ray_cast_node
	ray_cast.target_position = Vector3(0, 0, -interaction_range)
	ray_cast.collision_mask = interaction_layer

func try_interact() -> void:
	"""Пытается взаимодействовать с объектом, на который направлен RayCast"""
	if not ray_cast.is_colliding():
		return

	var collider = ray_cast.get_collider()
	if collider and collider.has_method("interact"):
		collider.interact()
		SignalBus.interaction_started.emit(collider)

func get_look_target() -> Node:
	"""Возвращает объект, на который в данный момент смотрит игрок

	Returns:
		Node: Объект взаимодействия или null, если ничего не найдено
	"""
	if ray_cast.is_colliding():
		return ray_cast.get_collider()
	return null

func is_looking_at_interactable() -> bool:
	"""Проверяет, смотрит ли игрок на интерактивный объект

	Returns:
		bool: True если смотрит на объект с методом interact
	"""
	var target = get_look_target()
	return target != null and target.has_method("interact")
