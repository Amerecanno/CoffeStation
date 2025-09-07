/mob/living/carbon/human/Topic(href, href_list)



	///////Interactions!!///////
	if(href_list["interactionsss"])
		if (usr.stat == DEAD || usr.stat == UNCONSCIOUS || usr.restrained())
			return

		//CONDITIONS
		var/mob/living/carbon/human/H = usr
		var/mob/living/carbon/human/P = H.partner
		if (!(P in view(H.loc)))
			return
		var/obj/item/organ/external/temp = H.organs_by_name["r_arm"]
		var/hashands = (temp?.is_usable())
		if (!hashands)
			temp = H.organs_by_name["l_arm"]
			hashands = (temp?.is_usable())
		temp = P.organs_by_name["r_hand"]
		var/hashands_p = (temp?.is_usable())
		if (!hashands_p)
			temp = P.organs_by_name["l_arm"]
			hashands = (temp?.is_usable())
		var/mouthfree = !((H.head && (H.check_mouth_coverage())) || (H.wear_mask && (H.check_mouth_coverage())))
		var/mouthfree_p = !((P.head && (P.check_mouth_coverage())) || (P.wear_mask && (P.check_mouth_coverage())))
		var/ya = "я"
		// Убрано пока я не научусь кодить!
		// if(world.time <= H.get_unarmed_damage + 1 SECONDS)
		// 	return
		// else
		// 	H.get_unarmed_damage = world.time

		if (href_list["interactionsss"] == "bow")
			H.visible_message("<B>[H]</B> клан[ya]етс[ya] <B>[P]</B>.")
			if (istype(P.loc, /obj/structure/closet) && P.loc == H.loc)
				P.visible_message("<B>[H]</B> клан[ya]етс[ya] <B>[P]</B>.")
			playsound(loc, 'coffecode/sound/interactions/respect.ogg', 50, 1, -1)


		else if (href_list["interactionsss"] == "pet")
			if(((!istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands && H.Adjacent(P))
				H.visible_message("<B>[H]</B> [pick("гладит", "поглаживает")] <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> [pick("гладит", "поглаживает")] <B>[P]</B>.")



		else if (href_list["interactionsss"] == "give")
			if(H.Adjacent(P))
				if (((!istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
					H.give(P)

		else if (href_list["interactionsss"] == "kiss")
			if( ((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)))
				H.visible_message("<B>[H]</B> целует <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> целует <B>[P]</B>.")
			else if (mouthfree)
				H.visible_message("<B>[H]</B> посылает <B>[P]</B> воздушный поцелуй.")

		else if (href_list["interactionsss"] == "lick")
			if( ((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree && mouthfree_p)
				if (prob(90))
					H.visible_message("<B>[H]</B> [H.gender == FEMALE ? "лизнула" : "лизнул"] <B>[P]</B> в щеку.")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<B>[H]</B> [H.gender == FEMALE ? "лизнула" : "лизнул"] <B>[P]</B> в щеку.")
				else
					H.visible_message("<B>[H]</B> особо тщательно [H.gender == FEMALE ? "лизнула" : "лизнул"] <B>[P]</B>.")
					if (istype(P.loc, /obj/structure/closet))
						P.visible_message("<B>[H]</B> особо тщательно [H.gender == FEMALE ? "лизнула" : "лизнул"] <B>[P]</B>.")

		else if (href_list["interactionsss"] == "hug")
			if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<B>[H]</B> обнимает <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> обнимает <B>[P]</B>.")
				playsound(loc, 'coffecode/sound/interactions/hug.ogg', 50, 1, -1)

		else if (href_list["interactionsss"] == "cheer")
			if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<B>[H]</B> похлопывает <B>[P]</B> по плечу.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> похлопывает <B>[P]</B> по плечу.")

		else if (href_list["interactionsss"] == "five")
			if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<B>[H]</B> даёт <B>[P]</B> п[ya]ть.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> даёт <B>[P]</B> п[ya]ть.")
				playsound(loc, 'coffecode/sound/interactions/slap.ogg', 50, 1, -1)

		else if (href_list["interactionsss"] == "handshake")
			if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands && hashands_p)
				H.visible_message("<B>[H]</B> жмёт руку <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> жмёт руку <B>[P]</B>.")

		else if (href_list["interactionsss"] == "bow_affably")
			H.visible_message("<B>[H]</B> приветливо кивнул[H.gender == FEMALE ? "а" : ""] в сторону <B>[P]</B>.")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<B>[H]</B> приветливо кивнул[H.gender == FEMALE ? "а" : ""] в сторону <B>[P]</B>.")

		else if (href_list["interactionsss"] == "wave")
			if (!(H.Adjacent(P)) && hashands)
				H.visible_message("<B>[H]</B> приветливо машет <B>[P]</B>.")
			else
				H.visible_message("<B>[H]</B> приветливо кивнул[H.gender == FEMALE ? "а" : ""] в сторону <B>[P]</B>.")


		// else if (href_list["interaction"] == "slap")
		// 	if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
		// 		switch(H.zone_sel)
		// 			if(BP_HEAD)
		// 				H.visible_message("<span class='danger'>[H] дает [P] пощечину!</span>")
		// 				if (istype(P.loc, /obj/structure/closet))
		// 					P.visible_message("<span class='danger'>[H] дает [P] пощечину!</span>")
		// 				playsound(loc, 'coffecode/sound/interactions/slap.ogg', 50, 1, -1)
		// 				// var/obj/item/organ/external/O = P.get_organ(BP_HEAD)
		// 				// if(O.take_damage <= 2)
		// 				// 	O.take_damage(1 )
		// 				H.do_attack_animation(P)

		// 			if(BP_MOUTH)
		// 				H.visible_message("<span class='danger'>[H] дает [P] по губе!</span>")
		// 				if (istype(P.loc, /obj/structure/closet))
		// 					P.visible_message("<span class='danger'>[H] дает [P] по губе!</span>")
		// 				playsound(loc, 'coffecode/sound/interactions/slap.ogg', 50, 1, -1)
		// 				H.do_attack_animation(P)

		else if (href_list["interactionsss"] == "slapass")
			if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='danger'>[H] шлёпает [P] по заднице!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='danger'>[H] шлёпает [P] по заднице!</span>")
				playsound(loc, 'coffecode/sound/interactions/slap.ogg', 50, 1, -1)
				// var/obj/item/organ/external/G = P.get_organ(BP_GROIN)
				// if(G.take_damage <= 2)
				//  	G.take_damage(1)
				H.do_attack_animation(P)

		else if (href_list["interactionsss"] == "fuckyou")
			if(hashands)
				H.visible_message("<span class='danger'>[H] показывает [P] средний палец!</span>")
				if (istype(P.loc, /obj/structure/closet) && P.loc == H.loc)
					P.visible_message("<span class='danger'>[H] показывает [P] средний палец!</span>")

		else if (href_list["interactionsss"] == "knock")
			if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='danger'>[H] дает [P] подзатыльник!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='danger'>[H] дает [P] подзатыльник!</span>")
				playsound(loc, 'sound/weapons/throwtap.ogg', 50, 1, -1)
				// var/obj/item/organ/external/O = P.get_organ(BP_HEAD)
				// if(O.getBruteLoss <= 2)
				// 	O.getBruteLoss(1)
				H.do_attack_animation(P)

		else if (href_list["interactionsss"] == "spit")
			if(((H.Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree)
				H.visible_message("<span class='danger'>[H] плюёт в [P]!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='danger'>[H] плюёт в [P]!</span>")

		else if (href_list["interactionsss"] == "threaten")
			if(hashands)
				H.visible_message("<span class='danger'>[H] грозит [P] кулаком!</span>")
				if (istype(P.loc, /obj/structure/closet) && H.loc == P.loc)
					P.visible_message("<span class='danger'>[H] грозит [P] кулаком!</span>")

		else if (href_list["interactionsss"] == "tongue")
			if(mouthfree)
				H.visible_message("<span class='danger'>[H] показывает [P] [ya]зык!</span>")
				if (istype(P.loc, /obj/structure/closet) && H.loc == P.loc)
					P.visible_message("<span class='danger'>[H] показывает [P] [ya]зык!</span>")

	..()
