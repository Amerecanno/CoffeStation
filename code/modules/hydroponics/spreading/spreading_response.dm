
/obj/effect/plant/HasProximity(var/atom/movable/AM)

	if(seed.get_trait(TRAIT_CHEM_SPRAYER))
		spawn(0)
			var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
			var/turf/my_target = get_turf(AM)
			D.create_reagents(10*seed.chems.len)
			if(!src)
				return
			for (var/reagent in seed.chems)
				D.reagents.add_reagent(reagent, 10)
			D.set_color()
			D.set_up(my_target, 1, 10)

	if(!is_mature() || seed.get_trait(TRAIT_SPREAD) != 2)
		return

	var/mob/living/M = AM
	if(!istype(M))
		return

	if(!istype(seed, /datum/seed/mushroom/maintshroom) && !buckled_mob && !M.buckled && !M.anchored && (issmall(M) || prob(round(seed.get_trait(TRAIT_POTENCY)/6))))
		//wait a tick for the Entered() proc that called HasProximity() to finish (and thus the moving animation),
		//so we don't appear to teleport from two tiles away when moving into a turf adjacent to vines.
		spawn(1)
			entangle(M)


/*************************
	Attack procs
**************************/
/obj/effect/plant/attack_hand(var/mob/user)
	manual_unbuckle(user)

/obj/effect/plant/attack_generic(mob/user, damage, attack_message, damagetype = BRUTE, attack_flag = ARMOR_MELEE, sharp = FALSE, edge = FALSE)
	if(istype(user))
		manual_unbuckle(user)

/obj/effect/plant/attackby(var/obj/item/W, var/mob/user)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.5)
	plant_controller.add_plant(src)
	if(istype(W, /obj/item/reagent_containers/syringe))
		return


	if(istype(W, /obj/item/tool/wirecutters) || istype(W, /obj/item/tool/scalpel))
		if(sampled)
			to_chat(user, SPAN_WARNING("\The [src] has already been sampled recently."))
			return
		if(!is_mature())
			to_chat(user, SPAN_WARNING("\The [src] is not mature enough to yield a sample yet."))
			return
		if(!seed)
			to_chat(user, SPAN_WARNING("There is nothing to take a sample from."))
			return
		if(prob(70))
			sampled = 1
		seed.harvest(user,get_turf(src),0,1)
		health -= (rand(3,5)*5)
		sampled = 1
		return
	else
		//Gardening tools can cut down vines quickly
		var/tool_type = null
		if (W.has_quality(QUALITY_SHOVELING))
			tool_type = QUALITY_SHOVELING
		else if (W.has_quality(QUALITY_CUTTING))
			tool_type = QUALITY_CUTTING
		else if (W.has_quality(QUALITY_WELDING))
			tool_type = QUALITY_WELDING

		if(tool_type)
			if(W.use_tool(user, src, WORKTIME_FAST*0.65, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_ROB))
				user.visible_message(SPAN_DANGER("[user] cuts down the [src]."), SPAN_DANGER("You cut down the [src]."))
				die_off()
				return
			return


		..()
		if(W.force && ! (W.flags & NOBLUDGEON))
			var/damage = W.force
			//Swords and axes are good here
			if (W.edge)
				damage *= 1.5
			health -= damage
	check_health()



/*************
	ACT PROCS
**************/
/obj/effect/plant/ex_act(severity)
	switch(severity)
		if(1.0)
			die_off()
			return
		if(2.0)
			if (prob(95))
				die_off()
				return
		if(3.0)
			if (prob(75))
				die_off()
				return
		else
	return

//Fire is instakill. Deploy flamethrowers
/obj/effect/plant/fire_act()
	health -= max_health * RAND_DECIMAL(0.5, 1.5)
	check_health()


/obj/effect/plant/proc/trodden_on(var/mob/living/victim)
	if(!is_mature())
		return
	var/mob/living/carbon/human/H = victim
	if(istype(H) && H.shoes)
		return
	seed.do_thorns(victim,src)
	seed.do_sting(victim,src,pick(BP_LEGS))

/obj/effect/plant/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_lying_buckled_and_verb_status()
		buckled_mob = null
	return

/obj/effect/plant/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(prob(seed ? min(max(0,100 - seed.get_trait(TRAIT_POTENCY)/2),100) : 50))
			if(buckled_mob.buckled == src)
				if(buckled_mob != user)
					buckled_mob.visible_message(\
						SPAN_NOTICE("[user.name] frees [buckled_mob.name] from \the [src]."),\
						SPAN_NOTICE("[user.name] frees you from \the [src]."),\
						SPAN_WARNING("You hear shredding and ripping."))
				else
					buckled_mob.visible_message(\
						SPAN_NOTICE("[buckled_mob.name] struggles free of \the [src]."),\
						SPAN_NOTICE("You untangle \the [src] from around yourself."),\
						SPAN_WARNING("You hear shredding and ripping."))
			unbuckle()
		else
			var/text = pick("rip","tear","pull")
			user.visible_message(\
				SPAN_NOTICE("[user.name] [text]s at \the [src]."),\
				SPAN_NOTICE("You [text] at \the [src]."),\
				SPAN_WARNING("You hear shredding and ripping."))
	return

/obj/effect/plant/proc/entangle(var/mob/living/victim)

	if(buckled_mob)
		return

	if(victim.buckled)
		return

	//grabbing people
	if(!victim.anchored && Adjacent(victim) && victim.loc != get_turf(src))
		var/can_grab = 1
		if(ishuman(victim))
			var/mob/living/carbon/human/H = victim
			if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP))
				can_grab = 0
		if(can_grab)
			src.visible_message(SPAN_DANGER("Tendrils lash out from \the [src] and drag \the [victim] in!"))
			victim.loc = src.loc

	//entangling people
	if(victim.loc == src.loc)
		buckle_mob(victim)
		victim.set_dir(pick(cardinal))
		to_chat(victim, "<span class='danger'>Tendrils [pick("wind", "tangle", "tighten")] around you!</span>")
