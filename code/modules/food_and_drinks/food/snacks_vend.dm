////////////////////////////////////////////SNACKS FROM VENDING MACHINES////////////////////////////////////////////
//in other words: junk food
//don't even bother looking for recipes for these

/obj/item/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 25
	filling_color = "#D2691E"
	tastes = list("candy" = 1)
	foodtype = JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/sosjerky
	name = "\improper Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 25
	filling_color = "#8B0000"
	tastes = list("dried meat" = 1)
	foodtype = JUNKFOOD | MEAT | SUGAR

/obj/item/reagent_containers/food/snacks/sosjerky/healthy
	name = "homemade beef jerky"
	desc = "Homemade beef jerky made from the finest space cows."
	list_reagents = list("nutriment" = 3, "vitamin" = 1)
	junkiness = 0

/obj/item/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	bitesize = 1
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 20
	filling_color = "#FFD700"
	tastes = list("salt" = 1, "crisps" = 1)
	foodtype = JUNKFOOD | FRIED

/obj/item/reagent_containers/food/snacks/no_raisin
	name = "4no raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	list_reagents = list("nutriment" = 2, "sugar" = 4)
	junkiness = 25
	filling_color = "#8B0000"
	tastes = list("dried raisins" = 1)
	foodtype = JUNKFOOD | FRUIT | SUGAR

/obj/item/reagent_containers/food/snacks/no_raisin/healthy
	name = "homemade raisins"
	desc = "Homemade raisins, the best in all of spess."
	list_reagents = list("nutriment" = 3, "vitamin" = 2)
	junkiness = 0
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/spacetwinkie
	name = "space twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer than you will."
	list_reagents = list("sugar" = 4)
	junkiness = 25
	filling_color = "#FFD700"
	foodtype = JUNKFOOD | GRAIN | SUGAR

/obj/item/reagent_containers/food/snacks/cheesiehonkers
	name = "cheesie honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth."
	icon_state = "cheesie_honkers"
	trash = /obj/item/trash/cheesie
	list_reagents = list("nutriment" = 1, "sugar" = 3)
	junkiness = 25
	filling_color = "#FFD700"
	tastes = list("cheese" = 5, "crisps" = 2)
	foodtype = JUNKFOOD | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/syndicake
	name = "syndi-cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	trash = /obj/item/trash/syndi_cakes
	list_reagents = list("nutriment" = 4, "doctorsdelight" = 5)
	filling_color = "#F5F5DC"
	tastes = list("sweetness" = 3, "cake" = 1)
	foodtype = GRAIN | FRUIT | VEGETABLES

/obj/item/reagent_containers/food/snacks/gushers
	name = "tropical fruit gushers"
	icon_state = "gushers"
	desc = "These gushers come in Massive Tropical Brain Hemorrhage flavor. Could this day get any better? You don't think so."
	trash = /obj/item/trash/gushers
	filling_color = "#6A83FF"
	list_reagents = list("gusher" = 20)
	tastes = list("sweetness" = 1)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gushersphlegm
	name = "hellacious fruit gushers"
	icon_state = "gushersphlegm"
	desc = "These gushers come in Hellacious Blue Phlegm Aneurysm flavor. These should be convienent, if somewhat unappetizing."
	trash = /obj/item/trash/gushersphlegm
	filling_color = "#008ED2"
	list_reagents = list("gusherphlegm" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gushersblack
	name = "black fruit gushers"
	icon_state = "gushersblack"
	desc = "These gushers come in Bodacious Black Liquid Sorrow flavor. Another Crocker nightmare rears it's ugly head."
	trash = /obj/item/trash/gushersblack
	filling_color = "#000000" //rgb: BLAPCK
	list_reagents = list("gusherblack" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gusherssyndie
	name = "tangerine fruit gushers"
	icon_state = "gusherssyndie"
	desc = "These gushers come in Treacherous Teal Tangerine flavor. These don't look so good for you..."
	trash = /obj/item/trash/gusherssyndie
	filling color = "#10E4C5" //rgb: 16, 228, 197
	list_reagents = list("gushersyndie" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR
	
/obj/item/reagent_containers/food/snacks/gushersdiabetic
	name = "sugary fruit gushers"
	icon_state = "gushersdiabetic"
	desc = "These gushers come in Jammin Sour Diabetic Coma flavor. The nutrition label on the side says that the total carbohydrates take up 99% of the nutritious value."
	trash = /obj/item/trash/gushersdiabetic
	filling_color = "#EAEAEA" //rgb: 234, 234, 234
	list_reagents = list("gusherdiabetic" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gusherscherry
	name = "cherry fruit gushers"
	icon_state = "gusherscherry"
	desc = "These gushers come in Wild Cherry Apeshit Apocalypse flavor. You feel energetic just looking at the box."
	trash = /obj/item/trash/gusherscherry
	list_reagents = list("gushercherry" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gusherscitrus
	name = "citrus fruit gushers"
	icon_state = "gusherscitrus"
	desc = "These gushers come in Carnivorous Citrus Piss flavor. The smell makes you want to vomit."
	trash = /obj/item/trash/gusherscitrus
	list_reagents = list("gushercitrus" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gusherskiwi
	name = "kiwi fruit gushers"
	icon_state = "gusherskiwi"
	desc = "These gushers come in Xtreme Kiwi Xplosion flavor. A warning label on the front reads 'Not for the faint of heart.'"
	trash = /obj/item/trash/gusherskiwi
	list_reagents = list("gusherkiwi" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gushersstrawberry
	name = "strawberry fruit gushers"
	icon_state = "gushersstrawberry"
	desc = "These gushers come in Schizophrenic Strawberry Slam flavor. The nutrition label has been covered up in a piece of tape that reads 'touch fuzzy get dizzy.'"
	trash = /obj/item/trash/gushersstrawberry
	list_reagents = list("gusherstrawberry" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR
