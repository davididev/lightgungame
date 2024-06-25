extends RigidBody2D

@export var Health = 25;
@export var Anim_Ref : NodePath;
@export var SubEnemy : PackedScene;
@export var MuzzleFlare : PackedScene;

var awaiting_enemies = false;  #Force invincibility if enemies are present.

signal on_shot;

var invincible : bool = false;
var blink_step_timer : float = 0.0;
var invincible_timer : float = 0.0;
const BLINK_DAMAGE_TIME = 20.0 * BLINK_TIMER;  #How long it should be "invincible" when they die
const BLINK_TIMER = 0.1;  #How long to wait in between blinks before alternating to off and on
var just_shot = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	main_routine();
	get_node(Anim_Ref).play(&"default");

func _on_on_shot():
	if invincible == true:
		return;
	if Health <= 0:
		return;
	
	just_shot = true;
	Health -= 1;
	
	invincible = true;
	invincible_timer = BLINK_DAMAGE_TIME;

func main_routine():
	while Health > 0:
		while just_shot == false:  #Idle until shot
			await get_tree().create_timer(0.5).timeout;
			if Health <= 0:
				break;
		
		if Health <= 0:
			break;
		just_shot = false;
		awaiting_enemies = true;
		
		for n in range(0, 4, 1):
			var pos = get_node(str("CollisionShape2D/SpawnPoint", n)).global_position;
			var instance = SubEnemy.instantiate();
			instance.global_position = pos;
			add_child(instance);
		
		while BossBatSpawn.Count > 0:
			await get_tree().create_timer(2.0).timeout;
			if Health <= 0:
				break;
			var instance2 = MuzzleFlare.instantiate();
			instance2.global_position = global_position + Vector2(0.0, -64.0);
			add_child(instance2);
			await get_tree().create_timer(5.0).timeout;
			
		if Health <= 0:
			break;
		awaiting_enemies = false;
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if awaiting_enemies == true:
		invincible_timer = 0.1;  #Keep it invincible if enemies are spawned
	run_blink(delta);

func run_blink(delta):
	if invincible_timer > 0.0:
		invincible_timer -= delta;
		if invincible_timer < 0.0:
			get_node(Anim_Ref).visible = true;
			invincible = false;
			if Health <= 0:
				SaveData.CurrentLevel = SceneVars.NextScene;
				SavaData.SaveFile();
				SceneVars.EndedLevel = true;
				SceneVars.FreezeMovement = true; 
				queue_free();
		else:
			blink_step_timer += delta;
			if blink_step_timer > BLINK_TIMER:
				get_node(Anim_Ref).visible = !get_node(Anim_Ref).visible;
				blink_step_timer -= BLINK_TIMER;
