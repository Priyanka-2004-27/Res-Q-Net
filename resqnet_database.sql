-- ====================================================================
-- ResQNet - Disaster Assistance & Emergency Response Platform
-- Database: MySQL / MariaDB / PostgreSQL Compatible SQL Dump
-- Project ID: 10101043494 | Silver Oak University
-- Students: Kahan Gandhi & Priyanka Mohanty | Guide: Ms. Vaishvari Desai
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `resqnet_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `resqnet_db`;

-- --------------------------------------------------------------------
-- Table 1: users (Citizen, Volunteer, Responder, Administrator)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `mongo_id` VARCHAR(50) DEFAULT NULL,
  `name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(30) NOT NULL,
  `role` ENUM('citizen', 'volunteer', 'responder', 'admin') DEFAULT 'citizen',
  `latitude` DECIMAL(10, 7) NOT NULL DEFAULT 23.0225,
  `longitude` DECIMAL(10, 7) NOT NULL DEFAULT 72.5714,
  `address` VARCHAR(255) DEFAULT 'Ahmedabad, Gujarat',
  `blood_group` ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown') DEFAULT 'Unknown',
  `emergency_contact_name` VARCHAR(100) DEFAULT NULL,
  `emergency_contact_phone` VARCHAR(30) DEFAULT NULL,
  `medical_notes` TEXT DEFAULT NULL,
  `is_available` BOOLEAN DEFAULT TRUE,
  `volunteer_skills` TEXT DEFAULT 'First Aid, Search & Rescue',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_users_role` (`role`),
  INDEX `idx_users_coords` (`latitude`, `longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------
-- Table 2: help_requests (SOS & Incident Distress Reports)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `help_requests`;
CREATE TABLE `help_requests` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `mongo_id` VARCHAR(50) DEFAULT NULL,
  `user_id` INT DEFAULT NULL,
  `user_name` VARCHAR(150) NOT NULL,
  `user_phone` VARCHAR(30) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `category` ENUM(
    'flood', 'earthquake', 'fire', 'cyclone', 'medical', 
    'landslide', 'building_collapse', 'industrial_hazard', 
    'food_water', 'rescue_evacuation', 'other'
  ) NOT NULL DEFAULT 'medical',
  `urgency_level` ENUM('critical', 'high', 'medium', 'low') NOT NULL DEFAULT 'high',
  `latitude` DECIMAL(10, 7) NOT NULL,
  `longitude` DECIMAL(10, 7) NOT NULL,
  `address` VARCHAR(255) DEFAULT 'GPS Coordinates Provided',
  `casualties_count` INT NOT NULL DEFAULT 1,
  `needs_medical` BOOLEAN DEFAULT FALSE,
  `needs_food_water` BOOLEAN DEFAULT FALSE,
  `needs_evacuation` BOOLEAN DEFAULT TRUE,
  `special_assistance` VARCHAR(255) DEFAULT NULL,
  `status` ENUM('pending', 'assigned', 'in_progress', 'resolved', 'cancelled') DEFAULT 'pending',
  `assigned_helper_id` INT DEFAULT NULL,
  `assigned_helper_name` VARCHAR(150) DEFAULT NULL,
  `assigned_helper_phone` VARCHAR(30) DEFAULT NULL,
  `estimated_arrival_minutes` INT DEFAULT NULL,
  `ai_risk_score` INT DEFAULT 7,
  `ai_severity_label` VARCHAR(100) DEFAULT 'High Priority',
  `ai_immediate_actions` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_req_status` (`status`),
  INDEX `idx_req_category` (`category`),
  INDEX `idx_req_coords` (`latitude`, `longitude`),
  CONSTRAINT `fk_req_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------
