extends Camera2D
class_name Player

static var GameStarted : bool = false;
static var CurrentX : float = 0.0;
static var CameraX : float = 0.0;
@export var BulletPrefab : PackedScene;
@export var uiRef : PlayerUI;
const FORCEFIELD_TIME : float = 15.0;
const FORCEFIELD_NEGATE_TIME : float = 5.0;
var forcefieldChargeTime : float = 0.0;  #Variable to determine the percentage
var forcefieldNegateTime : float = -1.0;  #If you mis-use it, it gets frozen

static var Health : int = 6;
static var Score : int = 0;
var _last_score : int = -1;
var _last_health : int = -1;

# Called when the node enters the scene tree for the first time.
func _ready():
	GameStarted = true;
	Health = 6;
	pass # Replace with function body.

func set_ui_elements(delta):
	#Set Health if changed
	if _last_health != Health:
		uiRef.set_health(Health);
		_last_health = Health;
	
	#Set Score if changed
	if _last_score != Score:
		uiRef.set_score(Score);
		_last_score = Score;

	if forcefield_button_on == true: #Forcefield button on, rechrage
		forcefieldChargeTime -= delta * 2.0;
		if forcefieldChargeTime < 0.0:
			forcefieldNegateTime = FORCEFIELD_NEGATE_TIME;
			forcefieldChargeTime = -0.01;
			forcefield_button_on = false;  #Forcefield broke, turn it off
	else: #Forcefield button off, rechrage
		if forcefieldNegateTime >= 0.0:
			forcefieldChargeTime = 0.0;
			forcefieldNegateTime -= delta;
		else:
			forcefieldChargeTime += delta;
			if forcefieldChargeTime > FORCEFIELD_TIME:
				forcefieldChargeTime = FORCEFIELD_TIME;
	
	uiRef.set_forcefield_perc(forcefieldChargeTime / FORCEFIELD_TIME);

func run_damage_flash():
	damage_routine = false;
	get_node("CanvasLayer/FlashImage").visible = true;
	await get_tree().create_timer(0.05).timeout;
	get_node("CanvasLayer/FlashImage").visible = false;

var  jiggle_shape : bool = true;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameStarted == false: 
		pass;
	
	if damage_routine == true:
		run_damage_flash();
	set_ui_elements(delta);
		
	var width : float = get_viewport_rect().size.x;
	CurrentX = global_position.x + width;
	CameraX = global_position.x;
	var my_pos = position;
	my_pos.x += SceneVars.MoveSpeed * delta;
	position = my_pos;
	
	if jiggle_shape == true:
		get_node("RigidBody2D").position = Vector2(0.0, 1.0)
	else:
		get_node("RigidBody2D").position = Vector2(0.0, 0.0)
	jiggle_shape = !jiggle_shape;
	
	if forcefield_button_on == true: #Forcefield button on, do overlay
		get_node("RigidBody2D/ForcefieldOverlay").visible = true;
	else:
		get_node("RigidBody2D/ForcefieldOverlay").visible = false;

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

static var forcefield_button_on : bool = false;  #So we can handle damage as a static function
static var damage_routine : bool = false;  #So we can handle damage as a static function

static func Damage(amt : int):
	if forcefield_button_on == false:  #Only damage is forcefield is inactive
		Health -= amt;
		damage_routine = true;
		

func _on_forcefield_button_button_down():
	forcefield_button_on = true;


func _on_forcefield_button_button_up():
	forcefield_button_on = false;

