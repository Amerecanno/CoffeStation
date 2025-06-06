// A vendor machine for modular computer portable devices - Laptops and Tablets

/obj/machinery/lapvend
	name = "computer vendor"
	desc = "A vending machine with a built-in microfabricator, capable of dispensing various computers."
	icon = 'icons/obj/vending.dmi'
	icon_state = "robotics"
	layer = BELOW_OBJ_LAYER
	anchored = 1
	density = 1

	// The actual laptop/tablet
	var/obj/item/modular_computer/fabricated_device = null

	var/datum/transaction/transaction_template = null

	// Utility vars
	var/state = 0 							// 0: Select device type, 1: Select loadout, 2: Payment, 3: Thankyou screen
	var/devtype = 0 						// 0: None(unselected), 1: Laptop, 2: Tablet
	var/total_price = 0						// Price of currently vended device.

	// Device loadout
	var/dev_cpu = 1							// 1: Default, 2: Upgraded
	var/dev_battery = 1						// 1: Default, 2: Upgraded, 3: Advanced
	var/dev_disk = 1						// 1: Default, 2: Upgraded, 3: Advanced
	var/dev_netcard = 0						// 0: None, 1: Basic, 2: Long-Range
	var/dev_tesla = 0						// 0: None, 1: Standard
	var/dev_nanoprint = 0					// 0: None, 1: Standard
	var/dev_card = 0						// 0: None, 1: Standard
	var/dev_aislot = 0						// 0: None, 1: Standard

/obj/machinery/lapvend/New()
	..()
	transaction_template = new(
		0, "Computer Manufacturer (via [src.name])",
		null, src.name
	)

// Removes all traces of old order and allows you to begin configuration from scratch.
/obj/machinery/lapvend/proc/reset_order()
	state = 0
	devtype = 0
	if(fabricated_device)
		QDEL_NULL(fabricated_device)
	dev_cpu = 1
	dev_battery = 1
	dev_disk = 1
	dev_netcard = 0
	dev_tesla = 0
	dev_nanoprint = 0
	dev_card = 0
	dev_aislot = 0

// Recalculates the price and optionally even fabricates the device.
/obj/machinery/lapvend/proc/fabricate_and_recalc_price(var/fabricate = 0)
	total_price = 0
	if(devtype == 1) 		// Laptop, generally cheaper to make it accessible for most station roles
		if(fabricate)
			fabricated_device = new /obj/item/modular_computer/laptop(src)
		total_price = 99
		switch(dev_cpu)
			if(1)
				if(fabricate)
					fabricated_device.processor_unit = new/obj/item/pc_part/processor_unit/small(fabricated_device)
			if(2)
				if(fabricate)
					fabricated_device.processor_unit = new/obj/item/pc_part/processor_unit(fabricated_device)
				total_price += 299
		switch(dev_battery)
			if(1) // Basic(750C)
				if(fabricate)
					fabricated_device.cell = new /obj/item/cell/medium(fabricated_device)
			if(2) // Upgraded(1100C)
				if(fabricate)
					fabricated_device.cell = new /obj/item/cell/medium/high(fabricated_device)
				total_price += 199
			if(3) // Advanced(1500C)
				if(fabricate)
					fabricated_device.cell = new /obj/item/cell/medium/super(fabricated_device)
				total_price += 499
		switch(dev_disk)
			if(1) // Basic(128GQ)
				if(fabricate)
					fabricated_device.hard_drive = new/obj/item/pc_part/drive(fabricated_device)
			if(2) // Upgraded(256GQ)
				if(fabricate)
					fabricated_device.hard_drive = new/obj/item/pc_part/drive/advanced(fabricated_device)
				total_price += 99
			if(3) // Advanced(512GQ)
				if(fabricate)
					fabricated_device.hard_drive = new/obj/item/pc_part/drive/super(fabricated_device)
				total_price += 299
		switch(dev_netcard)
			if(1) // Basic(Short-Range)
				if(fabricate)
					fabricated_device.network_card = new/obj/item/pc_part/network_card(fabricated_device)
				total_price += 99
			if(2) // Advanced (Long Range)
				if(fabricate)
					fabricated_device.network_card = new/obj/item/pc_part/network_card/advanced(fabricated_device)
				total_price += 299
		if(dev_tesla)
			total_price += 399
			if(fabricate)
				fabricated_device.tesla_link = new/obj/item/pc_part/tesla_link(fabricated_device)
		if(dev_nanoprint)
			total_price += 99
			if(fabricate)
				fabricated_device.printer = new/obj/item/pc_part/printer(fabricated_device)
		if(dev_card)
			total_price += 199
			if(fabricate)
				fabricated_device.card_slot = new/obj/item/pc_part/card_slot(fabricated_device)
		if(dev_aislot)
			total_price += 499
			if(fabricate)
				fabricated_device.ai_slot = new/obj/item/pc_part/ai_slot(fabricated_device)

		return total_price
	else if(devtype == 2) 	// Tablet, more expensive, not everyone could probably afford this.
		if(fabricate)
			fabricated_device = new /obj/item/modular_computer/tablet(src)
			fabricated_device.processor_unit = new/obj/item/pc_part/processor_unit/small(fabricated_device)
		total_price = 199
		switch(dev_battery)
			if(1) // Basic(300C)
				if(fabricate)
					fabricated_device.cell = new /obj/item/cell/small(fabricated_device)
			if(2) // Upgraded(500C)
				if(fabricate)
					fabricated_device.cell = new /obj/item/cell/small/high(fabricated_device)
				total_price += 199
			if(3) // Advanced(750C)
				if(fabricate)
					fabricated_device.cell = new /obj/item/cell/small/super(fabricated_device)
				total_price += 499
		switch(dev_disk)
			if(1) // Basic(32GQ)
				if(fabricate)
					fabricated_device.hard_drive = new/obj/item/pc_part/drive/micro(fabricated_device)
			if(2) // Upgraded(64GQ)
				if(fabricate)
					fabricated_device.hard_drive = new/obj/item/pc_part/drive/small(fabricated_device)
				total_price += 99
			if(3) // Advanced(128GQ)
				if(fabricate)
					fabricated_device.hard_drive = new/obj/item/pc_part/drive(fabricated_device)
				total_price += 299
		switch(dev_netcard)
			if(1) // Basic(Short-Range)
				if(fabricate)
					fabricated_device.network_card = new/obj/item/pc_part/network_card(fabricated_device)
				total_price += 99
			if(2) // Advanced (Long Range)
				if(fabricate)
					fabricated_device.network_card = new/obj/item/pc_part/network_card/advanced(fabricated_device)
				total_price += 299
		if(dev_nanoprint)
			total_price += 99
			if(fabricate)
				fabricated_device.printer = new/obj/item/pc_part/printer(fabricated_device)
		if(dev_card)
			total_price += 199
			if(fabricate)
				fabricated_device.card_slot = new/obj/item/pc_part/card_slot(fabricated_device)
		if(dev_tesla)
			total_price += 399
			if(fabricate)
				fabricated_device.tesla_link = new/obj/item/pc_part/tesla_link(fabricated_device)
		if(dev_aislot)
			total_price += 499
			if(fabricate)
				fabricated_device.ai_slot = new/obj/item/pc_part/ai_slot(fabricated_device)
		return total_price
	return FALSE

