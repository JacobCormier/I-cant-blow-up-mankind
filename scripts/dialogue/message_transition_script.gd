extends Control

signal on_complete

@onready var icbm_header: Control = $ICBMHeader
@onready var icbm_header_2: Control = $ICBMHeader2

var count = 0

func _ready():
	icbm_header.on_complete.connect(message_done)
	icbm_header_2.on_complete.connect(message_done)
	
func message_done():
	if count == 0:
		count += 1
		icbm_header_2._trigger_text()
	else:
		on_complete.emit()

func _trigger_text() -> void:
	icbm_header._trigger_text()
