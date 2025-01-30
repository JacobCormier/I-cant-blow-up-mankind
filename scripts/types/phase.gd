class_name Phase
extends RefCounted

## Represents a phase with a header, body, and timing settings.

## The title or heading of the message.
var header: Node

## The main content or body text of the message.
var body: Node

## Timing parameters for when and how long the message appears.
## - x: Time before the message opens.
## - y: Time the message stays open.
## - z: Time after the message closes.
var timing: Variant = null

## Initializes the phase with the given header, body, and timing.
func _init(h: Node, b: Node, t: Variant = Vector2(0.0, 0.0)):
	header = h
	body = b
	timing = t

func play():
	header._trigger_text()
	if body:
		body._trigger_text()

## 🔹 Static method to create an array of Phases from an array of dictionaries.
static func from_array(data_list: Array) -> Array:
	var phases: Array = []
	for data in data_list:
		if data is Dictionary and "header" in data and "body" in data and "timing" in data:
			phases.append(Phase.new(data.header, data.body, data.timing))
		else:
			push_error("Invalid phase data: " + str(data))
			
	print(data_list)
	return phases

## 🔹 Static method to print all phases in phase_data format.
static func print_phases(phases: Array) -> void:
	print("[")
	for phase in phases:
		print("  { \"header\": ", phase.header.name, 
			", \"body\": ", "null" if phase.body == null else phase.body.name, 
			", \"timing\": Vector2(", phase.timing.x, ", ", phase.timing.y, ") },")
	print("]")
