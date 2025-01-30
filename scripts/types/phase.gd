class_name Phase
extends RefCounted

signal on_complete

## Represents a phase with a header, body, and timing settings.

## The title or heading of the message.
var header: Variant

## The main content or body text of the message.
var body: Variant

## Timing parameters for when and how long the message appears.
## - x: Time before the message opens.
## - y: Time the message stays open.
## - z: Time after the message closes.
var timing: Variant = null

var _done_count = 0
var _waiting_count = 0

## Initializes the phase with the given header, body, and timing.
func _init(h: Variant, b: Variant, t: Variant = Vector3(0.0, 0.0, 0.0)):
	header = h
	body = b
	timing = t
	
	header.on_complete.connect(complete)
		
	if body != null:
		body.on_complete.connect(complete)
		_waiting_count = 2

func complete():
	_done_count += 1
	
	if _done_count >= _waiting_count:
		on_complete.emit()

func play():
	header.initial_delay = timing.x
	header.end_delay = timing.y
	header.trigger_dialogue(timing)
	if body:
		body.initial_delay = timing.x + 0.1
		body.end_delay = timing.y + 0.1
		body.trigger_dialogue(timing)

## 🔹 Static method to create an array of Phases from an array of dictionaries.
static func from_array(data_list: Array) -> Array:
	var phases: Array = []
	for data in data_list:
		if data is Dictionary and "header" in data and "body" in data and "timing" in data:
			phases.append(Phase.new(data.header, data.body, data.timing))
		else:
			print("Invalid phase data: " + str(data))
			
	return phases
