/datum/tgs_chat_command/fax
	name = "fax"
	help_text = "Отправить факс из Discord в игру. Пример: discordfax department='Command' text='Hello from Discord!'"
	admin_only = TRUE

/datum/tgs_chat_command/fax/Run(datum/tgs_chat_user/sender, params)
	var/department = "[params["department"]]"
	if (!department || department == "")
		department = "Admin Fax"

	var/fax_text = "[params["text"]]"
	if (!fax_text || fax_text == "")
		fax_text = "(пустое сообщение)"

	var/obj/item/paper/P = new
	P.name = "DS Fax"
	P.info = "[fax_text]"

	var/fax_stamp = "Sent by [sender.friendly_name]"
	P.stamps += "[fax_stamp]"

	P.loc = locate("Admin Fax"):loc

	var/msg_for_admins = "[sender.friendly_name] отправил(а) факс из Discord в департамент [department]."
	message_admins(null, "DISCORD FAX", P, department, "#006100")
	log_world("[time2text(world.timeofday)] (Discord->Game fax) sender=[sender.friendly_name], department=[department], text=\"[fax_text]\"")


	return new /datum/tgs_message_content("Discord fax was successfully delivered to [department].")
