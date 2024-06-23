extends RigidBody2D

@export var anim_ref : NodePath;
@export var health = 1;
@export var PointsOnShoot = 5;
@export var speed_left = 80.0;
@export var degrees_per_second = 360.0;
@export var wave_height = 90.0;
@export var attack_duration = 1.0;
@export var death_animation_offset : Vector2;
var routine_started = false;
var current_degrees = 0.0;

var damage_delay : bool = false;  #Don't let enemy deplete health after being shot
const BLINK_COUNT = 20;
const BLINK_TIMER = 0.1;  #How long to wait in between blinks before alternating to off and on
signal on_shot;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(anim_ref).set_main_loop(&"Idle");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if routine_started == true and health > 0:
		current_degrees += degrees_per_second * delta;
		var rad = deg_to_rad(current_degrees);
		
		var vel = Vector2.ZERO;
		vel.y = wave_height * cos(rad);
		vel.x = -speed_left;
		linear_velocity = vel;
	
func RunBlink():
	damage_delay = true;
	var blinkVisibility : bool = false;
	for i in range(0, BLINK_COUNT, 1):
		get_node(anim_ref).visible = blinkVisibility;
		blinkVisibility = !blinkVisibility;
		if get_tree() != null:
			await get_tree().create_timer(BLINK_TIMER).timeout;
	
	get_node(anim_ref).visible = true;
	damage_delay = false;

	if health == 0:
		queue_free();

func when_shot():
	if damage_delay:
		return;
	
	health -= 1;
	if health == 0:
		gravity_scale = 0.5;
		get_node(anim_ref).flip_h = false;
		get_node(anim_ref).run_transition(&"Die", 2.0);
		get_node(anim_ref).offset = death_animation_offset;
		SaveData.Score += PointsOnShoot;
		var instance2 : AddScore = preload("res://Prefabs/Preload/AddScore.tscn").instantiate();
		instance2.set_label(PointsOnShoot);
		instance2.global_position = global_position;
		get_tree().root.get_node("Node2D").add_child(instance2);
	RunBlink();

func when_visible():
	routine_started = true;

func when_far_left():
	AttackRoutine();
	
func AttackRoutine():
	
	get_node(anim_ref).run_transition(&"Attack", attack_duration);
	if get_tree() != null:
		await get_tree().create_timer(attack_duration / 2.0);
	if health > 0:
		Player.Damage(1);
	if get_tree() != null:
		await get_tree().create_timer(attack_duration / 2.0);
