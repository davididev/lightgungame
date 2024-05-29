extends CanvasLayer
class_name PlayerUI;

var paused : bool = false;
var TEMP_PERCANTAGE : float = 0.0;  #for testing the forcefield UI

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(6);
	set_score(0);
	paused = false;
	update_pause_menu();
	#test_health();

#Delete this coroutine later
#func test_health():
	#set_health(6);
	#set_score(0);
	#await get_tree().create_timer(2.0).timeout;
	#set_health(5);
	#set_score(2);
	#await get_tree().create_timer(2.0).timeout;
	#set_health(4);
	#set_score(99);
	#await get_tree().create_timer(2.0).timeout;
	#set_health(3);
	#set_score(120);
	#await get_tree().create_timer(2.0).timeout;
	#set_health(2);
	#set_score(200);
	#await get_tree().create_timer(2.0).timeout;
	#set_health(1);
	#set_score(4333);
	#await get_tree().create_timer(2.0).timeout;
	#set_health(0);
	#set_score(54333);
	#await get_tree().create_timer(2.0).timeout;
	
func update_pause_menu():
	if paused == false:
		Engine.time_scale = 1.0;
	else:
		Engine.time_scale = 0.0;
	
	get_node("Pause Window").visible = paused;
	if paused:
		set_pause_panel(0);
	
func set_pause_panel(id : int):
	for n in range(0, 3, 1):
		print("Setting pause panel ", n)
		var actual_string = str("Pause Window/Panel", n);
		get_node(actual_string).visible = n == id;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Delete these later, they will need to be replaced by real game vars
	#TEMP_PERCANTAGE = TEMP_PERCANTAGE + (delta / 15.0);  #takes 15 seconds to recharge
	#TEMP_PERCANTAGE = clampf(TEMP_PERCANTAGE, 0.0, 1.0)
	#set_forcefield_perc(TEMP_PERCANTAGE);
	if Input.is_action_just_pressed("Pause"):
		_on_pause_button_pressed();

func set_health(h : int):
	for n in range(0, 6, 1):
		#var format_string = "HealthBG/Unit%n";
		var actual_string = str("HealthBG/Unit", n);
		get_node(actual_string).visible = ((h-1) >= n);

func set_score(s : int):
	get_node("ScoreLabel").text = "Score: %010d" % [s]


func set_forcefield_perc(perc : float):
	if perc == 0.0:
		get_node("ForcefieldChargeBG/ForcefieldChargeFG").visible = false;
	else:
		get_node("ForcefieldChargeBG/ForcefieldChargeFG").visible = true;
	var s = get_node("ForcefieldChargeBG/ForcefieldChargeFG").size;
	s.x = 180.0 * perc;
	get_node("ForcefieldChargeBG/ForcefieldChargeFG").size = s;


func _on_pause_button_pressed():
	paused = !paused;
	update_pause_menu();


func _back_to_main_pause_panel():
	set_pause_panel(0);
	
func _quit_game():
	#TODO: Add save feature
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn");


func unpause_game():
	paused = false;
	update_pause_menu();


func _go_to_settings_panel():
	set_pause_panel(1);


func _save_and_quit_confirm_panel():
	set_pause_panel(2);

@onready var _bus1 := AudioServer.get_bus_index(&"Master")
@onready var _bus2 := AudioServer.get_bus_index(&"Music")
@onready var _bus3 := AudioServer.get_bus_index(&"SoundFX")

func _on_change_volume_global(value):
	var actual_str = str("[right]Global Volume: [color=yellow]", value, "%")
	get_node("Pause Window/Panel1/Volume_Global_Label").text = actual_str;
	AudioServer.set_bus_volume_db(_bus1, linear_to_db(value / 100.0));


func _on_change_volume_music(value):
	var actual_str = str("[right]Music Volume: [color=yellow]", value, "%")
	get_node("Pause Window/Panel1/Volume_Music_Label").text = actual_str;
	AudioServer.set_bus_volume_db(_bus2, linear_to_db(value / 100.0));


func _on_change_volume_fx(value):
	var actual_str = str("[right]Sound FX Volume: [color=yellow]", value, "%")
	get_node("Pause Window/Panel1/Volume_FX_Label").text = actual_str;
	AudioServer.set_bus_volume_db(_bus3, linear_to_db(value / 100.0));
