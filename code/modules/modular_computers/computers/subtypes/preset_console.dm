/obj/item/modular_computer/console/preset/install_default_hardware()
	..()
	processor_unit = new/obj/item/pc_part/processor_unit(src)
	tesla_link = new/obj/item/pc_part/tesla_link(src)
	hard_drive = new/obj/item/pc_part/drive/advanced(src)
	network_card = new/obj/item/pc_part/network_card/wired(src)
	scanner = new /obj/item/pc_part/scanner/paper(src)

// Engineering
/obj/item/modular_computer/console/preset/engineering/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/power_monitor())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new/datum/computer_file/program/atmos_control())
	hard_drive.store_file(new/datum/computer_file/program/rcon_console())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())

// Engineering alarm monitor
/obj/item/modular_computer/console/preset/engineering/alarms/install_default_programs()
	..()
	set_autorun("alarmmonitor")

// Engineering supermatter monitor
/obj/item/modular_computer/console/preset/engineering/supermatter/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/supermatter_monitor())
	set_autorun("supmon")

// Engineering RCON control
/obj/item/modular_computer/console/preset/engineering/rcon/install_default_programs()
	..()
	set_autorun("rconconsole")

// Engineering shield control
/obj/item/modular_computer/console/preset/engineering/shield/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/shield_control())
	set_autorun("shieldcontrol")

// Engineering power monitor
/obj/item/modular_computer/console/preset/engineering/power/install_default_programs()
	..()
	set_autorun("powermonitor")

// Engineering atmos control
/obj/item/modular_computer/console/preset/engineering/atmos/install_default_programs()
	..()
	set_autorun("atmoscontrol")

// Medical
/obj/item/modular_computer/console/preset/medical/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/medical/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors())

// Medical records
/obj/item/modular_computer/console/preset/medical/records/install_default_programs()
	..()
	set_autorun("crewrecords")

// Medical crew monitor
/obj/item/modular_computer/console/preset/medical/monitor/install_default_programs()
	..()
	set_autorun("sensormonitor")

// Research
/obj/item/modular_computer/console/preset/research/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/research/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())

/obj/item/modular_computer/console/preset/pointminer/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/pointminer/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/point_miner/prestalled())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())

// TODO: enable after baymed AI
// Research robotics (placeholder for future)
/*
/obj/item/modular_computer/console/preset/research/silicon/install_default_hardware()
	..()
	ai_slot = new/obj/item/pc_part/ai_slot(src)

/obj/item/modular_computer/console/preset/research/silicon/install_default_programs()
	..()
	//hard_drive.store_file(new/datum/computer_file/program/aidiag())
*/
// Research administrator
/obj/item/modular_computer/console/preset/research/sysadmin/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/ntnetmonitor())
	hard_drive.store_file(new/datum/computer_file/program/email_administration())

// Command
/obj/item/modular_computer/console/preset/command/install_default_hardware()
	..()
	processor_unit = new/obj/item/pc_part/processor_unit/adv(src)
	tesla_link = new/obj/item/pc_part/tesla_link(src)
	hard_drive = new/obj/item/pc_part/drive/advanced(src)
	scanner = new /obj/item/pc_part/scanner/paper(src)
	printer = new/obj/item/pc_part/printer(src)
	card_slot = new/obj/item/pc_part/card_slot(src)

/obj/item/modular_computer/console/preset/command/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/reports())
	hard_drive.store_file(new/datum/computer_file/program/comm())
	hard_drive.store_file(new/datum/computer_file/program/card_mod())
	hard_drive.store_file(new/datum/computer_file/program/tax())

//First Officer
/obj/item/modular_computer/console/preset/command/access/install_default_programs()
	..()
	set_autorun("cardmod")

// Security
/obj/item/modular_computer/console/preset/security/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/security/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/digitalwarrant())
	hard_drive.store_file(new/datum/computer_file/program/audio())


// Security cameras
/obj/item/modular_computer/console/preset/security/camera/install_default_programs()
	..()
	set_autorun("cammon")

// Crew cams
/obj/item/modular_computer/console/preset/crew_cams/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/crew_cams/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())

// Crew cameras
/obj/item/modular_computer/console/preset/crew_cams/camera/install_default_programs()
	..()
	set_autorun("cammon")


