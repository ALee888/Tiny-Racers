extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	# body came from the left
	if body.global_position.x < global_position.x:
		# body crossed finish line
		print("Crossed: ")
		body.lap += 1
		print(body.lap)
		if body.lap == 3:
			print("racer: ", body.name, " wins!")
