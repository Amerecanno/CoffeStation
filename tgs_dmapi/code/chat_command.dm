/datum/tgs_chat_command/fax
	name = "fax"
	help_text = "Отправить факс в игре из дискорда. Пример: !fax destination=Engineering text='Привет' signature='Captain' stamps='NT Official'"
	admin_only = FALSE

/datum/tgs_chat_command/fax/Run(datum/tgs_chat_user/sender, params)
	var/dest = params["destination"]
	var/fax_text = params["text"]
	var/signature_text = params["signature"]
	var/stamps_text = params["stamps"]

	if(!dest || !fax_text)
		return new /datum/tgs_message_content("Ошибка: нужно указать как минимум destination и text.")

	var/final_text = "[fax_text]\n\n_*[signature_text]*_"

	var/obj/item/paper/P = new
	P.name = "Fax from Discord"
	P.info = final_text

	if(stamps_text)
		P.stamp("[stamps_text]", "paper_stamp-circle", 0, -2, 2, -1)

	var/sent_ok = 0
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if(F.department == dest)
			F.copyitem = P
			if(F.recievefax(P))
				sent_ok = 1

	if(sent_ok)
		return new /datum/tgs_message_content("Факс успешно отправлен в департамент [dest].")
	else
		return new /datum/tgs_message_content("Не удалось найти факс-машину для [dest] или отправка не удалась.")
