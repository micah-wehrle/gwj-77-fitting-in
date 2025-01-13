extends Node2D

var is_background = false;

var tile_id = -1;

@onready var tile_sprite = %TileSprite;
@onready var tile_body = %TileRigidBody2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_type(type_id):
	tile_id = int(type_id);
	if tile_id == 0 or tile_id == 1:
		tile_sprite.frame = randi_range(0,4) if randf() < 0.8 else randi_range(5,7);
	if tile_id == 2:
		tile_sprite.frame = (randi_range(0,4) if randf() < 0.8 else randi_range(5,7)) + 8;

func set_is_bg(is_bg):
	self.is_background = is_bg;
	tile_sprite.set_self_modulate(Color(1,1,1, 0.5 if self.is_background else 1.0));
	#tile_body.set_process( !self.is_background );
	if (is_bg):
		tile_body.queue_free();
	
	 
