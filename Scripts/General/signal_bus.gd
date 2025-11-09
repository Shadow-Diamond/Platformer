extends Node
# Apparently there isn't a way to ignore every signal at once without disabling it globally, which is unfortunate

# Signals related to the player
@warning_ignore("unused_signal")
signal bounce
@warning_ignore("unused_signal")
signal collect
@warning_ignore("unused_signal")
signal hurt_player
@warning_ignore("unused_signal")
signal power_up
@warning_ignore("unused_signal")
signal level_fin
@warning_ignore("unused_signal")
signal kill_player

# Signals related to enemies
@warning_ignore("unused_signal")
signal e_death

# Other Signals
@warning_ignore("unused_signal")
signal reset
@warning_ignore("unused_signal")
signal player_pos
@warning_ignore("unused_signal")
signal gm_update_score
