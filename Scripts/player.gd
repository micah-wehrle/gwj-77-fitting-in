extends CharacterBody2D

const tile_size = 100;
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player_shape = %PlayerShape; #currently unused
@onready var player_sprite = %PlayerSprite1; 

var cur_shape = 0;
const max_shape_id = 2;

const shape_id_as_str = ['square', 'triangle', 'circle'];

var is_gravity_inverted = false;

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

	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("tab"):
		morph_next_shape();
	
	if Input.is_action_just_pressed("up"):
		if shape_id_as_str[cur_shape] == 'triangle':
			if (is_on_floor() and !is_gravity_inverted) or (is_on_ceiling() and is_gravity_inverted):
				is_gravity_inverted = !is_gravity_inverted;

func set_shape(shape_id): #currently the shape frame. from 0, they are square, triangle, circle
	if shape_id >= 0 and shape_id <= 2:
		player_sprite.frame = shape_id;

func morph_next_shape():
	if !is_on_floor():
		return;
	cur_shape += 1;
	if cur_shape > max_shape_id:
		cur_shape = 0;
	set_shape(cur_shape);
