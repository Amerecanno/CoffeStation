//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(var/message)
	if (silent)
		return

	var/last_symbol = copytext_char(message, length(message))
	if(last_symbol=="@")
		if(!src.stats.getPerk(PERK_CODESPEAK))
			to_chat(src, "You don't know the codes, pal.")
			return FALSE

	message = sanitize(message)

	if(!(container && istype(container, /obj/item/device/mmi)))
		return //No MMI, can't speak, bucko./N
	else
		var/datum/language/speaking = parse_language(message)
		if(speaking)
			message = copytext_char(message, 2+length(speaking.key))
		var/verb = "says"
		var/ending = copytext_char(message, length(message))
		if (speaking)
			verb = speaking.get_spoken_verb(ending)
		else
			if(ending=="!")
				verb=pick("exclaims","shouts","yells")
			else if(ending=="?")
				verb="asks"
			else if(ending=="@")
				verb="reports"

		if(prob(emp_damage*4))
			if(prob(10))//10% chane to drop the message entirely
				return
			else
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher

		if(speaking && speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return

		if(istype(container, /obj/item/device/mmi/radio_enabled))
			var/obj/item/device/mmi/radio_enabled/R = container
			if(R.radio)
				spawn(0) R.radio.hear_talk(src, sanitize(message), verb, speaking, getSpeechVolume())
		..(trim(message), speaking, verb)
