extends Node

const SAVE_PATH = "user://player.json"

func save_player():
	var data = {
		"level": PlayerManager.level,
		"xp": PlayerManager.xp,
		"coins": PlayerManager.coins
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_player():
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file:
		var content = file.get_as_text()
		file.close()

		var json = JSON.parse_string(content)

		if json:
			PlayerManager.level = json.get("level", 1)
			PlayerManager.xp = json.get("xp", 0)
			PlayerManager.coins = json.get("coins", 0)
const TASKS_PATH = "user://tasks.json"

func save_tasks(tasks: Array):
	var file = FileAccess.open(TASKS_PATH, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(tasks))
		file.close()

func load_tasks() -> Array:
	if not FileAccess.file_exists(TASKS_PATH):
		return []

	var file = FileAccess.open(TASKS_PATH, FileAccess.READ)

	if file:
		var content = file.get_as_text()
		file.close()

		var json = JSON.parse_string(content)

		if json is Array:
			return json

	return []