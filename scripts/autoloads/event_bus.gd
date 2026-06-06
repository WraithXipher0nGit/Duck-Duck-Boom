extends Node

# player hits duck
signal duck_hit(duck: Node)

# duck leaves screen
signal duck_missed(duck: Node)

# player shoots
signal player_shot(origin: Vector2, direction: Vector2)

# player collides with obstacle
signal obstacle_collided(obstacle: Node)

signal game_started

signal game_over

# after game over -> player chooses "play again"
signal game_restarted

signal score_changed(score)

signal reloaded

signal powerup_acquired(powerup_name)

signal powerup_lost
