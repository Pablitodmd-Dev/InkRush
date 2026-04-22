extends Node2D

@export var arrow_scene: PackedScene
@onready var anim = $AnimatedSprite2D
@onready var line = $Line2D
@onready var spawn = $SpawnPoint
@onready var hit_sound = $HitSound

var can_shoot = true 
var angle = 0.0
var max_angle = PI/4 
var line_length = 200

func _ready():
	anim.play("idle")

func _process(_delta):
	if can_shoot: 
		angle = sin(Time.get_ticks_msec() * 0.003) * max_angle
		var x = cos(angle) * line_length
		var y = sin(angle) * line_length
		line.set_point_position(1, Vector2(x, y))
		spawn.position = Vector2(x, y)

func _input(event):
	if event.is_action_pressed("ui_right") and can_shoot:
		shoot()

func shoot():
	can_shoot = false 
	line.visible = false 
	
	if arrow_scene:
		var arrow = arrow_scene.instantiate()
		get_tree().current_scene.add_child(arrow)
		arrow.global_position = spawn.global_position
		arrow.rotation = angle 

func play_win_animation():
	hit_sound.play()
	anim.play("win")
