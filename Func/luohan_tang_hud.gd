extends PanelContainer

@onready var anisprite = $RollingMachine/AniSprite
@onready var rollingtimer = $RollingTimer
@onready var show_result_label = $RollingMachine/PanelContainer/VBox/ShowResultLabel

var can_roll: bool =true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rolling_timer_timeout():
	anisprite.play("empty")

func _on_start_bn_pressed():
	
	if can_roll != true:
		return
	can_roll = false
	show_result_label.text = "Pending"
	anisprite.play("rolling")
	rollingtimer.start(3)
	await rollingtimer.timeout
	
	show_result_label.text = str(random_code())
	rollingtimer.start(1)
	
	can_roll = true

func _on_close_btn_pressed():
	Global.emit_signal("luohantang_panel", false)
	
func random_code():
	randomize()
	var rand_luohan = randi_range(0, 12)
	return rand_luohan
	
