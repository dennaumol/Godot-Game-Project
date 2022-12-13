extends Node2D


var YellowSandBlock = load("res://Level Objects/Yellow Sand/YellowSandBlock.tscn")
var YellowSandTop0 = load("res://Level Objects/Yellow Sand/YellowSandTop0.tscn")
var YellowSandTop1 = load("res://Level Objects/Yellow Sand/YellowSandTop1.tscn")
var YellowSandTop2 = load("res://Level Objects/Yellow Sand/YellowSandTop2.tscn")
var YellowSandTop3 = load("res://Level Objects/Yellow Sand/YellowSandTop3.tscn")

var yellow_sand_top_instances = [YellowSandTop0, YellowSandTop1, YellowSandTop2, YellowSandTop3]
var current_y = 0
var current_x = 0
var current_sand_top_variation = 0
var tile

func _ready():
	for i in range(1500):
		tile = yellow_sand_top_instances[current_sand_top_variation].instance()
		tile.position = Vector2(current_x, current_y)
		add_child(tile)
		
		for j in range(10):
			tile = YellowSandBlock.instance()
			tile.position = Vector2(current_x, current_y + (j + 1) * 16)
			add_child(tile)
		current_sand_top_variation += 1
		if current_sand_top_variation >= 4:
			current_sand_top_variation = 0
		current_x += 16
		
		
			
		
