extends RigidBody2D

@export var ExplosionParticle : PackedScene;
@export var ammoID : int = 1;
@export var ammoAmount : int = 10;
@export var forceLeft : float = 400.0;
@export var forceUp : float = 250.0;
@export var gravity_scale_on_seen : float = 1.0;

@export var ref_to_label : Label;
@export var ref_to_sprite : AnimatedSprite2D;

signal on_shot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var first_visible = false;

func _on_visible_on_screen_enabler_2d_screen_entered():
	first_visible = true;
	ref_to_sprite.play(&"default");
	var v = Vector2(-forceLeft, -forceUp);
	gravity_scale = gravity_scale_on_seen;
	apply_impulse(v);



func _on_on_shot():
	if ref_to_sprite.visible == true:  #Haven't shot it yet
		ref_to_sprite.visible = false;
		var part = ExplosionParticle.instantiate();
		part.global_position = global_position;
		add_child(part);
		
		if ammoID == 1:  #Machine gun
			SaveData.Ammo1 += ammoAmount;
			ref_to_label.text = "Machine Gun + %d" % ammoAmount;
		if ammoID == 2:  #Laser cross 
			SaveData.Ammo2 += ammoAmount;
			ref_to_label.text = "Laser Cross + %d" % ammoAmount;
		if ammoID == 3:  #Laser cross 
			SaveData.Ammo3 += ammoAmount;
			ref_to_label.text = "Explosion + %d" % ammoAmount;
		PlayerUI.Update_Ammo_UI = true;
		gravity_scale = 0.0;
		linear_velocity = Vector2.ZERO;
		await get_tree().create_timer(1.5).timeout;
		queue_free();


func _on_visible_on_screen_enabler_2d_screen_exited():
	if first_visible:  #it appeared and flew, delete it now that it's off screen
		queue_free();
