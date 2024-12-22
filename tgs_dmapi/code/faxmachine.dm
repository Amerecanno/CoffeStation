/obj/machinery/photocopier/faxmachine/proc/send_discord_fax(
	var/mob/sender,
	var/fax_title = "Новый факс",
	var/fax_text = "Пустое сообщение",
	var/fax_stamps = "",
	var/is_admin = FALSE
)

	var/datum/tgs_message_content/msg_content = new("")
	var/datum/tgs_chat_embed/structure/embed = new()
	msg_content.embed = embed

	var/datum/tgs_chat_embed/provider/author/embed_author = new("[key_name(sender)]")
	embed_author.icon_url = "https://icon-library.com/images/fax-icon/fax-icon-14.jpg"
	embed.author = embed_author

	embed.title = (is_admin ? "[fax_title] (админский)" : fax_title)

	embed.description = "[fax_text]\n\n*Штампы:* [fax_stamps]"

	embed.colour = is_admin ? "#ff0000" : "#34a5c2"

	embed.timestamp = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")

	var/datum/tgs_chat_embed/footer/embed_footer = new("Fax Machine v1.0")
	embed_footer.icon_url = "https://icon-library.com/images/fax-icon/fax-icon-14.jpg"
	embed.footer = embed_footer

	var/channel_to_send = is_admin ? config.channel_admin_faxes : config.channel_regular_faxes

	send2chat(msg_content, channel_to_send)

	to_chat(sender, "Ваш факс отправлен в дискорд. [is_admin ? "(Админский)" : ""]")
