extends Control
@onready var racer: CharacterBody2D = $"../../Racer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var int_speed = int(racer.velocity.length())
	%SpeedLabel.text = str(int_speed)
