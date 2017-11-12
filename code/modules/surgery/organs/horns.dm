/obj/item/organ/horns
	name = "horns"
	desc = "uh"
	zone = "head"
	slot = ORGAN_SLOT_HORNS
	gender = PLURAL

/obj/item/organ/horns/troll
	name = "troll horns"
	icon = 'icons/mob/troll_horns.dmi'
	var/horn_type = "Nubby"
	icon_state = "nubby"

/obj/item/organ/horns/troll/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	H.dna.features["horns_troll"] = horn_type
	H.update_hair()

/obj/item/organ/horns/troll/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	horn_type = H.dna.features["horns_troll"]
	icon_state = horn_type
	H.dna.features["horns_troll"] = "None"
	H.update_hair()
