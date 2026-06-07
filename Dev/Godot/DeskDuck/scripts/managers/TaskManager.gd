extends Node

var tasks: Array = []

func add_task(title: String):
	var task = {
		"id": Time.get_unix_time_from_system(),
		"title": title,
		"completed": false
	}

	tasks.append(task)
	SaveManager.save_tasks(tasks)

func complete_task(task_id):
	for task in tasks:
		if task["id"] == task_id:
			task["completed"] = true
			var leveled_up = PlayerManager.add_xp(50)
			PlayerManager.add_coins(25)

			return leveled_up
			
			SaveManager.save_tasks(tasks)
			return

func get_tasks() -> Array:
	return tasks

func load_tasks():
	tasks = SaveManager.load_tasks()
