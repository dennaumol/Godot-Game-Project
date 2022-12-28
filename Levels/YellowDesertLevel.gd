extends Node2D

var background = load("res://Level Objects/Yellow Desert/YellowDesertBackground.tscn").instance()
var DesertPart0 = load("res://Level Objects/Yellow Desert/YellowDesertPart0.tscn")
var DesertPart1 = load("res://Level Objects/Yellow Desert/YellowDesertPart1.tscn")
var DesertPart2 = load("res://Level Objects/Yellow Desert/YellowDesertPart2.tscn")
var DesertPart3 = load("res://Level Objects/Yellow Desert/YellowDesertPart3.tscn")
var DesertPart4 = load("res://Level Objects/Yellow Desert/YellowDesertPart4.tscn")
var DesertPart5 = load("res://Level Objects/Yellow Desert/YellowDesertPart5.tscn")


var _player_camera

var is_background_set_to_player_camera = false

var Explosive = load("res://Enemies/Explosive.tscn")
var Bomber = load("res://Enemies/Bomber.tscn")
var Crab = load("res://Enemies/Crab.tscn")
var Flamethrower = load("res://Enemies/Flamethrower.tscn")

var ground_enemies = [Crab, Explosive, Flamethrower]

var parts = [DesertPart0, DesertPart1, DesertPart2, DesertPart3, DesertPart4, DesertPart5]
var k
var current_x = 0
var current_y = 0
var part
var ground_enemies_spawn_positions = []
var flying_enemies_spawn_positions = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(40):
		k = randi() % parts.size()
		part = parts[k].instance()
		part.position = Vector2(current_x, current_y)
		add_child(part)
		ground_enemies_spawn_positions += part.ground_enemies_spawn_positions
		flying_enemies_spawn_positions += part.flying_enemies_spawn_positions
		current_x += part.width
	for spawn_position in ground_enemies_spawn_positions:
		k = randi() % ground_enemies.size()
		var enemy = ground_enemies[k].instance()
		add_child(enemy)
		enemy.global_position = spawn_position.global_position
	for spawn_position in flying_enemies_spawn_positions:
		if randi() % 3 == 0:
			var enemy = Bomber.instance()
			add_child(enemy)
			enemy.global_position = spawn_position.global_position
			
	
func _physics_process(delta):
	if not is_background_set_to_player_camera:
		_player_camera = get_node("Player").get_node("PlayerCamera")
		_player_camera.add_child(background)
		is_background_set_to_player_camera = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