/obj/machinery/lapvend/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	
	ui_interact(user)

/obj/machinery/lapvend/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ComputerFabricator", name)
		ui.open()

/obj/machinery/lapvend/ui_data(mob/user)
	var/list/data = list()

	data["state"] = state
	if(state == 1)
		data["devtype"] = devtype
		data["hw_battery"] = dev_battery
		data["hw_disk"] = dev_disk
		data["hw_netcard"] = dev_netcard
		data["hw_tesla"] = dev_tesla
		data["hw_nanoprint"] = dev_nanoprint
		data["hw_card"] = dev_card
		data["hw_cpu"] = dev_cpu
		data["hw_aislot"] = dev_aislot
	if(state == 1 || state == 2)
		data["totalprice"] = total_price
	
	return data

/obj/machinery/lapvend/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state_shitass_not_used)
	. = ..()
	if(.)
		return

	switch(action)
		if("pick_device")
			if(state) // We've already picked a device type
				return FALSE
			devtype = text2num(params["device"])
			state = 1
			fabricate_and_recalc_price(0)
			return TRUE
		if("clean_order")
			reset_order()
			return TRUE

	if((state != 1) && devtype) // Following IFs should only be usable when in the Select Loadout mode
		return FALSE

	switch(action)
		if("confirm_order")
			state = 2 // Wait for ID swipe for payment processing
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_cpu")
			dev_cpu = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_battery")
			dev_battery = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_disk")
			dev_disk = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_netcard")
			dev_netcard = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_tesla")
			dev_tesla = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_nanoprint")
			dev_nanoprint = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_card")
			dev_card = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE
		if("hw_aislot")
			dev_aislot = text2num(params["value"])
			fabricate_and_recalc_price(0)
			. = TRUE

/obj/machinery/lapvend/attackby(obj/item/W as obj, mob/user as mob)
	if(inoperable())
		to_chat(user, SPAN_WARNING("[src] is not responding."))
		return
	var/obj/item/card/id/I = W.GetIdCard()
	// Awaiting payment state
	if(state == 2)
		if(process_payment(I,W))
			fabricate_and_recalc_price(1)
			if(fabricated_device)
				fabricated_device.forceMove(src.loc)
				fabricated_device.update_icon()
				fabricated_device.update_verbs()

				if(devtype == 1)
					fabricated_device.screen_on = 0
					fabricated_device.anchored = 0

				fabricated_device = null
			ping("Enjoy your new product!")
			state = 3
			return TRUE
		return FALSE
	return ..()


// Simplified payment processing, returns 1 on success.
/obj/machinery/lapvend/proc/process_payment(var/obj/item/card/id/I, var/obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if (!customer_account || customer_account.suspended)
		ping("Connection error. Unable to connect to account.")
		return FALSE

	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		customer_account = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			ping("Unable to access account: incorrect credentials.")
			return FALSE

	if(total_price > customer_account.money)
		ping("Insufficient funds in account.")
		return FALSE
	else
		transaction_template.set_amount(-total_price)
		transaction_template.purpose = "Purchase of [(devtype == 1) ? "laptop computer" : "tablet microcomputer"]."
		return transaction_template.apply_to(customer_account)
