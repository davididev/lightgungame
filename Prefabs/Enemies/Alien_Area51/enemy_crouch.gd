extends RigidBody2D
@export var PointsOnShoot = 5;
@export var health = 1;
@export var anim_ref : AnimatedSpriteUtility;
@export var crouch_animation_time : float;
@export var attack_animation_time : float;
@export var death_animation_offset : Vector2;
@export var muzzleFlarePath : NodePath = "CollisionShape2D/MuzzleFlare";
@export var fireSoundFX : String = "Area51Fire";

var covered = true;
signal on_shot

var damage_delay : bool = false;  #Don't let enemy deplete health after being shot
const BLINK_COUNT = 20;
const BLINK_TIMER = 0.1;  #How long to wait in between blinks before alternating to off and on

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_ref.set_main_loop(&"CrouchIdle");

func _on_become_visible():  #SHould be called by visibility notifier
	main_routine();
	
func main_routine():
	while health > 0:
		#stand up
		covered = true;
		anim_ref.run_transition(&"CrouchUp", crouch_animation_time);
		await get_tree().create_timer(crouch_animation_time / 2.0).timeout;
		covered = false;
		await get_tree().create_timer(crouch_animation_time / 2.0).timeout;
		
		
		if health <= 0:
			return;
		#Idle for .5 seconds
		anim_ref.set_main_loop(&"Idle");
		await get_tree().create_timer(1.0).timeout;
		
		#Attack
			#Play animation
		if health <= 0:
			return;
		anim_ref.run_transition(&"Attack", attack_animation_time);
		await get_tree().create_timer(attack_animation_time / 2.0).timeout;
		
			#Run attack (add muzzle flare later)
		get_node(muzzleFlarePath).visible = true;
		get_node(muzzleFlarePath).play("Fire");
		SoundFX.PlaySound(fireSoundFX, get_tree(), global_position);
		if health <= 0:
			return;
		Player.Damage(1);
		await get_tree().create_timer(attack_animation_time / 2.0).timeout;
		get_node(muzzleFlarePath).visible = false;
		#Crouch back down
		if health <= 0:
			return;
		anim_ref.run_transition(&"CrouchDown", crouch_animation_time);
		await get_tree().create_timer(crouch_animation_time / 2.0).timeout;
		if health <= 0:
			return;
		covered = true;
		await get_tree().create_timer(crouch_animation_time / 2.0).timeout;
		if health <= 0:
			return;
			
		#Stay crouched down for 1 second
		anim_ref.set_main_loop(&"CrouchIdle");
		await get_tree().create_timer(1.0).timeout;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func when_shot():
	if damage_delay:
		return;
	if covered:
		return;
	health -= 1;
	if health == 0:
		anim_ref.flip_h = false;
		anim_ref.run_transition(&"Die", 2.0);
		anim_ref.offset = death_animation_offset;
		SaveData.Score += PointsOnShoot;
		var instance2 : AddScore = preload("res://Prefabs/Preload/AddScore.tscn").instantiate();
		instance2.set_label(PointsOnShoot);
		instance2.global_position = global_position;
		get_tree().root.get_node("Node2D").add_child(instance2);
	RunBlink();

func RunBlink():
	damage_delay = true;
	var blinkVisibility : bool = false;
	for i in range(0, BLINK_COUNT, 1):
		anim_ref.visible = blinkVisibility;
		blinkVisibility = !blinkVisibility;
		await get_tree().create_timer(BLINK_TIMER).timeout;
	
	anim_ref.visible = true;
	damage_delay = false;

	if health == 0:
		queue_free();
