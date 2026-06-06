extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#turns weapon red, delete if un-needed
#no good reason for adding this :/
func _on_exit_button_mouse_entered() -> void:
	$UIButtonHover.play()
	$Sprites/Node2D/Placeholder/Weapon_Shaft_Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
	$Sprites/Node2D/Placeholder/Weapon_Base_Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
func _on_exit_button_mouse_exited() -> void:
	$Sprites/Node2D/Placeholder/Weapon_Shaft_Sprite.modulate = Color(0.0, 0.0, 0.0, 1.0)
	$Sprites/Node2D/Placeholder/Weapon_Base_Sprite.modulate = Color(0.0, 0.0, 0.0, 1.0)
