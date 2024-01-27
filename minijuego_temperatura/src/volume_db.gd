extends VBoxContainer

var record_live_player_1: int
var volume_db: int
var volume_samples: Array = []

func _ready() -> void:
	record_live_player_1 = AudioServer.get_bus_index('Player1')

func _process(delta: float) -> void:
	update_samples_strength(record_live_player_1)

func update_samples_strength(record_live: int) -> void:
	var left_volume = AudioServer.get_bus_peak_volume_left_db(record_live, 0)
	var right_volume = AudioServer.get_bus_peak_volume_right_db(record_live, 0)
	var sample = db_to_linear(left_volume)
	var sample_2 = db_to_linear(right_volume)
	volume_samples.push_front(average_array([sample, sample_2]))

	# Use a while loop that way the user can adjust the number of samples at runtime
	# and remove as many as needed when the value changes
	while volume_samples.size() > 10:
		volume_samples.pop_back()

	volume_db = round(linear_to_db(average_array(volume_samples)))

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
