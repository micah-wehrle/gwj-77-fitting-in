extends CharacterBody2D

const tile_size = 100;
const SPEED = 500.0
const JUMP_VELOCITY = -700.0

const BOUNCE_DAMP = 0.5;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")*1.8;

@onready var player_shape = %PlayerShape; #currently unused
@onready var player_sprite = %PlayerSprite1; 
@onready var left_wall_detector = %LeftWallDetector;
@onready var right_wall_detector = %RightWallDetector;
@onready var floor_detector = %FloorDetector;
@onready var ceiling_detector = %CeilingDetector;

var cur_shape = 0;
const max_shape_id = 2;

const shape_id_as_str = ['square', 'triangle', 'circle'];

var is_gravity_inverted = false;

var last_y_vel = 0;

func _ready(): 
	# setup shapes
	
	pass;


func _physics_process(delta):
	# Add the gravity.
	if (is_on_floor() and is_gravity_inverted) or (is_on_ceiling() and !is_gravity_inverted) or (!is_on_floor() and !is_on_floor()):
		velocity.y += gravity * delta * (-1 if is_gravity_inverted else 1);

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() and !is_gravity_inverted) or (is_on_ceiling() and is_gravity_inverted):
			velocity.y = JUMP_VELOCITY * (-1 if is_gravity_inverted else 1);

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if shape_id_as_str[cur_shape] == 'circle':
		if !is_on_floor():
			last_y_vel = velocity.y;
		elif last_y_vel != 0:
			
			if abs(last_y_vel) > abs(JUMP_VELOCITY*1.5):
				velocity.y = -last_y_vel;
				if Input.is_action_pressed("down"):
					velocity.y *= BOUNCE_DAMP;
				else:
					var unclean_surfaces_result = get_unclean_surfaces();
					if unclean_surfaces_result.size() > 0:
						for body in unclean_surfaces_result:
							body.flash_tile();
						velocity.y *= BOUNCE_DAMP;
			elif abs(last_y_vel) > abs(JUMP_VELOCITY*1.25):
				velocity.y = -last_y_vel*BOUNCE_DAMP;
			last_y_vel = 0;

	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("tab"):
		morph_next_shape();
	
	if shape_id_as_str[cur_shape] == 'triangle' and (Input.is_action_just_pressed("up") or (Input.is_action_just_pressed("down") and is_on_ceiling())):
		if (is_on_floor() and !is_gravity_inverted) or (is_on_ceiling() and is_gravity_inverted):
			# this needs to be smarter to prevent hanging off the edge
			var unclean_surfaces_result = get_unclean_surfaces();
			if unclean_surfaces_result.size() > 0:
				for body in unclean_surfaces_result:
					body.flash_tile();
			else:
				invert_gravity();
	
	if shape_id_as_str[cur_shape] == 'circle' and Input.is_action_pressed("up"):
		if Input.is_action_pressed("right"):
			for body in right_wall_detector.get_overlapping_bodies():
				if 'tile_id' in body.get_parent():
					if body.get_parent().tile_id == 1:
						velocity.y = -300.0;
		elif Input.is_action_pressed("left"):
			for body in left_wall_detector.get_overlapping_bodies():
				if 'tile_id' in body.get_parent():
					if body.get_parent().tile_id == 1:
						velocity.y = -300.0;

func set_shape(shape_id): #currently the shape frame. from 0, they are square, triangle, circle
	if shape_id >= 0 and shape_id <= 2:
		player_sprite.frame = shape_id;

func morph_next_shape():
	#if !is_on_floor() or is_gravity_inverted:
		#return;
	if shape_id_as_str[cur_shape] == "triangle":
		if is_gravity_inverted:
			invert_gravity();
	
	cur_shape += 1;
	if cur_shape > max_shape_id:
		cur_shape = 0;
	set_shape(cur_shape);

func get_standing_surfaces():
	if !is_gravity_inverted:
		return floor_detector.get_overlapping_bodies();
	else:
		return ceiling_detector.get_overlapping_bodies();

func get_unclean_surfaces():
	var unclean_surfaces = [];
	for body in get_standing_surfaces():
		if 'tile_id' in body.get_parent():
			if body.get_parent().tile_id == 2:
				unclean_surfaces.push_back(body.get_parent());
	return unclean_surfaces;

func invert_gravity():
	is_gravity_inverted = !is_gravity_inverted;
	player_sprite.flip_v = is_gravity_inverted;
