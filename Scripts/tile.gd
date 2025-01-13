extends Node2D

var is_background = false;

var tile_id = -1;

var flashing = false;

@onready var tile_sprite = %TileSprite;
@onready var tile_body = %TileRigidBody2D;
@onready var tile_sprite_holder = %TileSpriteHolder;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flashing:
		var sprite_scale = tile_sprite_holder.scale;
		if sprite_scale.x > 1.0:
			sprite_scale.x -= 0.8*delta;
			sprite_scale.y -= 0.8*delta;
			tile_sprite_holder.scale = sprite_scale;
		else:
			flashing = false;
			tile_sprite_holder.scale = Vector2(1.0, 1.0);

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

func flash_tile():
	flashing = true;
	tile_sprite_holder.scale = Vector2(1.3, 1.3);
