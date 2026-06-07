extends Control

@onready var title_label = $PanelContainer/VBoxContainer/TitleLabel
@onready var stats_label = $PanelContainer/VBoxContainer/StatsLabel
@onready var task_input = $PanelContainer/VBoxContainer/TaskInput
@onready var add_button = $PanelContainer/VBoxContainer/AddButton
@onready var task_list = $PanelContainer/VBoxContainer/TaskList
@onready var close_button = $PanelContainer/VBoxContainer/CloseButton
@onready var reset_button = $PanelContainer/VBoxContainer/ResetButton

func _ready():
	
	SaveManager.load_player()
	TaskManager.load_tasks()
	add_button.pressed.connect(_on_add_button_pressed)
	update_ui()
	close_button.pressed.connect(_on_close_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)

func update_ui():
	title_label.text = "MISSION CONTROL"

	stats_label.text = "Nivel: %s | XP: %s/%s | Monedas: %s" % [
		PlayerManager.level,
		PlayerManager.xp,
		PlayerManager.get_required_xp(),
		PlayerManager.coins
	]

	for child in task_list.get_children():
		child.queue_free()

	var has_pending_tasks = false

	for task in TaskManager.get_tasks():
		if task["completed"]:
			continue

		has_pending_tasks = true

		var checkbox = CheckBox.new()
		checkbox.text = task["title"]

		checkbox.pressed.connect(func():
			var leveled_up = TaskManager.complete_task(task["id"])

			get_parent().show_happy()
			get_parent().play_complete_sound()

			if leveled_up:
				get_parent().play_levelup_sound()
				get_parent().say_message("¡Subiste de nivel! Recompensa obtenida.")
			else:
				get_parent().say_message("¡Misión completada! XP obtenida.")

			update_ui()
		)

		task_list.add_child(checkbox)

	#if has_pending_tasks and get_parent().has_method("show_sad"):
	#	get_parent().call_deferred("show_sad")

func _on_add_button_pressed():
	var title = task_input.text.strip_edges()

	if title == "":
		return

	TaskManager.add_task(title)
	get_parent().play_add_task_sound()
	get_parent().say_message("Nueva misión registrada.")
	task_input.text = ""
	update_ui()
func _on_close_button_pressed():
	get_parent().play_menu_sound()
	visible = false
func _on_reset_button_pressed():
	PlayerManager.level = 1
	PlayerManager.xp = 0
	PlayerManager.coins = 0

	TaskManager.tasks.clear()

	SaveManager.save_player()
	SaveManager.save_tasks(TaskManager.tasks)

	get_parent().say_message("Progreso reiniciado.")
	update_ui()
