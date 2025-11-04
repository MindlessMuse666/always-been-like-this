extends Node

#region Энамы
enum NPC_TYPE { HUMAN, FAMILIAR, UNKNOWN }
enum GAME_STATE { MAIN_MENU, DAY_CYCLE, NIGHT_CYCLE, PAUSED, MINIGAME, GAME_OVER }
enum DAY_CYCLE_STATE { MORNING, DAY, EVENING }
enum PLAYER_STATE { NORMAL, OBSERVING, PANIC, IN_DIALOGUE }
#endregion

#region Группы
const GROUP_PLAYER := "player"
const GROUP_NPCS := "npcs"
const GROUP_INTERACTABLES := "interactables"
#endregion

#region Пути к ресурсам
const PATH_PLAYER_DATA := "res://data/player_data.tres"
#endregion
