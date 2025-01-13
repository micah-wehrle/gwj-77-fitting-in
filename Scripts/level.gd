extends Node2D

const tile_size = 100;

var tile_grid = [];

@onready var tile_parent = %TileParent;
@onready var level_camera = %LevelCamera;

var tile_scene = preload("res://Scenes/tile.tscn")
var player_scene = preload("res://Scenes/player.tscn");
var player;

var level_data = '111111111111111111111
200000000000000000001
200000001111111111001
200000010110000000001
20p001000100001110001
111111111100000000001
100000000000000000001
100000002200000000001
111111222200000000001
.........222222221111'.split('\n');

# Called when the node enters the scene tree for the first time.
func _ready():
	player = player_scene.instantiate();
	self.add_child(player);
	self.remove_child(level_camera);
	player.add_child(level_camera);
	
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
			if tile_data != '.':
				var tile = tile_scene.instantiate();
				tile_row.push_front(tile);
				tile_parent.add_child(tile);
				
				#setup tile
				
				var new_position = Vector2(x * tile_size, y * tile_size);
				tile.position = new_position;
				
				if tile_data == '0':
					tile.set_is_bg(true);
					tile.set_type(tile_data);
				
				elif tile_data == 'p':
					tile.set_is_bg(true);
					tile.set_type('1');
					player.position = new_position;
				
				else:
					tile.set_type(tile_data);
			x += 1;
			pass;
		tile_grid.push_front(tile_row);
		y += 1;
		pass;
		
	pass;
