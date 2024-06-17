extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerUI.ToggleTutorialConfirm = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PlayerUI.BeginTutorial == true:
		PlayerUI.BeginTutorial = false;
		TutorialRoutine();


func TutorialRoutine():
	PlayerUI.TutorialOverlayTimer = 3.0;
	PlayerUI.TutorialOverlayText = "Click to fire";
	await get_tree().create_timer(3.0).timeout;
