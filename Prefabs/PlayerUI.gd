extends CanvasLayer
class_name PlayerUI;

var paused : bool = false;
var TEMP_PERCANTAGE : float = 0.0;  #for testing the forcefield UI
static var Update_Ammo_UI : bool = false;  #When set to true by external script, it updates all the ammo text
var end_level_routine : bool = false;
const END_LEVEL_ANIMATION_TIME = 2.0;
static var ToggleTutorialConfirm : bool = false;  #When set to true by external script, asks you to skip tutorial
static var TutorialOverlayText : String = "";  #When set to true by external script, it displays a text overlay
static var TutorialOverlayTimer : float = 10.0;
static var TutorialOverlayArrow : int = -1;  #This should be set BEFORE overlay text
static var BeginTutorial : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(6);
	set_score(SaveData.Score);
	
	update_ammo_text();
	set_ammo_id(0);
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

func on_confirm_skip_tutorial():
	SaveData.CurrentLevel = "Bonus1";
	SavaData.SaveFile();
	get_tree().change_scene_to_file("res://Scenes/Loading.tscn");
	
	
func update_ammo_text():
	get_node("MainWindow/AmmoMachine").text = "%04d" % SavaData.Ammo1;
	get_node("MainWindow/AmmoCross").text = "%03d" % SavaData.Ammo2;
	get_node("MainWindow/AmmoExplosion").text = "%02d" % SavaData.Ammo3;
	
func set_ammo_id(id : int):
	get_node("MainWindow/CheckBoxSingle").button_pressed = (id == 0);
	get_node("MainWindow/CheckBoxMachineGun").button_pressed = (id == 1);
	get_node("MainWindow/CheckBoxLaserCross").button_pressed = (id == 2);
	get_node("MainWindow/CheckBoxExplosion").button_pressed = (id == 3);
	Player.SelectedBullet = id;
	
func update_pause_menu():
	if paused == false:
		Engine.time_scale = 1.0;
	else:
		Engine.time_scale = 0.0;
	
	get_node("Pause Window").visible = paused;
	if paused:
		set_pause_panel(0);
	
func set_pause_panel(id : int):
	for n in range(0, 4, 1):
		print("Setting pause panel ", n)
		var actual_string = str("Pause Window/Panel", n);
		get_node(actual_string).visible = n == id;

func EndLevelRoutine():
	end_level_routine = true;
	get_node("AnimationPlayer").play(&"PlayEndLevel");
	await get_tree().create_timer(END_LEVEL_ANIMATION_TIME).timeout
	SceneVars.FreezeMovement = false;
	get_tree().change_scene_to_file("res://Scenes/Loading.tscn");
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if SceneVars.EndedLevel == true and end_level_routine == false:
		EndLevelRoutine();
		
	
	if Update_Ammo_UI:
		Update_Ammo_UI = false;
		update_ammo_text();
	if Input.is_action_just_pressed("Pause"):
		_on_pause_button_pressed();
	if Input.is_action_just_pressed("SelectAmmo1"):
		set_ammo_id(0);
	if Input.is_action_just_pressed("SelectAmmo2"):
		set_ammo_id(1);
	if Input.is_action_just_pressed("SelectAmmo3"):
		set_ammo_id(2);
	if Input.is_action_just_pressed("SelectAmmo4"):
		set_ammo_id(3);
	
	tutorial_updates();
	
	
func tutorial_updates():
	if ToggleTutorialConfirm:
		ToggleTutorialConfirm = false;
		paused = true;
		update_pause_menu();
		set_pause_panel(3);
	if TutorialOverlayText != "":
		var thisStepsArrows = TutorialOverlayArrow;
		TutorialOverlayArrow = -1;
		get_node("TutorialText").text = str("[center]", TutorialOverlayText);
		TutorialOverlayText = "";
		if thisStepsArrows > -1:
			var node_name = str("TutorialArrow", thisStepsArrows);
			get_node(node_name).visible = true;
		await get_tree().create_timer(TutorialOverlayTimer).timeout;
		get_node("TutorialText").text = "";
		if thisStepsArrows > -1:
			var node_name = str("TutorialArrow", thisStepsArrows);
			get_node(node_name).visible = false;
	
func set_health(h : int):
	for n in range(0, 6, 1):
		#var format_string = "HealthBG/Unit%n";
		var actual_string = str("HealthBG/Unit", n);
		get_node(actual_string).visible = ((h-1) >= n);

func set_score(s : int):
	get_node("ScoreLabel").text = "Score: %010d" % [s]
	SaveData.Score = s;


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




func _on_check_box_single_button_up():
	set_ammo_id(0);

func _on_check_box_machine_gun_button_up():
	set_ammo_id(1);

func _on_check_box_laser_cross_button_up():
	set_ammo_id(2);

func _on_check_box_explosion_button_up():
	set_ammo_id(3);


func _on_continue_tutorial():
	set_pause_panel(-1);
	BeginTutorial = true;
	paused = false;
	update_pause_menu();
