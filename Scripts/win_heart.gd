extends Area2D

signal levelComp(pos)

func _on_body_entered(body):
	if body.name == "Heart":
		levelComp.emit(body.position)
