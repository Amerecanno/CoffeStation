/*
/obj/machinery/portable_atmospherics/reagent_sublimator/sauna
	name = "sauna heater"
	desc = "A top of the line electric sauna heater - it accepts water, and produces steam. Wow!"
	icon_state = "sauna-off-unloaded-notank"
	icon_set = "sauna"
	reagent_whitelist = list(/datum/reagent/water)
	output_temperature = T0C+40
	machine_name = "sauna heater"
	machine_desc = "A reagent sublimator that only works with water, converting it into hot steam. Toasty!"

/obj/item/circuitboard/sauna
	build_name = "sauna heater board"
	board_type = "machine"
	build_path = /obj/item/stock_parts/circuitboard/sublimator/sauna
*/

/**********************************
*******Interactions code by HONKERTRON feat TestUnit********
***********************************/

/mob/living/carbon/human/MouseDrop(mob/M as mob)
	..()
	if(src == usr)
		interactionsss(M)

/mob/proc/make_interaction()
	return

//Distant interactions
/mob/living/carbon/human/verb/interactionsss(mob/M as mob)
	set name = "Interact"
	set category = "IC"

	if (istype(M, /mob/living/carbon/human) && usr != M && src != M)
		partner = M
		make_interaction(machine)

/mob/living/carbon/human/make_interaction()
	set_machine(src)

	var/mob/living/carbon/human/H = usr
	var/mob/living/carbon/human/P = H.partner
	var/obj/item/organ/external/temp = H.organs_by_name["r_arm"]
	var/hashands = (temp?.is_usable())
	if (!hashands)
		temp = H.organs_by_name["l_arm"]
		hashands = (temp?.is_usable())
	temp = P.organs_by_name["r_arm"]
	var/hashands_p = (temp?.is_usable())
	if (!hashands_p)
		temp = P.organs_by_name["l_arm"]
		hashands = (temp?.is_usable())
	// var/mouthfree = !((H.head && (H.check_mouth_coverage())) || (H.wear_mask && (H.check_mouth_coverage())))
	var/mouthfree_p = !((P.head && (P.check_mouth_coverage())) || (P.wear_mask && (P.check_mouth_coverage())))


	var/dat = "<B><HR><FONT size=3>INTERACTIONS - [H.partner]</FONT></B><BR><HR>"
	var/ya = "&#1103;"

	dat +=  {"• <A href='?src=\ref[src];interactionsss=bow'>Отвесить поклон.</A><BR>"}
	if (hashands)
		dat +=  {"<font size=3><B>Руки:</B></font><BR>"}
		dat +=  {"• <A href='?src=\ref[src];interactionsss=bow_affably'>Приветливо кивнуть.</A><BR>"}
		if (Adjacent(P))
			dat +=  {"• <A href='?src=\ref[src];interactionsss=handshake'>Пожать руку.</A><BR>"}
			dat +=  {"• <A href='?src=\ref[src];interactionsss=hug'>Обнимашки!</A><BR>"}
			dat +=  {"• <A href='?src=\ref[src];interactionsss=cheer'>Похлопать по плечу</A><BR>"}
			dat +=  {"• <A href='?src=\ref[src];interactionsss=five'>Дать п[ya]ть.</A><BR>"}
			// if ((P.species.name == SPECIES_TAJARA)  || (P.species.name == SPECIES_VOX)|| (P.species.name == SPECIES_RESOMI) || (P.species.name == SPECIES_YEOSA) || (P.species.name == SPECIES_EROSAN) || (P.species.name == SPECIES_UNATHI))
			// 	dat +=  {"• <A href='?src=\ref[src];interaction=pull'><font color=red>Дёрнуть за хвост!</font></A><BR>"}
			// 	dat +=  {"• <A href='?src=\ref[src];interaction=pet'>Погладить.</A><BR>"}
			// 	dat +=  {"• <A href='?src=\ref[src];interaction=scratch'>Почесать.</A><BR>"}
			if (hashands_p)
				dat +=  {"• <A href='?src=\ref[src];interactionsss=give'>Передать предмет.</A><BR>"}
			// dat +=  {"• <A href='?src=\ref[src];interaction=slap'><font color=red>Дать пощечину!</font></A><BR>"}
			dat +=  {"• <A href='?src=\ref[src];interactionsss=knock'><font color=red>Дать подзатыльник.</font></A><BR>"}
		dat +=  {"• <A href='?src=\ref[src];interactionsss=fuckyou'><font color=red>Показать средний палец.</font></A><BR>"}
		dat +=  {"• <A href='?src=\ref[src];interactionsss=threaten'><font color=red>Погрозить кулаком.</font></A><BR>"}
		dat +=  {"• <A href='?src=\ref[src];interactionsss=slapass'><font color=red>Щлепнуть по заднице.</font></A><BR>"}

	// if (mouthfree && H.species.name != "Diona")
	// 	dat += {"<font size=3><B>Лицо:</B></font><BR>"}
	// 	dat += {"• <A href='?src=\ref[src];interaction=kiss'>Поцеловать.</A><BR>"}
		if (Adjacent(P))
			if (mouthfree_p)
				dat += {"• <A href='?src=\ref[src];interactionsss=lick'>Лизнуть в щеку.</A><BR>"}
			dat +=  {"• <A href='?src=\ref[src];interactionsss=spit'><font color=red>Плюнуть.</font></A><BR>"}
		dat +=  {"• <A href='?src=\ref[src];interactionsss=tongue'><font color=red>Показать [ya]зык.</font></A><BR>"}

	var/datum/browser/popup = new(usr, "interactionsss", "interactionsss", 340, 480)
	popup.set_content(dat)
	popup.open()


/mob/living/carbon/human
	var/mob/living/carbon/human/partner
