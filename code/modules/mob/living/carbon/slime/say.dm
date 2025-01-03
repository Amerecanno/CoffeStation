/mob/living/carbon/slime/say(var/message)

	message = sanitize(message)
	message = capitalize(trim_left(message))
	var/verb = say_quote(message)

	if(copytext_char(message,1,2) == get_prefix_key(/decl/prefix/custom_emote))
		return emote(copytext_char(message,2))

	if(stat)
		var/last_symbol = copytext_char(message, length(message))
		if(stat == DEAD)
			return say_dead(message)
		else if(last_symbol=="@")
			if(src.stats.getPerk(PERK_CODESPEAK))
				return
			else
				to_chat(src, "You don't know the codes, pal.")
				return
		return

	return ..(message, null, verb)

/mob/living/carbon/slime/say_quote(var/text)
	var/ending = copytext_char(text, length(text))

	if (ending == "?")
		return "asks";
	else if (ending == "!")
		return "cries";

	return "chirps";

/mob/living/carbon/slime/say_understands(var/other)
	return isslime(other) || ..()

/mob/living/carbon/slime/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol, speech_volume)
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(html_decode(message)))
	..()

/mob/living/carbon/slime/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(html_decode(message)))
	..()