-- Table 3: alerts (Disaster Broadcast Warnings & Official NDMA Notices)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `alerts`;
CREATE TABLE `alerts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `mongo_id` VARCHAR(50) DEFAULT NULL,
  `title` VARCHAR(255) NOT NULL,
  `category` ENUM(
    'flood', 'earthquake', 'cyclone', 'wildfire', 'severe_weather', 
    'tsunami', 'landslide', 'chemical_hazard', 'evacuation_notice', 'all_clear'
  ) NOT NULL,
  `severity` ENUM('critical', 'warning', 'watch', 'advisory') NOT NULL DEFAULT 'warning',
  `summary` TEXT NOT NULL,
  `instructions_json` TEXT DEFAULT NULL,
  `latitude` DECIMAL(10, 7) NOT NULL DEFAULT 23.0225,
  `longitude` DECIMAL(10, 7) NOT NULL DEFAULT 72.5714,
  `radius_km` INT NOT NULL DEFAULT 25,
  `affected_area_name` VARCHAR(150) NOT NULL,
  `source_authority` VARCHAR(150) NOT NULL DEFAULT 'State Emergency Operations Center',
  `is_active` BOOLEAN DEFAULT TRUE,
  `issued_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `expires_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_alerts_active` (`is_active`),
  INDEX `idx_alerts_severity` (`severity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------
-- Table 4: emergency_resources (Hospitals, Shelters, Fire, Relief Camps)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `emergency_resources`;
CREATE TABLE `emergency_resources` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `mongo_id` VARCHAR(50) DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL,
  `type` ENUM(
    'hospital', 'shelter', 'evacuation_center', 'fire_station', 
    'police_station', 'relief_camp', 'food_distribution', 'blood_bank'
  ) NOT NULL,
  `latitude` DECIMAL(10, 7) NOT NULL,
  `longitude` DECIMAL(10, 7) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `contact_phone` VARCHAR(30) NOT NULL,
  `alternate_phone` VARCHAR(30) DEFAULT NULL,
  `capacity` INT NOT NULL DEFAULT 100,
  `current_occupancy` INT NOT NULL DEFAULT 0,
  `available_supplies` TEXT DEFAULT 'First Aid, Clean Drinking Water, Generator Power',
  `operational_status` ENUM('operational', 'near_capacity', 'full', 'evacuated', 'closed') DEFAULT 'operational',
  `is_verified` BOOLEAN DEFAULT TRUE,
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_res_type` (`type`),
  INDEX `idx_res_coords` (`latitude`, `longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------
-- Table 5: safety_guides (Disaster Protocols & First Aid Manuals)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `safety_guides`;
CREATE TABLE `safety_guides` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `category` VARCHAR(50) NOT NULL UNIQUE,
  `title` VARCHAR(150) NOT NULL,
  `summary` TEXT NOT NULL,
  `before_emergency` TEXT DEFAULT NULL,
  `during_emergency` TEXT DEFAULT NULL,
  `after_emergency` TEXT DEFAULT NULL,
  `dos_list` TEXT DEFAULT NULL,
  `donts_list` TEXT DEFAULT NULL,
  `emergency_helpline` VARCHAR(50) DEFAULT '112 / 108 / 101',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------
-- Table 6: status_timeline_logs (Audit & Tracking Timeline)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `status_timeline_logs`;
CREATE TABLE `status_timeline_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `request_id` INT NOT NULL,
  `status` VARCHAR(50) NOT NULL,
  `note` TEXT DEFAULT NULL,
  `updated_by` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_timeline_req` FOREIGN KEY (`request_id`) REFERENCES `help_requests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- SEED DATA INSERTS (Ahmedabad / Gujarat Live Data)
-- ====================================================================

-- 1. Insert Users
INSERT INTO `users` (`id`, `mongo_id`, `name`, `email`, `password_hash`, `phone`, `role`, `latitude`, `longitude`, `address`, `blood_group`, `volunteer_skills`) VALUES
(1, '660100000000000000000001', 'Disaster Control Admin', 'admin@resqnet.org', '$2a$10$w09ZJ6Xg7k4uL77j7H0k4eK2QZ3A8X5V1M9P.Y4G8L2N6K9W1Z0eO', '+91 9876543210', 'admin', 23.0225, 72.5714, 'State Emergency Operation Centre, Gandhinagar/Ahmedabad', 'O+', 'Command & Control, Logistics, NDRF'),
(2, '660100000000000000000002', 'Rahul Sharma (Rescue Volunteer)', 'rahul.volunteer@resqnet.org', '$2a$10$w09ZJ6Xg7k4uL77j7H0k4eK2QZ3A8X5V1M9P.Y4G8L2N6K9W1Z0eO', '+91 9825012345', 'volunteer', 23.0338, 72.5566, 'Navrangpura, Ahmedabad', 'B+', 'First Aid Certified, Boat Operations, Search & Rescue'),
(3, '660100000000000000000003', 'Dr. Priya Patel (Paramedic Volunteer)', 'priya.medic@resqnet.org', '$2a$10$w09ZJ6Xg7k4uL77j7H0k4eK2QZ3A8X5V1M9P.Y4G8L2N6K9W1Z0eO', '+91 9898034567', 'volunteer', 23.0150, 72.5850, 'Paldi, Ahmedabad', 'A+', 'Doctor, Trauma Medic, CPR Certified'),
(4, '660100000000000000000004', 'Kahan Gandhi', 'kahan@example.com', '$2a$10$w09ZJ6Xg7k4uL77j7H0k4eK2QZ3A8X5V1M9P.Y4G8L2N6K9W1Z0eO', '+91 9723456789', 'citizen', 23.0480, 72.5360, 'Vastrapur, Ahmedabad', 'O+', 'None'),
(5, '660100000000000000000005', 'Priyanka Mohanty', 'priyanka@example.com', '$2a$10$w09ZJ6Xg7k4uL77j7H0k4eK2QZ3A8X5V1M9P.Y4G8L2N6K9W1Z0eO', '+91 9428067890', 'citizen', 23.0310, 72.5290, 'Bodakdev, Ahmedabad', 'AB+', 'None');

-- 2. Insert Active Alerts (All Categories)
INSERT INTO `alerts` (`id`, `mongo_id`, `title`, `category`, `severity`, `summary`, `instructions_json`, `latitude`, `longitude`, `radius_km`, `affected_area_name`, `source_authority`, `is_active`) VALUES
(1, '660200000000000000000001', 'Flash Flood Warning: Sabarmati River Low-Lying Areas', 'flood', 'critical', 'Water release from Dharoi dam has caused rapid water level rise. All residents within 500m of the Sabarmati riverfront low basin are advised to evacuate immediately.', 'Move to higher ground or assigned municipal relief shelters. | Turn off electricity switches and gas valves. | Do not walk or drive through flowing water.', 23.0225, 72.5714, 15, 'Ahmedabad Riverfront & Subordinate Lowlands', 'Gujarat Disaster Management Authority (GSDMA)', 1),
(2, '660200000000000000000002', 'Severe Cyclone Wind Advisory - Coastal & Inland Watch', 'cyclone', 'warning', 'High speed gusting winds between 75-95 km/h forecasted. High risk of falling hoardings and tin roofs.', 'Remain indoors in sturdy concrete buildings. | Stay away from windows and glass panes. | Secure loose outdoor items.', 23.0350, 72.5450, 30, 'Ahmedabad Urban & Suburban Regions', 'India Meteorological Department (IMD)', 1),
(3, '660200000000000000000003', 'Heatwave Red Alert: Temperatures Expected to Exceed 44C', 'severe_weather', 'advisory', 'Extreme thermal stress anticipated between 11:30 AM and 4:30 PM. Children and elderly must avoid direct sun.', 'Drink plenty of water and buttermilk. | Wear lightweight cotton clothes. | Locate free cool shelters at ward offices.', 23.0400, 72.5800, 40, 'Entire Ahmedabad Metro District', 'AMC Health Department', 1),
(4, '660200000000000000000004', 'Seismic Tremor Watch: Magnitude 4.8 Fault Line', 'earthquake', 'warning', 'Mild to moderate tremors felt across northern sector. Structural audits underway on high-rise residential towers.', 'Inspect load-bearing walls for cracks. | Check gas valves. | Keep go-bag handy.', 23.0500, 72.5600, 50, 'Ahmedabad-Gandhinagar Seismic Zone', 'Institute of Seismological Research (ISR)', 1),
(5, '660200000000000000000005', 'Industrial Hazmat Warning: Chlorine Gas Leak in GIDC', 'chemical_hazard', 'critical', 'Localized chemical dispersion reported near Vatva industrial area. Air quality monitoring active.', 'Residents within 3km downwind must seal windows and wear wet cloth masks. | Turn off AC intakes.', 22.9600, 72.6200, 8, 'Vatva - Narol Industrial Belt', 'Gujarat Pollution Control Board & NDRF Hazmat', 1),
(6, '660200000000000000000006', 'Mandatory Evacuation Notice: River Basin Sectors 2 & 3', 'evacuation_notice', 'critical', 'Water discharge rate increased to 1.5 lakh cusecs. Low-level societies must evacuate to Relief Camp before 6 PM.', 'Board municipal transit buses at Usmanpura. | Carry identity papers and medications.', 23.0225, 72.5714, 6, 'Sabarmati River Basin Lowlands', 'Ahmedabad Municipal Corporation (AMC)', 1),
(7, '660200000000000000000007', 'Industrial Fire & Chemical Smoke Plume Warning', 'wildfire', 'warning', 'Warehouse fire contained by 14 tenders. Dense smoke plume drifting south-west towards ring road.', 'Keep window vents sealed with damp cloth. | Asthmatic patients stay in interior rooms.', 23.0100, 72.5100, 12, 'Sarkhej - Sanand Highway Corridor', 'Ahmedabad Fire & Emergency Services (AFES)', 1);

-- 3. Insert Emergency Resources (All 8 Infrastructure Categories)
INSERT INTO `emergency_resources` (`id`, `mongo_id`, `name`, `type`, `latitude`, `longitude`, `address`, `contact_phone`, `capacity`, `current_occupancy`, `available_supplies`, `operational_status`) VALUES
(1, '660300000000000000000001', 'Civil Hospital & Trauma Emergency Center', 'hospital', 23.0526, 72.6055, 'Asarwa, Ahmedabad, Gujarat 380016', '+91 79 2268 3721', 1200, 850, 'Trauma ICU Beds, Blood Bank (All Types), Oxygen Generators, 24/7 Ambulances', 'operational'),
(2, '660300000000000000000002', 'SVP Multi-Speciality Hospital', 'hospital', 23.0189, 72.5721, 'Ellisbridge, Riverfront West, Ahmedabad 380006', '+91 79 2657 7621', 800, 420, 'Emergency Care, Helipad Rescue, Cardiac Care Unit, Decontamination', 'operational'),
(3, '660300000000000000000003', 'Central Disaster Relief Camp & Shelter (Navrangpura)', 'shelter', 23.0365, 72.5512, 'Gujarat University Convention Hall Campus, Navrangpura', '+91 79 2630 1341', 650, 180, 'Sleeping Mats, Sanitation Kits, Clean Water, Community Kitchen', 'operational'),
(4, '660300000000000000000004', 'Municipal Fire & Rescue Headquarters (Danapith)', 'fire_station', 23.0238, 72.5855, 'Danapith, Old City, Ahmedabad 380001', '+91 79 2214 4444', 80, 15, 'Hydraulic Cutters, Inflatable Rescue Boats, Hazmat Suits, Thermal Drones', 'operational'),
(5, '660300000000000000000005', 'Vastrapur Food & Essential Ration Distribution Hub', 'food_distribution', 23.0418, 72.5284, 'Near Vastrapur Lake Community Hall, Ahmedabad 380015', '+91 79 2676 5500', 2000, 310, 'Packaged Drinking Water, Dry Ration Packets, Baby Formula Milk', 'operational'),
(6, '660300000000000000000006', 'Indian Red Cross Society Blood & Emergency Depot', 'blood_bank', 23.0298, 72.5695, 'Ashram Road, Ahmedabad 380009', '+91 79 2658 8444', 500, 120, 'O-ve Rare Blood, Plasma Units, Saline IV Fluids, Sterile Dressings', 'operational'),
(7, '660300000000000000000007', 'Ahmedabad City Police Headquarters & Command Center', 'police_station', 23.0315, 72.5812, 'Police Commissioner Office, Shahibaug, Ahmedabad 380004', '+91 79 2563 0100', 250, 80, 'Emergency Patrol Units, Crowd Control, Wireless Telecom, Rescue Drones', 'operational'),
(8, '660300000000000000000008', 'Sardar Patel Sports Complex Evacuation Staging Arena', 'evacuation_center', 23.0412, 72.5645, 'Stadium Road, Navrangpura, Ahmedabad 380009', '+91 79 2644 1122', 3500, 450, 'Dual Helipads, Air-Conditioned Hall, Emergency Cots, Paramedic Post', 'operational'),
(9, '660300000000000000000009', 'Sabarmati West Riverfront Emergency Relief Camp', 'relief_camp', 23.0275, 72.5742, 'Near Usmanpura Riverfront Park, Ahmedabad 380013', '+91 79 2755 8899', 1500, 620, 'Waterproof Tents, Mobile RO Purifiers, Community Kitchen, Blankets', 'operational');

-- 4. Insert Help Requests (All Incident Categories)
INSERT INTO `help_requests` (`id`, `mongo_id`, `user_id`, `user_name`, `user_phone`, `title`, `description`, `category`, `urgency_level`, `latitude`, `longitude`, `address`, `casualties_count`, `needs_medical`, `needs_evacuation`, `status`, `assigned_helper_id`, `assigned_helper_name`, `assigned_helper_phone`, `estimated_arrival_minutes`, `ai_risk_score`, `ai_severity_label`) VALUES
(1, '660400000000000000000001', 4, 'Kahan Gandhi', '+91 9723456789', 'Basement Flooding - Elderly Family Members Trapped', 'Ground floor and basement completely submerged under 4 feet of stormwater. Two elderly seniors cannot climb stairs.', 'flood', 'critical', 23.0480, 72.5360, 'Block B, Vastrapur Lake Enclave, Ahmedabad', 3, 1, 1, 'assigned', 2, 'Rahul Sharma (Rescue Volunteer)', '+91 9825012345', 8, 9, 'Immediate Life-Threatening'),
(2, '660400000000000000000002', 5, 'Priyanka Mohanty', '+91 9428067890', 'Severe Head Injury & Deep Laceration from Fallen Debris', 'Cyclone wind caused heavy hoarding to fall. Person has deep head cut with continuous bleeding.', 'medical', 'high', 23.0310, 72.5290, 'Near Judges Bungalow Crossroad, Bodakdev', 1, 1, 1, 'pending', NULL, NULL, NULL, NULL, 8, 'Urgent Medical Attention Needed'),
(3, '660400000000000000000003', 4, 'Kahan Gandhi', '+91 9723456789', 'Gas Cylinder Leak in Commercial Kitchen during Tremor', 'Strong LPG odor detected in basement restaurant complex after tremor. Fire alarm active.', 'fire', 'high', 23.0280, 72.5620, 'C.G. Road Commercial Arcade, Ahmedabad', 0, 0, 1, 'pending', NULL, NULL, NULL, NULL, 7, 'High Hazard / Explosion Risk'),
(4, '660400000000000000000004', 5, 'Priyanka Mohanty', '+91 9428067890', 'Structural Wall Collapse - 2 Construction Workers Trapped', 'Heavy rain caused retention wall to give way. Two laborers partially buried beneath brick debris.', 'building_collapse', 'critical', 23.0380, 72.5480, 'Under-construction site, University Road, Ahmedabad', 2, 1, 1, 'in_progress', 3, 'Dr. Priya Patel (Paramedic Volunteer)', '+91 9898034567', 4, 9, 'Immediate Life-Threatening Extrication'),
(5, '660400000000000000000005', 4, 'Kahan Gandhi', '+91 9723456789', 'Isolated Colony Requiring Clean Water & Baby Ration', 'Road submerged for 36 hours. Over 40 families stranded with zero potable drinking water.', 'food_water', 'medium', 23.0450, 72.5180, 'Shantigram Lowlands, SG Highway, Ahmedabad', 40, 0, 0, 'pending', NULL, NULL, NULL, NULL, 6, 'High Humanitarian Need'),
(6, '660400000000000000000006', 5, 'Priyanka Mohanty', '+91 9428067890', 'Pregnant Woman in Labor Trapped in Waterlogged Colony', 'Active labor contractions every 4 minutes. Access roads flooded by 3.5 feet muddy water.', 'rescue_evacuation', 'critical', 23.0180, 72.5620, 'Sector 7, Paldi Riverfront Canal Area, Ahmedabad', 2, 1, 1, 'assigned', 2, 'Rahul Sharma (Rescue Volunteer)', '+91 9825012345', 5, 10, 'Code Red Obstetric Rescue'),
(7, '660400000000000000000007', 4, 'Kahan Gandhi', '+91 9723456789', 'Cracked Stairwell & Trapped Family after Earthquake Tremor', '5th floor staircase concrete spalled off during morning tremor. 4 residents unable to descend.', 'earthquake', 'high', 23.0320, 72.5540, 'Giriraj Heights, Navrangpura, Ahmedabad', 4, 0, 1, 'pending', NULL, NULL, NULL, NULL, 8, 'High Height Hazard Entrapment');

-- 5. Insert Safety Guides (All 9 Disaster Survival Categories)
INSERT INTO `safety_guides` (`id`, `category`, `title`, `summary`, `before_emergency`, `during_emergency`, `after_emergency`, `dos_list`, `donts_list`, `emergency_helpline`) VALUES
(1, 'earthquake', 'Earthquake Survival Protocol', 'Learn the vital Drop, Cover, and Hold On technique and post-quake structural safety guidelines.', 'Fasten heavy furniture to walls. | Prepare 72-hour survival go-bag.', 'DROP to the ground. | COVER your head under a sturdy desk. | HOLD ON until shaking stops.', 'Check for injuries. | Beware of aftershocks. | Sniff for gas leaks.', 'Do protect your head with a pillow. | Do use stairs instead of elevators.', 'Do NOT run outside during shaking. | Do NOT stand in doorways.', '112 / 1077'),
(2, 'flood', 'Flood & Flash Flood Survival Guide', 'Immediate action plans for rising stormwater, dam releases, and swift water dangers.', 'Store clean drinking water. | Know your local evacuation route.', 'Turn off electricity and cooking gas. | Never walk or drive in moving water.', 'Boil all tap water. | Beware of snakes and sharp debris.', 'Do wear life jackets or floatation aids. | Do signal rescue boats from roof.', 'Do NOT drive across flooded bridges. | Do NOT touch wet electric appliances.', '108 / 1070 / 112'),
(3, 'cyclone', 'Severe Cyclone & Storm Preparedness', 'Protecting yourself and family against hurricane-force winds and storm surges.', 'Trim tree branches near roof. | Tape large glass windows.', 'Stay indoors in interior windowless room. | Beware eye of the storm.', 'Watch for hanging power lines. | Check gas before lighting.', 'Do unplug electrical appliances. | Do untie pets.', 'Do NOT venture outside during eye of storm.', '1554 / 1077'),
(4, 'first_aid', 'Emergency First Aid & Trauma Care', 'Crucial life-saving procedures for bleeding control, CPR, burns, and fractures.', 'Keep sterile first aid kit ready. | Learn CPR compression rhythms.', 'For bleeding: apply firm direct pressure with clean pad. | For burns: cool under running water for 20 mins.', 'Check for shock symptoms. | Keep patient warm and calm.', 'Do check scene safety before helping. | Do call 108 immediately.', 'Do NOT give food or water to an unconscious person. | Do NOT move suspected spinal trauma victims.', '108 / 112'),
(5, 'fire', 'Structural & Wildfire Safety Manual', 'Smoke survival techniques, building escape pathways, and burn containment.', 'Install dual-sensor smoke detectors. | Practice 2-minute family drill.', 'Crawl low under smoke. | Feel doors before opening. | Stop, Drop, and Roll.', 'Never re-enter burning structure. | Treat smoke inhalation.', 'Do close doors behind you. | Do use stairs only.', 'Do NOT fight rapid fires with water. | Do NOT use elevators.', '101 / 112'),
(6, 'landslide', 'Landslide & Mudflow Evacuation Guide', 'Recognizing slope instability triggers and protective actions in hilly terrain.', 'Identify historic slide zones. | Watch for tilting trees.', 'Evacuate immediately upon rumbling roar. | Move across slope.', 'Stay away from slide area; secondary collapses occur.', 'Do inform vulnerable neighbors. | Do heed orders immediately.', 'Do NOT build on steep slopes. | Do NOT walk over fresh mud.', '1077 / 100'),
(7, 'chemical_hazard', 'Chemical Spill & Toxic Gas Hazmat Guide', 'Shelter-in-place procedures, toxic vapor avoidance, and decontamination essentials.', 'Identify nearby chemical plants. | Store vapor respirator masks.', 'Evacuate crosswind and upwind. | Seal doors with damp towels.', 'Await official All Clear broadcast. | Remove outer clothing & shower.', 'Do breathe through damp cloth. | Do monitor Hazmat alerts.', 'Do NOT travel downwind into low basements.', '011-24363260 / 1800-116-117'),
(8, 'tsunami', 'Tsunami & Coastal Inundation Protocol', 'Natural tsunami warning signs, vertical evacuation principles, and high-ground escape.', 'Know street elevation above sea level. | Locate reinforced buildings.', 'If water recedes rapidly, MOVE INLAND IMMEDIATELY. | Climb 30m high.', 'Series of waves follow; do not return after first wave.', 'Do evacuate on foot to avoid traffic gridlock.', 'Do NOT visit beaches to watch waves.', '040-23886000 / 1554'),
(9, 'heatwave', 'Extreme Heatwave & Hyperthermia Prevention', 'Preventing life-threatening heat strokes, recognizing exhaustion symptoms, and cool shelters.', 'Store ORS and electrolyte fluids. | Install reflective window shades.', 'Avoid direct sun between 11:30 AM and 4:30 PM. | Drink 3-4L water.', 'Check on elderly neighbors. | Maintain cool hydration.', 'Do wear light loose cotton clothing. | Do cover head with umbrella.', 'Do NOT leave children/pets in parked vehicles.', '108 / 155304');

