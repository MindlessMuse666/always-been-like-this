class_name InteractionComponent
extends Node

@export var interaction_range: float = 3.0

var ray_cast: RayCast3D

func initialize(ray_cast_node: RayCast3D) -> void:
	ray_cast = ray_cast_node
	ray_cast.target_position = Vector3(0, 0, -interaction_range)

func try_interact() -> void:
	if not ray_cast.is_colliding():
		return

	var collider = ray_cast.get_collider()
	if collider and collider.has_method("interact"):
		collider.interact()
		SignalBus.interaction_started.emit(collider)

func get_look_target() -> Node:
	if ray_cast.is_colliding():
		return ray_cast.get_collider()
	return null
