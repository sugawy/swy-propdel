Config = {}

-- Enable fake hitbox box in front of vehicle to prevent damage
Config.UseHitbox = true --for sure leave this on 


Config.DeleteRadius = 2.0 -- tighter forward detection
Config.HitboxDepth = 2.5 -- how far ahead of vehicle to scan

-- List of props (as model hashes) to delete
Config.PropsToDelete = {
    `prop_streetlight_01`,
    `prop_streetlight_03`,
    `prop_fire_hydrant_2`,
    `prop_fire_hydrant_1`,
    `prop_traffic_01d`,
}

--with love for 21frames