extends Node
## Exists to let unrelated nodes connect to each other with signals

# Emitted when the passenger/cargo/system layer is enabled
signal passengers_viewed
signal cargo_viewed
signal systems_viewed

signal shift_started # Emitted when the shift begins, before the ship is summoned
signal shift_ended # Emitted on shift end AND WHEN THE GAME STARTS
signal lock_shift # Emit to prevent the shift from ending
signal unlock_shift # Emit to allow the shift to end

signal ship_passed # Emitted when the pass button is pressed
signal ship_killed # Emitted when the kill button is pressed
signal ship_summoned # Emitted every time a new ship spawns

signal ship_focused # Emitted when the ship comes into full zoom
signal ship_unfocused # Emitted when the ship returns to being zoomed out
signal ship_left_gate  # Emitted when there is no ship in the gate. This is emitted after GameData has loaded the next ship

signal time_up # Emitted when the timer runs out
signal quota_filled # Emitted when the quota is filled
signal reprimand_issued # Emitted after a reprimand is added
signal reprimand_revoked # Emitted after a reprimand is removed
signal reprimand_limit_reached

signal game_begun # Emitted when the start button is pressed
signal game_lost # Emitted when the failure animation completes
signal game_won # Emitted when the final brief button is pressed
signal return_title

signal cheat_time(length)
signal cheat_debugger

signal gate_touched
