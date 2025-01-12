extends Node2D

var tile_size = 100;

var tile_grid = [];

@onready var tile_parent = %TileParent;

var tile_scene = preload("res://Scenes/tile.tscn")
var player_scene = preload("res://Scenes/player.tscn");
var player;

var level_data = '1111111111n1000000001n1000000001n1000000001n1000p00001n1111111111'.split('n');

# Called when the node enters the scene tree for the first time.
func _ready():
	player = player_scene.instantiate();
	self.add_child(player);
	
	self.build_level();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func build_level():
	var y = 0;
	for tile_row_data in level_data:
		var x = 0;
		var tile_row = [];
		for tile_data in tile_row_data:
			var tile = tile_scene.instantiate();
			tile_row.push_front(tile);
			tile_parent.add_child(tile);
			
			#setup tile
			
			var new_position = Vector2(x * tile_size, y * tile_size);
			tile.position = new_position;
			
			if tile_data == '0':
				tile.set_is_bg(true);
			
			if tile_data == 'p':
				tile.set_is_bg(true);
				player.position = new_position;
			x += 1;
			pass;
		tile_grid.push_front(tile_row);
		y += 1;
		pass;
		
	pass;
