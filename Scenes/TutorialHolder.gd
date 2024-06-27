extends Node2D

var is_mobile = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerUI.ToggleTutorialConfirm = true;
	if OS.get_name() == "Android":
		is_mobile = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PlayerUI.BeginTutorial == true:
		PlayerUI.BeginTutorial = false;
		TutorialRoutine();


func TutorialRoutine():
	#Step 1- how to fire
	var step_time = 3.0;
	PlayerUI.TutorialOverlayTimer = step_time;
	if is_mobile:
		PlayerUI.TutorialOverlayText = "Tap to fire";
	else:
		PlayerUI.TutorialOverlayText = "Click to fire";
	await get_tree().create_timer(step_time).timeout;
	
	#Step 2- ammo boxes
	step_time = 8.0;
	PlayerUI.TutorialOverlayTimer = step_time;
	PlayerUI.TutorialOverlayText = "These boxes contain ammo for special weapons.  Fire to open it.";
	get_node("AmmoBox0").visible = true;
	await get_tree().create_timer(step_time).timeout;
	
	while SaveData.Ammo1 == 0:
		await get_tree().create_timer(0.05).timeout;

	#Step 3: select ammo
	step_time = 20.0;
	PlayerUI.TutorialOverlayArrow = 0;
	PlayerUI.TutorialOverlayTimer = step_time;
	if is_mobile:
		PlayerUI.TutorialOverlayText = "[color=yellow]Tap here[/color] to select the machine gun.  If you run out of ammo, [color=yellow]select the infinite[/color] one to the left.";
	else:
		PlayerUI.TutorialOverlayText = "[color=yellow]Press 2[/color] on the keyboard or [color=yellow]click here[/color] to select the machine gun.  If you run out of ammo, [color=yellow]click[/color] the infinite one to the left (or [color=yellow]press 1[/color])";
	await get_tree().create_timer(step_time).timeout;

	if is_mobile:
		PlayerUI.TutorialOverlayText = "Each type does the same damage, but each behaves specially.  For instance, the  [color=yellow]machine gun lets you keep firing when you hold down your finger[/color]";
	else:
		PlayerUI.TutorialOverlayText = "Each type does the same damage, but each behaves specially.  For instance, the  [color=yellow]machine gun lets you keep firing when you hold down the mouse[/color]";
	
	PlayerUI.TutorialOverlayTimer = step_time;
	await get_tree().create_timer(step_time).timeout;
	#Step 4: Shoot enemies
	get_node("Target0").visible = true;
	get_node("Target1").visible = true;
	
	while SaveData.Score < 2:
		await get_tree().create_timer(0.05).timeout;

	#Step 4: select forcefield
	step_time = 20.0;
	PlayerUI.TutorialOverlayArrow = 1;
	PlayerUI.TutorialOverlayTimer = step_time;
	if is_mobile:
		PlayerUI.TutorialOverlayText = "Tap [color=yellow]‘Forcefield’[/color] to activate forcefield.  Use to block enemy shots.  [color=yellow]Watch the forcefield bar[/color]- don’t shatter it.";
	else:
		PlayerUI.TutorialOverlayText = "Press [color=yellow]F[/color] or [color=yellow]click ‘Forcefield’[/color] to activate forcefield. Use to block enemy shots.  [color=yellow]Watch the forcefield bar[/color]- don’t shatter it.";
	await get_tree().create_timer(step_time).timeout;

	SaveData.NewFile(SaveData.File_ID);  #Reset score and ammo
	PlayerUI.Update_Ammo_UI = true;
	SaveData.CurrentLevel = "Bonus1";
	
	step_time = 8.0;
	PlayerUI.TutorialOverlayTimer = step_time;
	PlayerUI.TutorialOverlayText = "You are ready to play.  Good luck!";
	await get_tree().create_timer(step_time).timeout;
	SavaData.SaveFile();
	get_tree().change_scene_to_file("res://Scenes/Loading.tscn");
