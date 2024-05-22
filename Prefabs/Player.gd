extends Camera2D

static var GameStarted : bool = false;
static var CurrentX : float = 0.0;
@export var BulletPrefab : PackedScene;


# Called when the node enters the scene tree for the first time.
func _ready():
	GameStarted = true;
	pass # Replace with function body.


var  jiggle_shape : bool = true;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameStarted == false: 
		pass;
	var width : float = get_viewport_rect().size.x;
	CurrentX = position.x - (width / 64.0);
	
	var my_pos = position;
	my_pos.x += 32.0 * delta;
	position = my_pos;
	
	if jiggle_shape == true:
		get_node("RigidBody2D").position = Vector2(0.0, 1.0)
	else:
		get_node("RigidBody2D").position = Vector2(0.0, 0.0)
	jiggle_shape = !jiggle_shape;

func fire_bullet(screenPos : Vector2):
	var canvas_pos = get_viewport().get_canvas_transform().affine_inverse() * screenPos
	var instance = BulletPrefab.instantiate();
	instance.position = canvas_pos;
	add_child(instance)
	

func _on_rigid_body_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		fire_bullet(event.position);
	if event is InputEventScreenTouch and event.pressed:
		fire_bullet(event.position);
