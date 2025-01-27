extends Node
## Exists to let unrelated nodes connect to each other with signals

# Emitted when the passenger/cargo/system layer is enabled
signal passengers_viewed
signal cargo_viewed
signal systems_viewed

signal shift_started # Emitted when the shift begins, before the ship is summoned
signal shift_ended

signal ship_passed # Emitted when the pass button is pressed
signal ship_killed # Emitted when the kill button is pressed
signal ship_summoned # Emitted every time a new ship spawns

signal ship_focused # Emitted when the ship comes into full zoom
signal ship_unfocused # Emitted when the ship returns to being zoomed out
signal ship_left_gate  # Emitted when there is no ship in the gate. This is emitted after GameData has loaded the next ship

signal time_up # Emitted when the timer runs out
signal quota_filled # Emitted when the quota is filled
signal reprimand_issued
signal reprimand_limit_reached
