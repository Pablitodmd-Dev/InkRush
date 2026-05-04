extends Node

var boss_played = false
var boss_path = "res://Scenes/Microgames/TableTurf Final Boss/Main.tscn"

# Diccionario con rutas, tipos de control e instrucciones (nombres)
var minigame_list = {
	"res://Scenes/Microgames/Dodge the balls/Dodge.tscn": {"control": "allArrows", "name": "Dodge the balls!"},
	"res://Scenes/Microgames/dodge_vehicles/main.tscn": {"control": "horizontal", "name": "Dodge the cars!"},
	"res://Scenes/Microgames/Escape the labyrinth/Level1.tscn": {"control": "allArrows", "name": "Scape the maze!"},
	"res://Scenes/Microgames/Help The Robot/Main.tscn": {"control": "vertical", "name": "Help the robot!"},
	"res://Scenes/Microgames/Hit the fruit/main.tscn": {"control": "onlyright", "name": "Hit it!"},
	"res://Scenes/Microgames/Pattern Bot/main.tscn": {"control": "numbers", "name": "Memorize!"},
	"res://Scenes/Microgames/Protect Lulu/Game.tscn": {"control": "horizontal", "name": "Protect Lulu!"},
	"res://Scenes/Microgames/score_the_goal/main.tscn": {"control": "onlyup", "name": "Make a Goal!"},
	"res://Scenes/Microgames/The Last Lesson/main.tscn": {"control": "horizontal", "name": "Test time!"},
	"res://Scenes/Microgames/trampoline_game/trampoline_game.tscn": {"control": "horizontal", "name": "Jump High!"}
}

var lives: int = 4
@onready var menu_layer = $menu

func _ready():
	menu_layer.update_brushes(lives)
	load_random_microgame()

func load_random_microgame() -> void:
	if minigame_list.size() <= 0:
		if not boss_played:
			boss_played = true 
			
			menu_layer.set_game_name("¡Defeat Kroma!") 
			menu_layer.show_screen("start")
			menu_layer.show_specific_controls("allArrows") 

			await menu_layer.intermission_sound.finished

			var boss_scene = load(boss_path).instantiate()
			boss_scene.finished.connect(_on_microgame_finished)
			
			add_child(boss_scene)
			menu_layer.hide_all() 
			menu_layer.hide_all_controls()
			return 
		else:
			get_tree().quit()
			return

	menu_layer.show_screen("start")
	var allKeys = minigame_list.keys()
	var random_index = randi() % minigame_list.size()
	var game_path = allKeys[random_index]
	
	# Extraemos la información del diccionario
	var game_data = minigame_list[game_path]
	var control_type = game_data["control"]
	var game_name = game_data["name"]

	# Enviamos los datos a la capa de menú
	menu_layer.set_game_name(game_name)
	menu_layer.show_specific_controls(control_type)

	# Esperamos a que termine el sonido de intermisión
	await menu_layer.intermission_sound.finished

	var game_scene = load(game_path).instantiate()
	game_scene.finished.connect(_on_microgame_finished)
	
	add_child(game_scene)
	minigame_list.erase(game_path)
	menu_layer.hide_all() 
	menu_layer.hide_all_controls()

func _on_microgame_finished(success: bool) -> void:
	for child in get_children():
		if child != menu_layer:
			child.queue_free()
	
	menu_layer.increment_score() 
	
	if success:
		menu_layer.show_screen("completed")
		await menu_layer.victory_sound.finished
	else:
		lives -= 1
		menu_layer.show_screen("failed")
		menu_layer.update_brushes(lives)
		await menu_layer.defeat_sound.finished

	if lives <= 0:
		print("GAME OVER")
	else:
		load_random_microgame()
