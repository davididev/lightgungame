extends RigidBody2D

@export var PointsOnShoot = 5;
@export var health = 1;
@export var anim_ref : NodePath;
@export var move_left_timer : float = 1.5;  #how many seconds to move left
@export var move_right_timer : float = 1.0;  #how many seconds to move right
@export var velocity_x : float = 64.0;
@export var muzzleFlarePath : NodePath = "CollisionShape2D/MuzzleFlare";
@export var fireSoundFX : String = "Area51Fire";

@export var attack_animation_time : float;
@export var turn_animation_time : float;
@export var death_animation_offset : Vector2;

signal on_shot

var damage_delay : bool = false;  #Don't let enemy deplete health after being shot
const BLINK_COUNT = 20;
const BLINK_TIMER = 0.1;  #How long to wait in between blinks before alternating to off and on

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(anim_ref).set_main_loop(&"Idle");
	pass # Replace with function body.

func when_visible():
	main_routine();

func RunBlink():
	damage_delay = true;
	var blinkVisibility : bool = false;
	for i in range(0, BLINK_COUNT, 1):
		get_node(anim_ref).visible = blinkVisibility;
		blinkVisibility = !blinkVisibility;
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
		SetMoveDir(0.0);
		get_node(anim_ref).flip_h = false;
		get_node(anim_ref).run_transition(&"Die", 2.0);
		get_node(anim_ref).offset = death_animation_offset;
		SaveData.Score += PointsOnShoot;
		var instance2 : AddScore = preload("res://Prefabs/Preload/AddScore.tscn").instantiate();
		instance2.set_label(PointsOnShoot);
		instance2.global_position = global_position;
		get_tree().root.get_node("Node2D").add_child(instance2);
	RunBlink();
		

var vec : Vector2;
func SetMoveDir(dir : float):
	vec = linear_velocity;
	vec.x =  velocity_x * dir;
	#vec.y = 1.0;  #Keep the capsule from getting stuck, not sure why this doesn't happen naturally
	

func main_routine():
	while health > 0:
		get_node(anim_ref).flip_h = false;
		SetMoveDir(-1.0);
		if health <= 0:
			return;
		get_node(anim_ref).flip_h = false;
		get_node(anim_ref).set_main_loop(&"Walk");
		await get_tree().create_timer(move_left_timer).timeout;
		SetMoveDir(0.0);
		if health <= 0:
			return;
		
		
		
		#Attack #1
			#Turn to left
		get_node(anim_ref).run_transition(&"Turn", turn_animation_time);
		get_node(anim_ref).flip_h = false;
		await get_tree().create_timer(turn_animation_time).timeout;
		
			#Run attack animation
		if health <= 0:
			return;
		get_node(anim_ref).run_transition(&"Attack", attack_animation_time);	
		await get_tree().create_timer(attack_animation_time / 2.0).timeout;
		if health <= 0:
			return;
			#Create muzzle flare here
		get_node(muzzleFlarePath).visible = true;
		get_node(muzzleFlarePath).play("Fire");
		SoundFX.PlaySound(fireSoundFX, get_tree(), global_position);
		Player.Damage(1);
			#Turn to right
		get_node(anim_ref).run_transition_backwards(&"Turn", turn_animation_time);
		get_node(anim_ref).flip_h = true;
		await get_tree().create_timer(turn_animation_time).timeout;
		get_node(muzzleFlarePath).visible = false;
		
		
		if health <= 0:
			return;
		SetMoveDir(1.0);
		get_node(anim_ref).set_main_loop(&"Walk");
		await get_tree().create_timer(move_right_timer).timeout;
	
		#Attack #2
		if health <= 0:
			return;
		SetMoveDir(0.0);
	
			#Turn to right
		get_node(anim_ref).flip_h = true;
		get_node(anim_ref).run_transition(&"Turn", turn_animation_time);
		await get_tree().create_timer(turn_animation_time).timeout;
			#Run attack
		get_node(anim_ref).run_transition(&"Attack", attack_animation_time);	
		await get_tree().create_timer(attack_animation_time / 2.0).timeout;
		if health <= 0:
			return;
		#Create muzzle flare here
		get_node(muzzleFlarePath).visible = true;
		get_node(muzzleFlarePath).play("Fire");
		SoundFX.PlaySound(fireSoundFX, get_tree(), global_position);
		Player.Damage(1);
		await get_tree().create_timer(attack_animation_time / 2.0).timeout;
			#Turn to left
		get_node(muzzleFlarePath).visible = false;
		get_node(anim_ref).flip_h = false;	
		get_node(anim_ref).run_transition_backwards(&"Turn", turn_animation_time);
		await get_tree().create_timer(turn_animation_time).timeout;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity = vec;
