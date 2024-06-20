extends Camera2D
class_name Player

static var GameStarted : bool = false;
static var CurrentX : float = 0.0;
static var CameraX : float = 0.0;
@export var BulletPrefab : PackedScene;
@export var LaserCrossPrefab : PackedScene;
@export var ExplosionPrefab : PackedScene;
@export var uiRef : PlayerUI;
const FORCEFIELD_TIME : float = 15.0;
const FORCEFIELD_NEGATE_TIME : float = 5.0;
var forcefieldChargeTime : float = 0.0;  #Variable to determine the percentage
var forcefieldNegateTime : float = -1.0;  #If you mis-use it, it gets frozen

static var Health : int = 6;
static var Score : int = 0;
static var SelectedBullet : int = 0;
var _last_score : int = -1;
var _last_health : int = -1;
var last_delta_time = 0.0;
var bullet_stream_timer = 0.0;

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
	if _last_score != SaveData.Score:
		uiRef.set_score(SaveData.Score);
		_last_score = SaveData.Score;

	if Input.is_action_just_pressed("Forcefield"):
		forcefield_button_on = true;
	if Input.is_action_just_released("Forcefield"):	
		forcefield_button_on = false;
	if forcefield_button_on == true: #Forcefield button on, rechrage
		forcefieldChargeTime -= delta * 2.0;
		if forcefieldChargeTime < 0.0:
			forcefieldNegateTime = FORCEFIELD_NEGATE_TIME;
			get_node("RigidBody2D/ForcefieldOverlay").play(&"shatter")
			get_node("RigidBody2D/ForcefieldOverlay").scale = Vector2(1.0, 1.0);
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
	
	if Engine.time_scale < 0.1:  #Game is paused
		return;
	last_delta_time = delta;
	if damage_routine == true:
		run_damage_flash();
	set_ui_elements(delta);
		
	var width : float = get_viewport_rect().size.x;
	CurrentX = global_position.x + width;
	CameraX = global_position.x;
	if SceneVars.FreezeMovement == false:
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
		get_node("RigidBody2D/ForcefieldOverlay").play(&"default")
		get_node("RigidBody2D/ForcefieldOverlay").scale = Vector2(2.0, 2.0);
	else:
		if forcefieldNegateTime <= 0.0:
			get_node("RigidBody2D/ForcefieldOverlay").visible = false;
		
	if Player.SelectedBullet == 1 and touchHeldDown:
		if SaveData.Ammo1 > 0:
			uiRef.update_ammo_text();
			bullet_stream_timer += delta;
			if bullet_stream_timer > 0.1:
				SaveData.Ammo1 -= 1;
				SoundFX.PlaySound("Pistol", get_tree(), global_position);
				create_bullet_instance(BulletPrefab, currentInput.position);
				bullet_stream_timer = 0.0;

func create_bullet_instance(prefab : PackedScene, screenPos : Vector2):
	var canvas_pos = get_viewport().get_canvas_transform().affine_inverse() * screenPos
	var instance = prefab.instantiate();
	instance.position = canvas_pos;
	add_child(instance)

func fire_bullet(screenPos : Vector2):
	if Engine.time_scale < 0.1:  #Game is paused
		return;
	if Player.SelectedBullet == 0:
		SoundFX.PlaySound("Pistol", get_tree(), global_position);
		create_bullet_instance(BulletPrefab, screenPos);
	if Player.SelectedBullet == 2:
		if SaveData.Ammo2 > 0:
			SaveData.Ammo2 -= 1;
			uiRef.update_ammo_text();
			SoundFX.PlaySound("LaserCross", get_tree(), global_position);
			create_bullet_instance(LaserCrossPrefab, screenPos);
	if Player.SelectedBullet == 3:
		if SaveData.Ammo3 > 0:
			SaveData.Ammo3 -= 1;
			uiRef.update_ammo_text();
			SoundFX.PlaySound("Shotgun", get_tree(), global_position);
			create_bullet_instance(ExplosionPrefab, screenPos);
	
var currentInput : InputEvent;
var touchHeldDown = false;

func _on_rigid_body_2d_input_event(viewport, event, shape_idx):
	currentInput = event;
	if event is InputEventMouseButton and event.pressed:
		fire_bullet(event.position);
		touchHeldDown = true;
	if event is InputEventScreenTouch and event.pressed:
		fire_bullet(event.position);
		touchHeldDown = true;
	if event is InputEventMouseButton and event.pressed == false:
		touchHeldDown = false;
	if event is InputEventScreenTouch and event.pressed == false:
		touchHeldDown = false;


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

