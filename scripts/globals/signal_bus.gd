extends Node

@warning_ignore_start("unused_signal")

#region Игрок
signal player_state_changed(new_state: GlobalConstants.PLAYER_STATE)
signal player_paranoia_changed(new_value: int)
signal player_data_initialized()
#endregion

#region Игровой цикл
signal game_state_changed(new_state: GlobalConstants.GAME_STATE)
signal day_cycle_changed(new_cycle: GlobalConstants.DAY_CYCLE_STATE)
signal day_finished()  # Когда игрок лег спать
#endregion

#region Взаимодействие
signal interaction_started(interactable: Node)
signal interaction_finished(interactable: Node)
signal npc_interacted(npc_id: String, response_type: String)
#endregion

#region Система наблюдения
signal anomaly_detected(description: String)
signal suspicion_level_changed(npc_id: String, new_level: int)
#endregion
