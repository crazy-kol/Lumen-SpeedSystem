# Lumen Studios SpeedSystem

This script is a custom implementation for enforcing speed limits in specific zones within a game environment. The player’s vehicle speed is automatically limited when they enter predefined speed zones, and they can manually set their speed limit. The script also prevents the user from removing the speed limit while inside a speed zone.

## Features

- **Speed Zone Enforcement**: Enforces a speed limit when the player enters a defined speed zone.
- **Manual Speed Limit**: Allows players to manually set a speed limit for their vehicle.
- **Speed Limit Removal Restrictions**: Prevents players from removing the speed limit while they are in a speed zone.
- **MPH/KPH Toggle**: Configurable units for speed (MPH or KPH).
- **Real-time Speed Adjustment**: Continuously adjusts the vehicle's velocity to ensure it does not exceed the set speed limit.

## Commands

### `/limitspeed [speed]`
Usage: Sets the speed limit for your vehicle.

- **Arguments:**
  - `speed`: The speed to limit the vehicle to. Can be either in MPH or KPH depending on configuration.
  
- **Examples:**
  - `/limitspeed 80` — Limits your speed to 80 MPH or KPH based on the configuration.
  - `/limitspeed` (without arguments) — Removes the speed limit.

- **Restrictions:**
  - You cannot remove the speed limit while inside a speed zone.

- **Example Command Usage:**
  - `/limitspeed 60` — This sets the speed limit to 60 MPH or KPH.
  - `/limitspeed` — This removes the speed limit, provided you’re not inside a speed zone.

### How It Works

- **Speed Zones**: When the player enters a defined speed zone, the speed limit is automatically set to the value configured for that zone.
- **Manual Speed Limit**: Players can manually set their vehicle’s speed limit using the `/limitspeed` command. This will override the zone speed limit until the player enters a new zone.
- **Speed Limit Enforcement**: If the vehicle exceeds the set speed limit (whether manual or zone-based), the script will automatically reduce the vehicle’s speed by adjusting its velocity to stay within the limit.
- **Speed Zone Exit**: When the player exits the speed zone, the speed limit is removed (unless they have set a manual limit).

## Installation

- Download the Lumen-SpeedSystem script files.
- Place the script in your server's resource folder.
- Add the following line to your server.cfg to ensure the resource is loaded:

  ```bash
  ensure Lumen-SpeedSystem
