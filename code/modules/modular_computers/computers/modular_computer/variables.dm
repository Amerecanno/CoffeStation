// This is the base type that handles everything. Subtypes can be easily created by tweaking variables in this file to your liking.

/obj/item/modular_computer
	name = "Modular Computer"
	desc = "A modular computer. You shouldn't see this."

	var/enabled = 0											// Whether the computer is turned on.
	var/screen_on = 1										// Whether the computer is active/opened/it's screen is on.
	var/device_theme = ""									// TGUI theme to use
	var/datum/computer_file/program/active_program = null	// A currently active program running on the computer.
	var/hardware_flag = 0									// A flag that describes this device type
	var/last_power_usage = 0								// Last tick power usage of this computer
	var/last_battery_percent = 0							// Used for deciding if battery percentage has chandged
	var/last_world_time = "00:00"
	var/list/last_header_icons

	var/computer_emagged = FALSE							// Whether the computer is emagged.
	var/emagged_level_up = FALSE							// When do we turn from Labtop to Console bitflag

	var/apc_powered = FALSE									// Set automatically. Whether the computer used APC power last tick.
	var/base_active_power_usage = 50						// Power usage when the computer is open (screen is active) and can be interacted with. Remember hardware can use power too.
	var/base_idle_power_usage = 5							// Power usage when the computer is idle and screen is off (currently only applies to laptops)
	var/bsod = FALSE										// Error screen displayed
	var/ambience_last_played								// Last time sound was played

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon = null												// This thing isn't meant to be used on it's own. Subtypes should supply their own icon.
	icon_state = null
	var/base
	var/overlay_icon = null									// Icon file used for overlays - automatically set to "icon" if not present
	center_of_mass = null									// No pixelshifting by placing on tables, etc.
	randpixel = 0											// And no random pixelshifting on-creation either.
	var/icon_state_unpowered = null
	var/icon_state_menu = "menu"							// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/icon_state_screensaver = "standby"
	var/max_hardware_size = 0								// Maximal hardware size. Currently, tablets have 1, laptops 2 and consoles 3. Limits what hardware types can be installed.
	var/steel_sheet_cost = 5								// Amount of steel sheets refunded when disassembling an empty frame of this computer.
	var/screen_light_strength = 0							// Intensity of light this computer emits. Comparable to numbers light fixtures use.
	var/screen_light_range = 2								// Intensity of light this computer emits. Comparable to numbers light fixtures use.
	var/list/all_threads = list()							// All running programs, including the ones running in background

	// Damage of the chassis. If the chassis takes too much damage it will break apart.
	var/damage = 0				// Current damage level
	var/broken_damage = 50		// Damage level at which the computer ceases to operate
	var/max_damage = 100		// Damage level at which the computer breaks apart.
	var/list/terminals          // List of open terminal datums.

	// Important hardware (must be installed for computer to work)
	var/obj/item/pc_part/processor_unit/processor_unit				// CPU. Without it the computer won't run. Better CPUs can run more programs at once.
	var/obj/item/pc_part/network_card/network_card					// Network Card component of this computer. Allows connection to NTNet
	var/obj/item/pc_part/drive/hard_drive						// Hard Drive component of this computer. Stores programs and files.

	// Optional hardware (improves functionality, but is not critical for computer to work in most cases)
	cell = null													// An internal power source for this computer. Can be recharged.
	suitable_cell = /obj/item/cell/medium								//What type of battery do we take?
	var/obj/item/pc_part/card_slot/card_slot						// ID Card slot component of this computer. Mostly for HoP modification console that needs ID slot for modification.
	var/obj/item/pc_part/printer/printer							// Printer component of this computer, for your everyday paperwork needs.
	var/obj/item/pc_part/drive/disk/portable_drive		// Portable data storage
	var/obj/item/pc_part/ai_slot/ai_slot							// AI slot, an intellicard housing that allows modifications of AIs.
	var/obj/item/pc_part/tesla_link/tesla_link						// Tesla Link, Allows remote charging from nearest APC.
	var/obj/item/pc_part/scanner/scanner							// One of several optional scanner attachments.
	var/obj/item/pc_part/gps_sensor/gps_sensor						// GPS sensor used to track device
	var/obj/item/pc_part/led/led									// Light Emitting Diode, used for flashlight functionality in PDAs


	var/modifiable = TRUE	// can't be modified or damaged if false

	var/stores_pen = FALSE
	var/obj/item/pen/stored_pen
