/mob/living/carbon/alien/say(var/message)
	var/verb = "says"
	var/message_range = world.view

	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "\red You cannot speak in IC (Muted).")
			return

	message = sanitize(message)

	if(stat == 2)
		return say_dead(message)

	if(copytext_char(message,1,2) == "*")
		return emote(copytext_char(message,2))

	var/datum/language/speaking = parse_language(message)

	if(speaking)
		message = copytext_char(message, 2+length(speaking.key))

	message = trim(message)

	if(!message || stat)
		return

	..(message, speaking, verb, null, null, message_range, null)
