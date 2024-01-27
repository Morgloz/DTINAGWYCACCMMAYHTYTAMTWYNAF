extends Control


@onready var volume_bar = $ui/live_audio/monitors/volume_bar
@onready var mic_input = $mic_input
@onready var temperature_bar = $ui/live_audio/monitors/temperature_bar
@onready var label_inst = $ui/live_audio/monitors/InstructionLabel
@onready var live_audio = $ui/live_audio

var record_bus_index: int
var record_effect: AudioEffectRecord
var recording: AudioStreamWAV

var timer = 0
var control_timer = 0
var timer_started: bool = false
var game_start: bool = false
const TIME_PERIOD = 3 # 3s

func _ready() -> void:
	record_bus_index = AudioServer.get_bus_index('Player1')
	# Only one effect on the bus, so can just assume index 0 for record effect
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)


func _on_play_button_pressed() -> void:
	print("play button")
	if !game_start:
		temperature_bar.value = randi_range(100, 200)
		game_start = true

func _on_amp_spinbox_value_changed(value: float) -> void:
	mic_input.volume_db = linear_to_db(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_start:
		volume_bar.value = live_audio.volume_db + 200
		if (temperature_bar.value - 10) < volume_bar.value and volume_bar.value < (temperature_bar.value + 5):
			timer += delta
			label_inst.text = "HOLD ON!!!"
		elif (temperature_bar.value - 10) > volume_bar.value:
			label_inst.text = "YELL MOAAAAAAAAR!!!"
		elif (temperature_bar.value + 10) < volume_bar.value:
			label_inst.text = "WOW, WHY ARE YOU YELLING TO ME SO LOUD?"
		if timer > TIME_PERIOD:
			print("YOU WIN")
			game_start = false
			SceneSwitcher.switch_scene("res://Kitchen/kitchen.tscn")
		print(timer)
		control_timer+=delta
		print(control_timer)
		
