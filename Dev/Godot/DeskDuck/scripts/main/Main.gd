extends Node2D
@onready var nova: Sprite2D = $NovaSprite
@onready var task_panel = $TaskPanel
@onready var speech_bubble = $SpeechBubble
@onready var complete_sound = $CompleteSound
@onready var level_up_sound = $LevelUpSound
@onready var menu_sound = $MenuSound
@onready var add_task_sound = $AddTaskSound
@onready var reward_popup = $RewardPopup
var idle_texture = preload("res://assets/characters/nova/idle.png")
var happy_texture = preload("res://assets/characters/nova/happy.png")
var sad_texture = preload("res://assets/characters/nova/sad.png")

var direction = 1
var speed = 40.0
var behavior_timer = 0.0
var behavior_interval = 4.0
var is_happy = false
var is_speaking = false
var messages = [
	"¿Seguimos programando?",
	"¡Buen trabajo!",
	"Nueva misión disponible.",
	"Estás ganando XP.",
	"No olvides tus objetivos.",
	"Vamos, tú puedes.",
	"Completa una tarea para ganar monedas.",
	"Hoy podemos avanzar mucho.",
	"Estoy orgullosa de tu progreso.",
	"¿Qué construiremos hoy?"
]

func _ready():
	nova.texture = idle_texture
	
	SaveManager.load_player()
	TaskManager.load_tasks()
	
	task_panel.visible = false
	speech_bubble.visible = false
	reward_popup.visible = false
	randomize()
	say_message("Hola, David.")
	apply_active_character()
	
func show_happy():
	is_happy = true
	nova.texture = happy_texture

	await get_tree().create_timer(3.0).timeout

	is_happy = false
	nova.texture = idle_texture
func show_sad():
	nova.texture = sad_texture
func _process(delta):
	if nova == null:
		return

	if is_happy:
		return

	nova.position.x += direction * speed * delta

	if nova.position.x > 320:
		direction = -1
		nova.flip_h = true

	if nova.position.x < 180:
		direction = 1
		nova.flip_h = false

	behavior_timer += delta

	if behavior_timer >= behavior_interval:
		behavior_timer = 0.0
		random_behavior()
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			var nova_rect = Rect2(
				nova.global_position - (nova.texture.get_size() * nova.scale) / 2,
				nova.texture.get_size() * nova.scale
			)

			if nova_rect.has_point(mouse_pos):
				task_panel.visible = not task_panel.visible
				play_menu_sound()
func random_behavior():
	var roll = randi_range(1, 100)

	if roll <= 50:
		speed = 0
		nova.texture = idle_texture

	elif roll <= 80:
		speed = 40
		nova.texture = idle_texture

	elif roll <= 90:
		speed = 0
		nova.texture = happy_texture

	else:
		speed = 0
		nova.texture = sad_texture
		
	if randi_range(1, 100) <= 30:
		random_message()
		
		
func say_message(message: String):
	if is_speaking:
		return

	is_speaking = true
	speech_bubble.text = "💭 " + message
	speech_bubble.visible = true

	await get_tree().create_timer(3.0).timeout

	speech_bubble.visible = false
	is_speaking = false
func random_message():
	var msg = messages[randi() % messages.size()]
	say_message(msg)
func play_complete_sound():
	complete_sound.play()

func play_levelup_sound():
	level_up_sound.play()

func play_menu_sound():
	menu_sound.play()
func play_add_task_sound():
	add_task_sound.play()
func show_reward_popup(text: String):
	reward_popup.text = text
	reward_popup.visible = true
	reward_popup.modulate.a = 1.0

	var start_position = reward_popup.position
	var end_position = start_position + Vector2(0, -40)

	var tween = create_tween()
	tween.tween_property(reward_popup, "position", end_position, 1.2)
	tween.parallel().tween_property(reward_popup, "modulate:a", 0.0, 1.2)

	await tween.finished

	reward_popup.visible = false
	reward_popup.position = start_position
	reward_popup.modulate.a = 1.0
func show_levelup_popup():
	reward_popup.text = "🎉 LEVEL UP! 🎉"
	reward_popup.visible = true
	reward_popup.modulate.a = 1.0

	var start_position = reward_popup.position
	var end_position = start_position + Vector2(0, -60)

	var tween = create_tween()
	tween.tween_property(reward_popup, "position", end_position, 2.0)
	tween.parallel().tween_property(reward_popup, "scale", Vector2(1.5, 1.5), 0.5)
	tween.parallel().tween_property(reward_popup, "modulate:a", 0.0, 2.0)

	await tween.finished

	reward_popup.visible = false
	reward_popup.position = start_position
	reward_popup.scale = Vector2(1, 1)
	reward_popup.modulate.a = 1.0
func apply_active_character():
	var active = CharacterManager.active_character

	if active == "nova_classic":
		idle_texture = load("res://assets/characters/nova/classic/idle.png")
	elif active == "nova_gold":
		idle_texture = load("res://assets/characters/nova/gold/idle.png")
	elif active == "nova_shadow":
		idle_texture = load("res://assets/characters/nova/shadow/idle.png")

	nova.texture = idle_texture
