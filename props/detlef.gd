extends StaticBody2D


func get_shifted():
	$animator.play("attacc")


func attack():
	$hurtbox.pulse()
