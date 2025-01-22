extends Node
## Exists to let unrelated nodes connect to each other with signals

# Emitted when the passenger/cargo/system layer is enabled
signal passengers_viewed
signal cargo_viewed
signal systems_viewed

signal start_shift # Emitted when the shift begins
signal pass_ship # Emitted when the pass button is pressed
signal kill_ship # Emitted when the kill button is pressed
signal summon_ship # Emitted every time a new ship spawns

signal ship_focused # Emitted when the ship comes into full zoom
signal ship_unfocused # Emitted when the ship returns to being zoomed out
signal ship_left_gate  # Emitted when there is no ship in the gate

signal time_up # Emitted when the timer runs out
signal quota_filled # Emitted when the quota is filled
