extends Node

var minigame_list: Array = [
	"res://Scenes/Microgames/Dodge the balls/Dodge.tscn",
	"res://Scenes/Microgames/dodge_vehicles/main.tscn",
	"res://Scenes/Microgames/Escape the labyrinth/Level1.tscn",
	"res://Scenes/Microgames/Help The Robot/Main.tscn",
	"res://Scenes/Microgames/Hit the fruit/main.tscn",
	"res://Scenes/Microgames/Pattern Bot/main.tscn",
	"res://Scenes/Microgames/Protect Lulu/Game.tscn",
	"res://Scenes/Microgames/score_the_goal/main.tscn",
	"res://Scenes/Microgames/The Last Lesson/main.tscn",
    "res://Scenes/Microgames/trampoline_game/trampoline_game.tscn"
]

var lives: int = 4
@onready var menu_layer = $menu

func _ready():
	menu_layer.update_brushes(lives)
	load_random_microgame()

func load_random_microgame() -> void:
	menu_layer.show_screen("start")
	

	await get_tree().create_timer(3.0).timeout

	var random_index = randi() % minigame_list.size()
	var game_path = minigame_list[5]
	var game_scene = load(game_path).instantiate()

	game_scene.finished.connect(_on_microgame_finished)
	
	add_child(game_scene)
	menu_layer.hide_all() 

func _on_microgame_finished(success: bool) -> void:
	for child in get_children():
		if child != menu_layer:
			child.queue_free()
	
	if success:
		menu_layer.show_screen("completed")
	else:
		lives -= 1
		menu_layer.show_screen("failed")
		menu_layer.update_brushes(lives)

	if lives <= 0:
		print("GAME OVER")
	else:
		await get_tree().create_timer(3.0).timeout
		load_random_microgame()
