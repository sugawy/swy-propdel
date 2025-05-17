Config = {}

-- Enable fake hitbox box in front of vehicle to prevent damage
Config.UseHitbox = true

-- Distance in meters from vehicle to detect deletable props
Config.DeleteRadius = 10.0

-- List of props (as model hashes) to delete
Config.PropsToDelete = {
    `prop_streetlight_01`,
    `prop_streetlight_03`,
    `prop_fire_hydrant_2`,
    `prop_fire_hydrant_1`,
    `prop_traffic_01d`,
}