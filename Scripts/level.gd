extends Node2D

const tile_size = 100;

var tile_grid = [];

@onready var tile_parent = %TileParent;
@onready var level_camera = %LevelCamera;

var tile_scene = preload("res://Scenes/tile.tscn")
var player_scene = preload("res://Scenes/player.tscn");
var player;

var level_data_old = '111111111111111111111
200000000000000000001
200000001111111111001
200000010110000000001
20p001000100001110001
221111111100000000001
100000000000000000001
100000002200000000001
111111222200000000001
.........222222221111'.split('\n');

var level_data = 'size:10,7|ver:1|tiles:empty~empty~empty~empty~empty~empty~empty~empty~empty~empty^empty~wall~wall~wall~wall~wall~wall~wall~wall~empty^empty~wall~bg~bg~bg~bg~bg;PU~bg~wall~empty^empty~wall~bg~bg;player~bg~bg~wall~bg~wall~empty^empty~wall~bg~wall~bg~bg~wall~bg~wall~empty^empty~wall~wall~wall~wall~wall~wall~wall~wall~empty^empty~empty~empty~empty~empty~empty~empty~empty~empty~empty'

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
	var metadata = level_data.split('|');
	
	var width = 0;
	var height = 0;
	
	var version = '0';
	
	var level_raw = '';
	
	for data in metadata:
		var data_parts = data.split(':');
		if data_parts[0] == 'size':
			var size = data_parts[1].split(',');
			width = int(size[0]);
			height = int(size[1]);
		elif data_parts[0] == 'ver':
			version = data_parts[1];
		elif data_parts[0] == 'tiles':
			level_raw = data_parts[1];
	
	var level_rows_raw = level_raw.split('^'); # an array of rows
	
	var level_data = [];
	var y = 0;
	for level_row_raw in level_rows_raw: # loop through each row
		var x= 0;
		var tile_row = [];
		var tiles_raw = level_row_raw.split('~');
		
		for tile_raw in tiles_raw: # loop through each individual tile in the row
			
			if tile_raw.contains('empty'): # nothing should need to be done for empty tiles. Players and powerups should always be on a background tile, empty tiles are outside the world.
				continue;
			
			var tile_parts_raw = tile_raw.split(';');
			for tile_prop in tile_parts_raw: # loop through all the properties of a tile. Usually just the type (like wall, bg, etc) but contains if the player is there, or if there's a powerup
				if tile_prop == 'player':
					player.position = Vector2(x * tile_size, y * tile_size); # just update the loc of the player. Not strictly a tile action.
					pass;
				elif tile_prop == 'PU':
					pass; # to be implemented
				else: # Might need to setup better, as any non-tile label properties I add will default to here. Maybe I should make all tile types be like tile-empty and tile-bg so I can check.
					var tile = tile_scene.instantiate();
					tile_row.push_back(tile); # add tile to current row array (row will be added to the main tile_grid after it's populated
					tile_parent.add_child(tile); # This adds the tile to the world, there's a Node2D called %TileParent that just gets all the tiles slapped onto it
					 
					# setup tile
					var new_position = Vector2(x * tile_size, y * tile_size);
					tile.position = new_position;
					
					if tile_prop == 'bg':
						tile.set_is_bg(true);
						tile.set_type('0');
					
					elif tile_prop == 'wall':
						tile.set_type('1');
					
					
					pass;
			x += 1;
		tile_grid.push_back(tile_row);
		y += 1;

func build_level_old():
	var level_data = [];
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
