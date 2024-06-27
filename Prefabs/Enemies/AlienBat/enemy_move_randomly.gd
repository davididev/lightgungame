extends RigidBody2D
class_name BossBatSpawn;

@export var Health = 2;
@export var Anim_Ref : NodePath;
@export var Move_Speed = 128.0;
var current_direction : Vector2;
signal on_shot;
static var Count = 0;

var invincible : bool = false;
var blink_step_timer : float = 0.0;
var invincible_timer : float = 0.0;
const BLINK_DAMAGE_TIME = 20.0 * BLINK_TIMER;  #How long it should be "invincible" when they die
const BLINK_TIMER = 0.1;  #How long to wait in between blinks before alternating to off and on
const SCALE_UP_PER_SECOND = 0.10;
var TARGET_SCALE = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	Count += 1;
	TARGET_SCALE = get_node(Anim_Ref).scale.x;
	get_node(Anim_Ref).scale = Vector2(0.01, 0.01);
	var randx = randi_range(-2, 2);
	if randx == 0:
		randx = 2;
	var randy = randi_range(-2, 2);
	if randy == 0:
		randy = -2;
	var vx = randx * 0.5;
	var vy = randy * 0.5;
	current_direction = Vector2(vx, vy);
	get_node(Anim_Ref).set_main_loop(&"Idle");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Health > 0:
		linear_velocity = current_direction * Move_Speed;
	run_blink(delta);
	
	var s = get_node(Anim_Ref).scale.x;
	if s < TARGET_SCALE:
		s += SCALE_UP_PER_SECOND * delta;
		if s > TARGET_SCALE:
			s = TARGET_SCALE;
		get_node(Anim_Ref).scale = Vector2(s, s);

var first_count  = true;
func run_blink(delta):
	if invincible_timer > 0.0:
		invincible_timer -= delta;
		if invincible_timer < 0.0:
			get_node(Anim_Ref).visible = true;
			invincible = false;
			if Health <= 0:
				if first_count:
					Count -= 1;
					first_count = false;
				queue_free();
		else:
			blink_step_timer += delta;
			if blink_step_timer > BLINK_TIMER:
				get_node(Anim_Ref).visible = !get_node(Anim_Ref).visible;
				blink_step_timer -= BLINK_TIMER;
func _on_visible_left_screen_exited():
	if current_direction.x < 0.0:
		current_direction.x *= -1.0;


func _on_visible_right_screen_exited():
	if current_direction.x > 0.0:
		current_direction.x *= -1.0;


func _on_visible_up_screen_exited():
	if current_direction.y < 0.0:
		current_direction.y *= -1.0;


func _on_visible_down_screen_exited():
	if current_direction.y > 0.0:
		current_direction.y *= -1.0;


func _on_body_entered(body):
	var other_node : Node2D = body;
	current_direction = other_node.global_position - global_position;
	current_direction.normalized();
	pass # Replace with function body.


func _on_on_shot():
	if invincible == true:
		return;
	if Health <= 0:
		return;
		
	Health -= 1;
	
	invincible = true;
	invincible_timer = BLINK_DAMAGE_TIME;
	
	if Health <= 0:
		gravity_scale = 1.0;
		get_node(Anim_Ref).set_main_loop(&"Die");
	
