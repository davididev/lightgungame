extends Node2D

@export var Muzzle_Ref : NodePath;
@export var Lit_Ray_Ref : NodePath;
@export var MuzzleFlareDelay = 1.0;

const MIN_SCALE_X = 0.1;
const SCALE_X_PER_SECOND = 8.0; 

var delay_timer : float;

# Called when the node enters the scene tree for the first time.
func _ready():
	delay_timer = MuzzleFlareDelay;
	SoundFX.PlaySound("LightningPre", get_tree(), global_position);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delay_timer > 0.0:
		delay_timer -= delta;
		if delay_timer <= 0.0:
			SoundFX.PlaySound("Area51Fire", get_tree(), global_position);
			get_node(Lit_Ray_Ref).visible = true;
			get_node(Muzzle_Ref).visible = false;
			Player.Damage(1);
			
	else:
		var vec = get_node(Lit_Ray_Ref).scale;
		vec.x -= SCALE_X_PER_SECOND * delta;
		if vec.x < 0.1:
			queue_free();
		get_node(Lit_Ray_Ref).scale = vec;
