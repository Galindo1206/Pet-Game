extends Control

@onready var title_label = $PanelContainer/VBoxContainer/TitleLabel
@onready var stats_label = $PanelContainer/VBoxContainer/StatsLabel
@onready var task_input = $PanelContainer/VBoxContainer/TaskInput
@onready var add_button = $PanelContainer/VBoxContainer/AddButton
@onready var task_list = $PanelContainer/VBoxContainer/TaskList

func _ready():
	SaveManager.load_player()
	TaskManager.load_tasks()

	update_ui()

	add_button.pressed.connect(_on_add_button_pressed)

func update_ui():
	title_label.text = "MISSION CONTROL"

	stats_label.text = "Nivel: %s | XP: %s | Monedas: %s" % [
		
		PlayerManager.level,
		PlayerManager.xp,
		PlayerManager.coins
	]
	for child in task_list.get_children():
		child.queue_free()

	for task in TaskManager.get_tasks():
		var checkbox = CheckBox.new()
		checkbox.text = task["title"]
		checkbox.button_pressed = task["completed"]

		if task["completed"]:
			checkbox.disabled = true
		else:
			checkbox.pressed.connect(func():
				TaskManager.complete_task(task["id"])
				update_ui()

				get_parent().show_happy()
		)

		task_list.add_child(checkbox)
	
	
func _on_add_button_pressed():
	var title = task_input.text.strip_edges()

	if title == "":
		return

	TaskManager.add_task(title)
	task_input.text = ""

	update_ui()
