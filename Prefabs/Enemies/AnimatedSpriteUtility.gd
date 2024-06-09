extends AnimatedSprite2D
class_name AnimatedSpriteUtility

@export var current_loop : StringName = &"Idle";
var running_transition_time : float = -10.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	play(current_loop);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if running_transition_time > 0.0:
		running_transition_time -= delta;
	pass

func set_main_loop(s : StringName):
	current_loop = s;
	if running_transition_time <= 0.0:
		play(current_loop);
	
func run_transition(s : StringName, duration : float):
	running_transition_time = duration;
	play(s);	
	
func run_transition_backwards(s : StringName, duration : float):
	running_transition_time = duration;
	play_backwards(s);	
	
