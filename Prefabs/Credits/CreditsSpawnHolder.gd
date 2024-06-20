extends Node2D

@export var header_credits : PackedScene;
@export var entry_credits : PackedScene;
@export var source : CreditsRoot;

# Called when the node enters the scene tree for the first time.
func _ready():
	start_routine();

var counter = 0;

func start_routine():
	await get_tree().create_timer(1.0).timeout;
	for category in source.Entries:
		var s1 : String = category.Category;
		var instance1 = header_credits.instantiate();
		instance1.global_position = get_node("SpawnHeader").global_position;
		instance1.SetRigidText(s1);
		add_child(instance1);
		
		for entry in category.Entries:
			var s2 : String = entry;
			var instance2 = entry_credits.instantiate();
			instance2.global_position = get_node(str("Spawn", counter)).global_position;
			counter += 1;
			if counter > 2:
				counter = 0;
			instance2.SetRigidText(s2);
			add_child(instance2);
			await get_tree().create_timer(5.0).timeout;
	
	var instance3 = header_credits.instantiate();
	instance3.global_position = get_node("SpawnHeader").global_position;
	instance3.SetRigidText("Thanks for playing!");
	add_child(instance3);		
	await get_tree().create_timer(5.0).timeout;
	
	SaveData.CurrentLevel = "TitleScreen";
	get_tree().change_scene_to_file("res://Scenes/Loading.tscn");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
