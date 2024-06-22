extends CanvasLayer

@export var Panels : Array[NinePatchRect];
@export var FileButtons : Array[Button];
var emptyFiles = [true, true, true, true];

# Called when the node enters the scene tree for the first time.
func _ready():
	#Player.Score = 0;  #Reset score when we go to the beginning of the game, may be reloaded later
	PlayMusic.PlaySong("Title", get_tree());
	SetPanelVisible(0);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SetPanelVisible(id : int):
	var i = 0;
	for entry in Panels:
		entry.visible = (i == id);
		i += 1;
	
	
	if id == 0:
		CreateFilesStr();
		
	if id == 2:
		LoadedFileStr();
		
func LoadedFileStr():
	var scoreText = "%010d" % [SaveData.Score];
	var stringToDisplay = str("[color=yellow]Current Level: [/color]", SaveData.CurrentLevel, "\n[color=yellow]Score: [/color]", scoreText)
	get_node("PanelLoadedFile/GameData").text = stringToDisplay;
	get_node("PanelLoadedFile/Header").text = SaveData.FileName;

func _go_to_main_panel():
	SetPanelVisible(0);

func CreateFilesStr():
	var fileID = 0;
	for button in FileButtons:
		var fileNameStr = "Empty";
		SaveData.File_ID = fileID;
		if SaveData.LoadFile() == true:
			fileNameStr = SavaData.FileName;
			emptyFiles[fileID] = false;
		else:
			emptyFiles[fileID] = true;
		var mystring = str("File ", (fileID+1), ": ", fileNameStr);
		button.text = mystring;
		fileID += 1;



func SelectFileID(fileID : int):
	SaveData.File_ID = fileID - 1;
	if SavaData.LoadFile() == true:  #File exists, load it
		SetPanelVisible(2);
	else:
		SetPanelVisible(1);

func _on_button_quit_button_down():
	get_tree().quit();


func _on_button_test_level_1_button_down():
	get_tree().change_scene_to_file("res://Scenes/Bonus1.tscn");


func _on_button_test_level_2_button_down():
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn");


func _on_file_1_pressed():
	SelectFileID(1);


func _on_file_2_pressed():
	SelectFileID(2);


func _on_file_3_pressed():
	SelectFileID(3);


func _on_file_4_pressed():
	SelectFileID(4);


func _on_button_create_file_pressed():
	SavaData.FileName = get_node("PanelNewFile/TextEdit").text;
	await get_tree().create_timer(0.2).timeout;  #Added this so it saves the save name every time
	SaveData.SaveFile();
	SetPanelVisible(2);


func _on_button_play_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Loading.tscn");
	


func _on_button_delete_pressed():
	SetPanelVisible(3);


func _on_button_delete_file_pressed():
	SaveData.DeleteFile();
	SetPanelVisible(0);


func _on_button_credits_pressed():
	SaveData.NewFile(-1);  #Don't save or load, this is for credits
	SaveData.CurrentLevel = "Credits";
	get_tree().change_scene_to_file("res://Scenes/Loading.tscn");