// Security records
/obj/item/modular_computer/console/preset/security/records/install_default_programs()
	..()
	set_autorun("crewrecords")

// Civilian
/obj/item/modular_computer/console/preset/civilian/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/crew_manifest())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	//hard_drive.store_file(new/datum/computer_file/program/supply())


// Civilian Offices
/obj/item/modular_computer/console/preset/civilian/professional/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/civilian/professional/install_default_programs()
	..()
	var/datum/computer_file/program/crew_manifest/CM = locate(/datum/computer_file/program/crew_manifest) in hard_drive.stored_files
	hard_drive.remove_file(CM)
	hard_drive.store_file(new/datum/computer_file/program/records())

// Civilian Library
/obj/item/modular_computer/console/preset/civilian/professional/library/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/library())

// Trade Console
/obj/item/modular_computer/console/preset/trade/install_default_hardware()
	..()
	card_slot = new/obj/item/pc_part/card_slot(src)
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/trade/install_default_programs()
	..()
	hard_drive.store_file(new /datum/computer_file/program/trade())
	set_autorun("trade")

// Trade Ordering Console
/obj/item/modular_computer/console/preset/trade_orders/install_default_programs()
	..()
	hard_drive.store_file(new /datum/computer_file/program/trade/order())
	set_autorun("trade_orders")

// Nanobot integrated Console.
/obj/item/modular_computer/console/preset/nanobot
	suitable_cell = /obj/item/cell/large/moebius/super
	layer = ABOVE_MOB_LAYER

/obj/item/modular_computer/console/preset/nanobot/install_default_hardware()
	..()
	network_card = new /obj/item/pc_part/network_card/adv_wired(src)
	processor_unit = new /obj/item/pc_part/processor_unit/super(src)
	tesla_link = new /obj/item/pc_part/tesla_link(src)
	hard_drive = new /obj/item/pc_part/drive/cluster(src)
	cell = new /obj/item/cell/large/moebius/omega(src)
	gps_sensor = new /obj/item/pc_part/gps_sensor(src)
	led = new /obj/item/pc_part/led/adv(src)
	scanner = new /obj/item/pc_part/scanner/reagent(src)
	printer = new/obj/item/pc_part/printer(src)
	card_slot = new/obj/item/pc_part/card_slot(src)
	network_card.matter = list()
	processor_unit.matter = list()
	tesla_link.matter = list()
	hard_drive.matter = list()
	cell.matter = list()
	gps_sensor.matter = list()
	led.matter = list()
	scanner.matter = list()
	printer.matter = list()
	card_slot.matter = list()

//Dock control
/*
/obj/item/modular_computer/console/preset/dock/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/dock/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	//hard_drive.store_file(new/datum/computer_file/program/supply())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	//hard_drive.store_file(new/datum/computer_file/program/docking())

// Crew-facing supply ordering computer
/obj/item/modular_computer/console/preset/supply/install_default_hardware()
	..()
	printer = new/obj/item/pc_part/printer(src)

/obj/item/modular_computer/console/preset/supply/install_default_programs()
	..()
	//hard_drive.store_file(new/datum/computer_file/program/supply())
	set_autorun("supply")

// ERT
/obj/item/modular_computer/console/preset/ert/install_default_hardware()
	..()
	ai_slot = new/obj/item/pc_part/ai_slot(src)
	printer = new/obj/item/pc_part/printer(src)
	card_slot = new/obj/item/pc_part/card_slot(src)

/obj/item/modular_computer/console/preset/ert/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/ert())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new/datum/computer_file/program/comm())
	//hard_drive.store_file(new/datum/computer_file/program/aidiag())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())

// Mercenary
/obj/item/modular_computer/console/preset/mercenary/
	computer_emagged = TRUE

/obj/item/modular_computer/console/preset/mercenary/install_default_hardware()
	..()
	ai_slot = new/obj/item/pc_part/ai_slot(src)
	printer = new/obj/item/pc_part/printer(src)
	card_slot = new/obj/item/pc_part/card_slot(src)

/obj/item/modular_computer/console/preset/mercenary/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/hacked())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	//hard_drive.store_file(new/datum/computer_file/program/aidiag())

// Merchant
/obj/item/modular_computer/console/preset/merchant/install_default_programs()
	..()
	//hard_drive.store_file(new/datum/computer_file/program/merchant())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
*/

