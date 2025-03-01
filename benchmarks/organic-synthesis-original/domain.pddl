(define (domain Chemical)
(:requirements :strips :typing :equality)
(:types chemical_atom - object
        phosphorus calcium sulfur magnesium aluminium chromium iron manganese mercury boron copper palladium
        r_group - chemical_atom
        halogen alkalimetal hcno - r_group
        hc nitrogen oxygen - hcno
        hydrogen carbon - hc
        chlorine fluorine bromine iodine astatine - halogen
        lithium sodium potassium rubidium caesium francium - alkalimetal
        )

(:predicates
    (bond ?x - chemical_atom ?y - chemical_atom)
    (doublebond ?x - chemical_atom ?y - chemical_atom)
    (triplebond ?x - chemical_atom ?y - chemical_atom)
    (aromaticbond ?x - chemical_atom ?y - chemical_atom)
    )
	(:action AldehydeReduction
    :parameters (?al_2 - aluminium ?c_8 - carbon ?h_4 - hydrogen ?h_3 - hydrogen ?o_7 - oxygen ?h_6 - hydrogen ?h_5 - hydrogen ?li_1 - lithium ?c_9 - carbon ?h_10 - hydrogen)
    :precondition (and (not (= ?h_3 ?h_4)) (not (= ?h_3 ?h_6)) (not (= ?h_3 ?h_5)) (not (= ?h_4 ?h_6)) (not (= ?h_5 ?h_6)) (not (= ?h_4 ?h_5)) (bond ?li_1 ?al_2) (bond ?h_3 ?al_2) (bond ?h_4 ?al_2) (bond ?h_5 ?al_2) (bond ?h_6 ?al_2) (not (= ?c_8 ?c_9)) (doublebond ?o_7 ?c_8) (bond ?c_8 ?c_9) (bond ?h_10 ?c_8))
    :effect (and (not (bond ?h_3 ?al_2)) (not (bond ?al_2 ?h_3)) (not (bond ?h_4 ?al_2)) (not (bond ?al_2 ?h_4)) (bond ?h_3 ?c_8) (bond ?c_8 ?h_3) (bond ?h_4 ?o_7) (bond ?o_7 ?h_4) (not (doublebond ?o_7 ?c_8)) (not (doublebond ?c_8 ?o_7)) (bond ?o_7 ?c_8) (bond ?c_8 ?o_7)))

	
	(:action AldolCondensation
    :parameters (?o_4 - oxygen ?o_15 - oxygen ?na_14 - sodium ?h_8 - hydrogen ?h_9 - hydrogen ?c_1 - carbon ?c_5 - carbon ?o_10 - oxygen ?h_11 - hydrogen ?h_12 - hydrogen ?h_13 - hydrogen ?r1_2 - r_group ?r1_3 - r_group ?o_7 - oxygen ?c_6 - carbon)
    :precondition (and (not (= ?c_1 ?c_5)) (not (= ?h_11 ?h_8)) (not (= ?h_11 ?h_9)) (not (= ?h_8 ?h_9)) (not (= ?o_4 ?o_10)) (not (= ?o_4 ?o_15)) (not (= ?o_10 ?o_15)) (not (= ?h_11 ?h_12)) (bond ?o_10 ?h_11) (bond ?o_10 ?h_12) (bond ?na_14 ?o_15) (bond ?h_13 ?o_15) (not (= ?r1_2 ?r1_3)) (bond ?r1_2 ?c_1) (bond ?r1_3 ?c_1) (doublebond ?o_4 ?c_1) (not (= ?h_9 ?h_8)) (not (= ?c_6 ?c_5)) (bond ?c_6 ?c_5) (bond ?h_9 ?c_5) (bond ?h_8 ?c_5) (doublebond ?o_7 ?c_6))
    :effect (and (not (doublebond ?o_4 ?c_1)) (not (doublebond ?c_1 ?o_4)) (doublebond ?c_1 ?c_5) (doublebond ?c_5 ?c_1) (bond ?h_11 ?o_4) (bond ?o_4 ?h_11) (bond ?na_14 ?o_4) (bond ?o_4 ?na_14) (not (bond ?h_8 ?c_5)) (not (bond ?c_5 ?h_8)) (not (bond ?h_9 ?c_5)) (not (bond ?c_5 ?h_9)) (bond ?o_10 ?h_8) (bond ?h_8 ?o_10) (bond ?h_9 ?o_15) (bond ?o_15 ?h_9) (not (bond ?o_10 ?h_11)) (not (bond ?h_11 ?o_10)) (not (bond ?na_14 ?o_15)) (not (bond ?o_15 ?na_14))))

	(:action AlkylationOfBetaDicarbonyl
    :parameters (?r1_2 - halogen ?c_1 - carbon ?h_6 - hydrogen ?c_4 - carbon ?c_3 - carbon ?c_5 - carbon ?o_7 - oxygen ?o_8 - oxygen)
    :precondition (and (not (= ?c_1 ?c_4)) (bond ?r1_2 ?c_1) (not (= ?c_3 ?c_4)) (not (= ?o_7 ?o_8)) (not (= ?c_4 ?c_5)) (not (= ?c_3 ?c_5)) (bond ?c_3 ?c_4) (doublebond ?c_3 ?o_7) (bond ?c_4 ?c_5) (bond ?h_6 ?c_4) (doublebond ?c_5 ?o_8))
    :effect (and (not (bond ?r1_2 ?c_1)) (not (bond ?c_1 ?r1_2)) (bond ?c_1 ?c_4) (bond ?c_4 ?c_1) (bond ?r1_2 ?h_6) (bond ?h_6 ?r1_2) (not (bond ?h_6 ?c_4)) (not (bond ?c_4 ?h_6))))

	(:action AmideSynthesisFromAcidChloride
    :parameters (?n_5 - nitrogen ?c_2 - carbon ?cl_1 - chlorine ?h_8 - hydrogen ?o_4 - oxygen ?c_3 - carbon ?h_7 - hydrogen ?c_6 - carbon)
    :precondition (and (not (= ?c_2 ?c_3)) (bond ?c_2 ?cl_1) (bond ?c_3 ?c_2) (doublebond ?o_4 ?c_2) (not (= ?h_7 ?h_8)) (bond ?h_7 ?n_5) (bond ?h_8 ?n_5) (bond ?c_6 ?n_5))
    :effect (and (not (bond ?c_2 ?cl_1)) (not (bond ?cl_1 ?c_2)) (bond ?h_8 ?cl_1) (bond ?cl_1 ?h_8) (bond ?c_2 ?n_5) (bond ?n_5 ?c_2) (not (bond ?h_8 ?n_5)) (not (bond ?n_5 ?h_8))))

	(:action AmideSynthesisFromAcidHalides
    :parameters (?c_1 - carbon ?h_6 - hydrogen ?n_8 - nitrogen ?r1_4 - halogen ?c_2 - carbon ?o_3 - oxygen ?h_7 - hydrogen ?h_5 - hydrogen)
    :precondition (and (not (= ?c_1 ?c_2)) (bond ?r1_4 ?c_1) (bond ?c_2 ?c_1) (doublebond ?o_3 ?c_1) (not (= ?h_6 ?h_7)) (not (= ?h_5 ?h_7)) (not (= ?h_5 ?h_6)) (bond ?h_5 ?n_8) (bond ?h_6 ?n_8) (bond ?h_7 ?n_8))
    :effect (and (not (bond ?r1_4 ?c_1)) (not (bond ?c_1 ?r1_4)) (bond ?n_8 ?c_1) (bond ?c_1 ?n_8) (bond ?h_6 ?r1_4) (bond ?r1_4 ?h_6) (not (bond ?h_6 ?n_8)) (not (bond ?n_8 ?h_6))))

	(:action AromaticBromination
    :parameters (?br_5 - bromine ?h_13 - hydrogen ?br_6 - bromine ?c_7 - carbon ?br_1 - bromine ?br_3 - bromine ?fe_4 - iron ?br_2 - bromine ?c_9 - carbon ?c_8 - carbon ?c_11 - carbon ?c_10 - carbon ?c_12 - carbon)
    :precondition (and (not (= ?br_5 ?br_6)) (not (= ?br_1 ?br_3)) (not (= ?br_2 ?br_3)) (not (= ?br_1 ?br_2)) (bond ?br_1 ?fe_4) (bond ?fe_4 ?br_2) (bond ?fe_4 ?br_3) (bond ?br_5 ?br_6) (not (= ?c_10 ?c_12)) (not (= ?c_7 ?c_10)) (not (= ?c_9 ?c_11)) (not (= ?c_7 ?c_12)) (not (= ?c_8 ?c_12)) (not (= ?c_8 ?c_11)) (not (= ?c_8 ?c_10)) (not (= ?c_8 ?c_9)) (not (= ?c_9 ?c_12)) (not (= ?c_7 ?c_8)) (not (= ?c_10 ?c_11)) (not (= ?c_10 ?c_9)) (not (= ?c_7 ?c_11)) (not (= ?c_12 ?c_11)) (not (= ?c_7 ?c_9)) (bond ?h_13 ?c_7) (aromaticbond ?c_7 ?c_8) (aromaticbond ?c_10 ?c_7) (aromaticbond ?c_8 ?c_9) (aromaticbond ?c_9 ?c_12) (aromaticbond ?c_11 ?c_10) (aromaticbond ?c_12 ?c_11))
    :effect (and (not (bond ?br_5 ?br_6)) (not (bond ?br_6 ?br_5)) (bond ?br_5 ?h_13) (bond ?h_13 ?br_5) (bond ?br_6 ?c_7) (bond ?c_7 ?br_6) (not (bond ?h_13 ?c_7)) (not (bond ?c_7 ?h_13))))
	
	(:action AromaticNitration
    :parameters (?o_12 - oxygen ?n_1 - nitrogen ?h_8 - hydrogen ?c_3 - carbon ?o_6 - oxygen ?h_10 - hydrogen ?c_2 - carbon ?o_5 - oxygen ?o_4 - oxygen ?h_9 - hydrogen ?s_15 - sulfur ?h_7 - hydrogen ?o_13 - oxygen ?o_14 - oxygen ?o_11 - oxygen)
    :precondition (and (not (= ?h_10 ?h_8)) (not (= ?o_6 ?o_12)) (not (= ?c_3 ?c_2)) (bond ?c_3 ?h_10) (aromaticbond ?c_2 ?c_3) (not (= ?o_5 ?o_4)) (not (= ?o_6 ?o_4)) (not (= ?o_6 ?o_5)) (bond ?o_6 ?h_9) (bond ?n_1 ?o_6) (bond ?n_1 ?o_5) (doublebond ?n_1 ?o_4) (not (= ?o_12 ?o_14)) (not (= ?o_12 ?o_11)) (not (= ?h_8 ?h_7)) (not (= ?o_14 ?o_13)) (not (= ?o_12 ?o_13)) (not (= ?o_14 ?o_11)) (not (= ?o_11 ?o_13)) (bond ?o_12 ?h_8) (bond ?o_14 ?h_7) (doublebond ?s_15 ?o_11) (bond ?s_15 ?o_12) (doublebond ?s_15 ?o_13) (bond ?s_15 ?o_14))
    :effect (and (bond ?n_1 ?c_3) (bond ?c_3 ?n_1) (not (bond ?n_1 ?o_6)) (not (bond ?o_6 ?n_1)) (not (bond ?c_3 ?h_10)) (not (bond ?h_10 ?c_3)) (bond ?o_6 ?h_8) (bond ?h_8 ?o_6) (not (bond ?o_12 ?h_8)) (not (bond ?h_8 ?o_12)) (bond ?o_12 ?h_10) (bond ?h_10 ?o_12)))

	(:action CatalyticHydrogenationOfAlkenes
    :parameters (?c_3 - carbon ?h_5 - hydrogen ?c_4 - carbon ?pd_1 - palladium ?h_6 - hydrogen)
    :precondition (and (not (= ?c_4 ?c_3)) (doublebond ?c_4 ?c_3) (not (= ?h_5 ?h_6)) (bond ?h_5 ?h_6))
    :effect (and (not (doublebond ?c_4 ?c_3)) (not (doublebond ?c_3 ?c_4)) (not (bond ?h_5 ?h_6)) (not (bond ?h_6 ?h_5)) (bond ?c_4 ?c_3) (bond ?c_3 ?c_4) (bond ?h_5 ?c_3) (bond ?c_3 ?h_5) (bond ?h_6 ?c_4) (bond ?c_4 ?h_6)))

	(:action CatalyticHydrogenationOfNitriles
    :parameters (?h_6 - hydrogen ?h_7 - hydrogen ?h_4 - hydrogen ?h_5 - hydrogen ?n_1 - nitrogen ?c_2 - carbon ?c_3 - carbon)
    :precondition (and (not (= ?h_4 ?h_6)) (not (= ?h_4 ?h_5)) (not (= ?h_4 ?h_7)) (not (= ?h_6 ?h_5)) (not (= ?h_6 ?h_7)) (not (= ?h_5 ?h_7)) (not (= ?c_2 ?c_3)) (triplebond ?c_2 ?n_1) (bond ?c_2 ?c_3) (bond ?h_4 ?h_5) (bond ?h_6 ?h_7))
    :effect (and (not (triplebond ?c_2 ?n_1)) (not (triplebond ?n_1 ?c_2)) (bond ?c_2 ?n_1) (bond ?n_1 ?c_2) (bond ?h_4 ?n_1) (bond ?n_1 ?h_4) (bond ?h_6 ?n_1) (bond ?n_1 ?h_6) (bond ?h_5 ?c_2) (bond ?c_2 ?h_5) (bond ?h_7 ?c_2) (bond ?c_2 ?h_7) (not (bond ?h_4 ?h_5)) (not (bond ?h_5 ?h_4)) (not (bond ?h_6 ?h_7)) (not (bond ?h_7 ?h_6))))
	
	(:action CatalyticHydrogenationOfNitroGroup
    :parameters (?h_6 - hydrogen ?h_7 - hydrogen ?h_5 - hydrogen ?o_1 - oxygen ?o_2 - oxygen ?h_8 - hydrogen ?h_9 - hydrogen ?h_10 - hydrogen ?n_3 - nitrogen ?c_4 - carbon)
    :precondition (and (not (= ?h_7 ?h_8)) (not (= ?h_7 ?h_9)) (not (= ?h_7 ?h_10)) (not (= ?h_7 ?h_5)) (not (= ?h_7 ?h_6)) (not (= ?h_8 ?h_9)) (not (= ?h_8 ?h_10)) (not (= ?h_8 ?h_5)) (not (= ?h_8 ?h_6)) (not (= ?h_9 ?h_10)) (not (= ?h_9 ?h_5)) (not (= ?h_9 ?h_6)) (not (= ?h_10 ?h_5)) (not (= ?h_10 ?h_6)) (not (= ?h_5 ?h_6)) (not (= ?o_1 ?o_2)) (doublebond ?o_1 ?n_3) (bond ?o_2 ?n_3) (bond ?n_3 ?c_4) (bond ?h_5 ?h_6) (not (= ?h_8 ?h_7)) (bond ?h_8 ?h_7) (not (= ?h_10 ?h_9)) (bond ?h_10 ?h_9))
    :effect (and (not (doublebond ?o_1 ?n_3)) (not (doublebond ?n_3 ?o_1)) (bond ?o_1 ?h_7) (bond ?h_7 ?o_1) (bond ?o_1 ?h_8) (bond ?h_8 ?o_1) (not (bond ?o_2 ?n_3)) (not (bond ?n_3 ?o_2)) (bond ?o_2 ?h_9) (bond ?h_9 ?o_2) (bond ?o_2 ?h_10) (bond ?h_10 ?o_2) (bond ?n_3 ?h_5) (bond ?h_5 ?n_3) (bond ?h_6 ?n_3) (bond ?n_3 ?h_6) (not (bond ?h_5 ?h_6)) (not (bond ?h_6 ?h_5)) (not (bond ?h_8 ?h_7)) (not (bond ?h_7 ?h_8)) (not (bond ?h_10 ?h_9)) (not (bond ?h_9 ?h_10))))
	
	(:action ClaisenCondensation
    :parameters (?o_11 - oxygen ?o_14 - oxygen ?h_1 - hydrogen ?c_2 - carbon ?na_13 - sodium ?c_9 - carbon ?o_5 - oxygen ?o_4 - oxygen ?c_3 - carbon ?r1_6 - r_group ?r2_8 - r_group ?r1_12 - r_group ?o_10 - oxygen ?r1_15 - r_group)
    :precondition (and (not (= ?c_2 ?c_9)) (not (= ?o_14 ?o_11)) (not (= ?o_5 ?o_4)) (not (= ?c_2 ?c_3)) (bond ?c_2 ?h_1) (bond ?o_5 ?r1_6) (bond ?o_5 ?c_3) (doublebond ?c_3 ?o_4) (bond ?c_3 ?c_2) (not (= ?o_11 ?o_10)) (bond ?o_11 ?r1_12) (bond ?c_9 ?r2_8) (bond ?c_9 ?o_11) (doublebond ?o_10 ?c_9) (bond ?o_14 ?na_13) (bond ?r1_15 ?o_14))
    :effect (and (not (bond ?c_2 ?h_1)) (not (bond ?h_1 ?c_2)) (bond ?h_1 ?o_14) (bond ?o_14 ?h_1) (bond ?c_9 ?c_2) (bond ?c_2 ?c_9) (not (bond ?c_9 ?o_11)) (not (bond ?o_11 ?c_9)) (bond ?o_11 ?na_13) (bond ?na_13 ?o_11) (not (bond ?o_14 ?na_13)) (not (bond ?na_13 ?o_14))))

	(:action CyanideDisplacementOfBromideSN2
    :parameters (?r1_3 - alkalimetal ?c_2 - carbon ?c_5 - carbon ?r2_4 - halogen ?n_1 - nitrogen)
    :precondition (and (not (= ?c_2 ?c_5)) (triplebond ?c_2 ?n_1) (bond ?c_2 ?r1_3) (bond ?r2_4 ?c_5))
    :effect (and (not (bond ?c_2 ?r1_3)) (not (bond ?r1_3 ?c_2)) (bond ?c_2 ?c_5) (bond ?c_5 ?c_2) (bond ?r1_3 ?r2_4) (bond ?r2_4 ?r1_3) (not (bond ?r2_4 ?c_5)) (not (bond ?c_5 ?r2_4))))
	
	(:action CyanideDisplacementOfTosylGroupSN2
    :parameters (?o_5 - oxygen ?r1_3 - alkaliMetal ?c_2 - carbon ?c_8 - carbon ?n_1 - nitrogen ?c_9 - carbon ?o_7 - oxygen ?o_6 - oxygen ?s_4 - sulfur)
    :precondition (and (not (= ?c_2 ?c_8)) (bond ?r1_3 ?c_2) (triplebond ?c_2 ?n_1) (not (= ?o_5 ?o_6)) (not (= ?c_9 ?c_8)) (not (= ?o_7 ?o_6)) (not (= ?o_5 ?o_7)) (bond ?c_9 ?s_4) (bond ?c_8 ?o_5) (doublebond ?s_4 ?o_7) (doublebond ?o_6 ?s_4) (bond ?o_5 ?s_4))
    :effect (and (not (bond ?r1_3 ?c_2)) (not (bond ?c_2 ?r1_3)) (bond ?c_8 ?c_2) (bond ?c_2 ?c_8) (bond ?o_5 ?r1_3) (bond ?r1_3 ?o_5) (not (bond ?c_8 ?o_5)) (not (bond ?o_5 ?c_8))))

	(:action CyanohydrinFormation
    :parameters (?o_4 - oxygen ?c_2 - carbon ?c_5 - carbon ?r2_3 - chemical_atom ?n_1 - nitrogen ?r1_6 - hc ?r1_7 - hc)
    :precondition (and (not (= ?c_2 ?c_5)) (triplebond ?n_1 ?c_2) (bond ?r2_3 ?c_2) (not (= ?r1_6 ?r1_7)) (doublebond ?o_4 ?c_5) (bond ?r1_6 ?c_5) (bond ?c_5 ?r1_7))
    :effect (and (not (bond ?r2_3 ?c_2)) (not (bond ?c_2 ?r2_3)) (bond ?c_2 ?c_5) (bond ?c_5 ?c_2) (bond ?o_4 ?r2_3) (bond ?r2_3 ?o_4) (not (doublebond ?o_4 ?c_5)) (not (doublebond ?c_5 ?o_4)) (bond ?o_4 ?c_5) (bond ?c_5 ?o_4)))
		
	(:action DecarboxylationOfBetaKetoEsters
    :parameters (?o_10 - oxygen ?o_1 - oxygen ?h_3 - hydrogen ?c_4 - carbon ?c_7 - carbon ?h_2 - hydrogen ?o_11 - oxygen ?o_9 - oxygen ?c_8 - carbon ?c_5 - carbon ?c_6 - carbon)
    :precondition (and (not (= ?c_7 ?c_4)) (not (= ?h_2 ?h_3)) (not (= ?o_1 ?o_10)) (not (= ?h_3 ?h_2)) (bond ?h_3 ?o_1) (bond ?h_2 ?o_1) (not (= ?o_9 ?o_10)) (not (= ?o_9 ?o_11)) (not (= ?o_10 ?o_11)) (not (= ?c_5 ?c_7)) (not (= ?c_5 ?c_6)) (not (= ?c_4 ?c_7)) (not (= ?c_7 ?c_6)) (not (= ?c_4 ?c_8)) (not (= ?c_7 ?c_8)) (not (= ?c_6 ?c_8)) (not (= ?c_5 ?c_4)) (not (= ?c_4 ?c_6)) (not (= ?c_5 ?c_8)) (bond ?c_5 ?c_4) (bond ?c_7 ?c_4) (bond ?c_5 ?c_6) (doublebond ?o_9 ?c_5) (bond ?o_10 ?c_7) (doublebond ?o_11 ?c_7) (bond ?c_8 ?o_10))
    :effect (and (not (bond ?h_2 ?o_1)) (not (bond ?o_1 ?h_2)) (not (bond ?h_3 ?o_1)) (not (bond ?o_1 ?h_3)) (doublebond ?o_1 ?c_7) (doublebond ?c_7 ?o_1) (bond ?h_2 ?o_10) (bond ?o_10 ?h_2) (bond ?h_3 ?c_4) (bond ?c_4 ?h_3) (not (bond ?c_7 ?c_4)) (not (bond ?c_4 ?c_7)) (not (bond ?o_10 ?c_7)) (not (bond ?c_7 ?o_10))))
	
	(:action DehydrationOfAmides
    :parameters (?cl_2 - chlorine ?n_6 - nitrogen ?o_9 - oxygen ?c_7 - carbon ?h_10 - hydrogen ?h_11 - hydrogen ?p_1 - phosphorus ?o_5 - oxygen ?cl_4 - chlorine ?cl_3 - chlorine ?r1_8 - chemical_atom)
    :precondition (and (not (= ?h_11 ?h_10)) (not (= ?cl_4 ?cl_3)) (not (= ?cl_3 ?cl_2)) (not (= ?cl_4 ?cl_2)) (doublebond ?o_5 ?p_1) (bond ?cl_4 ?p_1) (bond ?cl_3 ?p_1) (bond ?cl_2 ?p_1) (bond ?h_11 ?n_6) (bond ?h_10 ?n_6) (doublebond ?o_9 ?c_7) (bond ?r1_8 ?c_7) (bond ?n_6 ?c_7))
    :effect (and (not (bond ?cl_2 ?p_1)) (not (bond ?p_1 ?cl_2)) (bond ?o_9 ?p_1) (bond ?p_1 ?o_9) (bond ?cl_2 ?h_11) (bond ?h_11 ?cl_2) (not (bond ?n_6 ?c_7)) (not (bond ?c_7 ?n_6)) (triplebond ?n_6 ?c_7) (triplebond ?c_7 ?n_6) (not (bond ?h_10 ?n_6)) (not (bond ?n_6 ?h_10)) (not (bond ?h_11 ?n_6)) (not (bond ?n_6 ?h_11)) (not (doublebond ?o_9 ?c_7)) (not (doublebond ?c_7 ?o_9)) (bond ?h_10 ?o_9) (bond ?o_9 ?h_10)))

	(:action Diazotization
    :parameters (?h_7 - hydrogen ?o_6 - oxygen ?n_9 - nitrogen ?o_3 - oxygen ?h_1 - hydrogen ?n_5 - nitrogen ?cl_2 - chlorine ?h_8 - hydrogen ?na_4 - sodium ?c_10 - carbon)
    :precondition (and (not (= ?o_3 ?o_6)) (not (= ?h_1 ?h_7)) (not (= ?h_1 ?h_8)) (not (= ?h_7 ?h_8)) (not (= ?n_5 ?n_9)) (bond ?h_1 ?cl_2) (bond ?o_3 ?na_4) (bond ?o_3 ?n_5) (doublebond ?n_5 ?o_6) (not (= ?h_8 ?h_7)) (bond ?n_9 ?c_10) (bond ?h_8 ?n_9) (bond ?h_7 ?n_9))
    :effect (and (not (bond ?h_1 ?cl_2)) (not (bond ?cl_2 ?h_1)) (bond ?cl_2 ?n_5) (bond ?n_5 ?cl_2) (not (bond ?o_3 ?n_5)) (not (bond ?n_5 ?o_3)) (not (doublebond ?n_5 ?o_6)) (not (doublebond ?o_6 ?n_5)) (triplebond ?n_5 ?n_9) (triplebond ?n_9 ?n_5) (not (bond ?h_7 ?n_9)) (not (bond ?n_9 ?h_7)) (not (bond ?h_8 ?n_9)) (not (bond ?n_9 ?h_8))))
	
	(:action DieckmannCyclization
    :parameters (?o_16 - oxygen ?c_14 - carbon ?c_2 - carbon ?h_1 - hydrogen ?o_4 - oxygen ?r1_9 - chemical_atom ?o_15 - oxygen ?c_11 - carbon ?r2_17 - chemical_atom ?r1_6 - chemical_atom ?r1_7 - chemical_atom ?c_3 - carbon ?c_5 - carbon ?r1_10 - chemical_atom ?c_8 - carbon ?r1_12 - chemical_atom ?r1_13 - chemical_atom)
    :precondition (and (not (= ?c_2 ?c_14)) (not (= ?c_3 ?c_14)) (not (= ?r1_7 ?r1_6)) (not (= ?r1_9 ?r1_13)) (not (= ?r1_6 ?r1_9)) (not (= ?r1_9 ?r1_12)) (not (= ?o_4 ?o_15)) (not (= ?r1_9 ?r1_10)) (not (= ?r1_10 ?r1_13)) (not (= ?c_2 ?c_5)) (not (= ?c_2 ?c_3)) (not (= ?r1_7 ?r1_12)) (not (= ?c_8 ?c_11)) (not (= ?o_16 ?o_15)) (not (= ?c_3 ?c_11)) (not (= ?c_3 ?c_8)) (not (= ?r1_6 ?r1_12)) (not (= ?c_11 ?c_14)) (not (= ?c_5 ?c_8)) (not (= ?r1_6 ?r1_10)) (not (= ?c_5 ?c_11)) (not (= ?c_2 ?c_8)) (not (= ?c_3 ?c_5)) (not (= ?r1_7 ?r1_10)) (not (= ?c_2 ?c_11)) (not (= ?c_8 ?c_14)) (not (= ?r1_7 ?r1_9)) (not (= ?r1_13 ?r1_12)) (not (= ?r1_7 ?r1_13)) (not (= ?c_5 ?c_14)) (not (= ?r1_10 ?r1_12)) (not (= ?r1_6 ?r1_13)) (not (= ?o_4 ?o_16)) (bond ?h_1 ?c_2) (bond ?c_2 ?c_3) (bond ?c_3 ?c_5) (doublebond ?o_4 ?c_3) (bond ?c_5 ?r1_7) (bond ?c_5 ?r1_6) (bond ?c_5 ?c_8) (bond ?c_8 ?r1_9) (bond ?r1_10 ?c_8) (bond ?c_8 ?c_11) (bond ?c_11 ?r1_13) (bond ?c_11 ?r1_12) (bond ?c_11 ?c_14) (bond ?c_14 ?o_16) (doublebond ?o_15 ?c_14) (bond ?o_16 ?r2_17))
    :effect (and (not (bond ?h_1 ?c_2)) (not (bond ?c_2 ?h_1)) (bond ?o_16 ?h_1) (bond ?h_1 ?o_16) (bond ?c_14 ?c_2) (bond ?c_2 ?c_14) (not (bond ?c_14 ?o_16)) (not (bond ?o_16 ?c_14))))
	
	(:action DielsAlderCycloaddition
    :parameters (?c_1 - carbon ?c_3 - carbon ?c_2 - carbon ?c_5 - carbon ?c_4 - carbon ?c_6 - carbon )
    :precondition (and (not (= ?c_1 ?c_2)) (not (= ?c_1 ?c_4)) (not (= ?c_1 ?c_3)) (not (= ?c_1 ?c_6)) (not (= ?c_1 ?c_5)) (not (= ?c_2 ?c_4)) (not (= ?c_2 ?c_3)) (not (= ?c_2 ?c_6)) (not (= ?c_2 ?c_5)) (not (= ?c_4 ?c_3)) (not (= ?c_4 ?c_6)) (not (= ?c_4 ?c_5)) (not (= ?c_3 ?c_6)) (not (= ?c_3 ?c_5)) (not (= ?c_6 ?c_5)) (bond ?c_1 ?c_2) (doublebond ?c_4 ?c_1) (doublebond ?c_3 ?c_2) (doublebond ?c_6 ?c_5))
    :effect (and (not (bond ?c_1 ?c_2)) (not (bond ?c_2 ?c_1)) (doublebond ?c_1 ?c_2) (doublebond ?c_2 ?c_1) (not (doublebond ?c_4 ?c_1)) (not (doublebond ?c_1 ?c_4)) (bond ?c_4 ?c_1) (bond ?c_1 ?c_4) (not (doublebond ?c_3 ?c_2)) (not (doublebond ?c_2 ?c_3)) (bond ?c_3 ?c_2) (bond ?c_2 ?c_3) (bond ?c_6 ?c_3) (bond ?c_3 ?c_6) (bond ?c_4 ?c_5) (bond ?c_5 ?c_4) (not (doublebond ?c_6 ?c_5)) (not (doublebond ?c_5 ?c_6)) (bond ?c_6 ?c_5) (bond ?c_5 ?c_6)))

	
	(:action EnolateAttackOnAlkylHalideSN2
    :parameters (?o_4 - oxygen ?r1_1 - halogen ?r2_3 - alkaliMetal ?c_2 - carbon ?c_5 - carbon ?c_6 - carbon )
    :precondition (and (not (= ?c_2 ?c_5)) (not (= ?c_2 ?c_6)) (not (= ?c_5 ?c_6)) (bond ?r1_1 ?c_2) (not (= ?c_6 ?c_5)) (bond ?c_6 ?o_4) (doublebond ?c_6 ?c_5) (bond ?r2_3 ?o_4))
    :effect (and (not (bond ?r1_1 ?c_2)) (not (bond ?c_2 ?r1_1)) (bond ?r2_3 ?r1_1) (bond ?r1_1 ?r2_3) (bond ?c_2 ?c_5) (bond ?c_5 ?c_2) (not (bond ?r2_3 ?o_4)) (not (bond ?o_4 ?r2_3)) (not (bond ?c_6 ?o_4)) (not (bond ?o_4 ?c_6)) (doublebond ?c_6 ?o_4) (doublebond ?o_4 ?c_6) (not (doublebond ?c_6 ?c_5)) (not (doublebond ?c_5 ?c_6)) (bond ?c_6 ?c_5) (bond ?c_5 ?c_6)))

	
	(:action EnolatecAlkylation
    :parameters (?c_21 - carbon ?h_8 - hydrogen ?h_7 - hydrogen ?c_1 - carbon ?c_4 - carbon ?li_18 - lithium ?n_17 - nitrogen ?br_7 - bromine ?br_6 - bromine ?r1_9 - chemical_atom ?c_2 - carbon ?r2_10 - chemical_atom ?o_3 - oxygen ?c_19 - carbon ?c_5 - carbon ?c_20 - carbon ?c_15 - carbon ?c_14 - carbon ?c_16 - carbon ?c_11 - carbon ?c_13 - carbon ?c_12 - carbon)
    :precondition (and (not (= ?c_4 ?c_1)) (not (= ?c_4 ?c_21)) (not (= ?c_1 ?c_21)) (not (= ?br_6 ?br_7)) (not (= ?c_1 ?c_2)) (not (= ?r2_10 ?r1_9)) (not (= ?h_8 ?h_7)) (bond ?h_8 ?c_1) (bond ?h_7 ?c_1) (doublebond ?o_3 ?c_2) (bond ?c_1 ?c_2) (bond ?c_2 ?r2_10) (bond ?r1_9 ?c_1) (not (= ?c_4 ?c_20)) (not (= ?c_5 ?c_20)) (not (= ?br_7 ?br_6)) (not (= ?c_21 ?c_19)) (not (= ?c_19 ?c_20)) (not (= ?c_4 ?c_5)) (not (= ?c_21 ?c_4)) (not (= ?c_21 ?c_20)) (not (= ?c_21 ?c_5)) (not (= ?c_4 ?c_19)) (not (= ?c_5 ?c_19)) (bond ?c_21 ?br_7) (bond ?br_6 ?c_4) (bond ?c_4 ?c_5) (bond ?c_5 ?c_19) (bond ?c_20 ?c_19) (bond ?c_20 ?c_21) (not (= ?c_15 ?c_14)) (not (= ?c_15 ?c_13)) (not (= ?c_16 ?c_12)) (not (= ?c_12 ?c_13)) (not (= ?c_15 ?c_11)) (not (= ?c_11 ?c_13)) (not (= ?c_15 ?c_16)) (not (= ?c_14 ?c_11)) (not (= ?c_14 ?c_13)) (not (= ?c_14 ?c_12)) (not (= ?c_15 ?c_12)) (not (= ?c_16 ?c_13)) (not (= ?c_16 ?c_11)) (not (= ?c_14 ?c_16)) (not (= ?c_12 ?c_11)) (bond ?c_15 ?c_14) (bond ?c_16 ?c_15) (bond ?c_15 ?n_17) (bond ?n_17 ?li_18) (bond ?n_17 ?c_12) (bond ?c_12 ?c_11) (bond ?c_13 ?c_12))
    :effect (and (bond ?c_4 ?c_1) (bond ?c_1 ?c_4) (not (bond ?h_8 ?c_1)) (not (bond ?c_1 ?h_8)) (bond ?c_21 ?c_1) (bond ?c_1 ?c_21) (not (bond ?h_7 ?c_1)) (not (bond ?c_1 ?h_7)) (not (bond ?br_6 ?c_4)) (not (bond ?c_4 ?br_6)) (bond ?br_7 ?li_18) (bond ?li_18 ?br_7) (not (bond ?c_21 ?br_7)) (not (bond ?br_7 ?c_21)) (bond ?n_17 ?h_8) (bond ?h_8 ?n_17) (not (bond ?n_17 ?li_18)) (not (bond ?li_18 ?n_17))))
	
	(:action EnolateFormation
    :parameters (?o_13 - oxygen ?n_7 - nitrogen ?c_12 - carbon ?li_8 - lithium ?c_9 - carbon ?h_11 - hydrogen ?c_1 - carbon ?c_3 - carbon ?c_2 - carbon ?c_5 - carbon ?c_4 - carbon ?c_6 - carbon ?c_10 - carbon)
    :precondition (and (not (= ?c_9 ?c_12)) (not (= ?c_2 ?c_4)) (not (= ?c_2 ?c_5)) (not (= ?c_2 ?c_3)) (not (= ?c_1 ?c_5)) (not (= ?c_2 ?c_1)) (not (= ?c_5 ?c_6)) (not (= ?c_3 ?c_4)) (not (= ?c_4 ?c_5)) (not (= ?c_1 ?c_4)) (not (= ?c_3 ?c_5)) (not (= ?c_1 ?c_6)) (not (= ?c_3 ?c_6)) (not (= ?c_1 ?c_3)) (not (= ?c_4 ?c_6)) (not (= ?c_2 ?c_6)) (bond ?c_2 ?c_1) (bond ?n_7 ?c_2) (bond ?c_2 ?c_3) (bond ?n_7 ?c_4) (bond ?c_4 ?c_5) (bond ?c_4 ?c_6) (bond ?li_8 ?n_7) (not (= ?c_10 ?c_12)) (not (= ?c_10 ?c_9)) (bond ?c_10 ?c_9) (bond ?c_9 ?c_12) (doublebond ?c_9 ?o_13) (bond ?h_11 ?c_12))
    :effect (and (not (bond ?li_8 ?n_7)) (not (bond ?n_7 ?li_8)) (bond ?h_11 ?n_7) (bond ?n_7 ?h_11) (bond ?o_13 ?li_8) (bond ?li_8 ?o_13) (not (bond ?c_9 ?c_12)) (not (bond ?c_12 ?c_9)) (doublebond ?c_9 ?c_12) (doublebond ?c_12 ?c_9) (not (doublebond ?c_9 ?o_13)) (not (doublebond ?o_13 ?c_9)) (bond ?c_9 ?o_13) (bond ?o_13 ?c_9) (not (bond ?h_11 ?c_12)) (not (bond ?c_12 ?h_11))))

	(:action FischerEsterification
    :parameters (?h_7 - hydrogen ?c_3 - carbon ?o_6 - oxygen ?o_1 - oxygen ?h_5 - hydrogen ?c_4 - carbon ?o_2 - oxygen ?c_8 - carbon)
    :precondition (and (not (= ?o_1 ?o_6)) (not (= ?c_3 ?c_4)) (not (= ?o_1 ?o_2)) (bond ?h_5 ?o_1) (bond ?c_3 ?o_1) (doublebond ?o_2 ?c_3) (bond ?c_4 ?c_3) (bond ?o_6 ?c_8) (bond ?h_7 ?o_6))
    :effect (and (not (bond ?c_3 ?o_1)) (not (bond ?o_1 ?c_3)) (bond ?h_7 ?o_1) (bond ?o_1 ?h_7) (bond ?c_3 ?o_6) (bond ?o_6 ?c_3) (not (bond ?h_7 ?o_6)) (not (bond ?o_6 ?h_7))))	
	
	(:action FriedelCraftsAcylation
    :parameters (?h_9 - hydrogen ?cl_8 - chlorine ?c_10 - carbon ?c_6 - carbon ?cl_1 - chlorine ?cl_2 - chlorine ?al_4 - aluminium ?cl_3 - chlorine ?o_7 - oxygen ?c_5 - carbon ?c_15 - carbon ?c_14 - carbon ?c_11 - carbon ?c_13 - carbon ?c_12 - carbon)
    :precondition (and (not (= ?c_6 ?c_10)) (not (= ?cl_3 ?cl_1)) (not (= ?cl_3 ?cl_2)) (not (= ?cl_2 ?cl_1)) (bond ?cl_3 ?al_4) (bond ?cl_2 ?al_4) (bond ?cl_1 ?al_4) (not (= ?c_6 ?c_5)) (doublebond ?c_6 ?o_7) (bond ?c_6 ?cl_8) (bond ?c_5 ?c_6) (not (= ?c_10 ?c_12)) (not (= ?c_10 ?c_11)) (not (= ?c_11 ?c_12)) (not (= ?c_11 ?c_13)) (not (= ?c_13 ?c_14)) (not (= ?c_13 ?c_15)) (not (= ?c_12 ?c_15)) (not (= ?c_12 ?c_14)) (not (= ?c_10 ?c_15)) (not (= ?c_14 ?c_15)) (not (= ?c_12 ?c_13)) (not (= ?c_10 ?c_14)) (not (= ?c_11 ?c_14)) (not (= ?c_10 ?c_13)) (not (= ?c_11 ?c_15)) (aromaticbond ?c_10 ?c_11) (aromaticbond ?c_11 ?c_12) (aromaticbond ?c_12 ?c_13) (aromaticbond ?c_13 ?c_14) (aromaticbond ?c_14 ?c_15) (aromaticbond ?c_10 ?c_15) (bond ?h_9 ?c_10))
    :effect (and (not (bond ?c_6 ?cl_8)) (not (bond ?cl_8 ?c_6)) (bond ?c_6 ?c_10) (bond ?c_10 ?c_6) (bond ?h_9 ?cl_8) (bond ?cl_8 ?h_9) (not (bond ?h_9 ?c_10)) (not (bond ?c_10 ?h_9))))

	(:action GabrielSynthesis
    :parameters (?n_7 - nitrogen ?n_8 - nitrogen ?k_1 - potassium ?n_6 - nitrogen ?c_16 - carbon ?c_15 - carbon ?r2_3 - halogen ?r1_2 - chemical_atom ?o_5 - oxygen ?o_4 - oxygen ?c_14 - carbon ?c_11 - carbon ?c_10 - carbon ?c_13 - carbon ?c_12 - carbon ?c_9 - carbon)
    :precondition (and (not (= ?c_15 ?c_16)) (not (= ?n_8 ?n_6)) (not (= ?n_8 ?n_7)) (not (= ?n_6 ?n_7)) (not (= ?o_5 ?o_4)) (not (= ?c_14 ?c_11)) (not (= ?c_16 ?c_11)) (not (= ?c_12 ?c_14)) (not (= ?c_16 ?c_13)) (not (= ?c_12 ?c_9)) (not (= ?c_9 ?c_10)) (not (= ?c_15 ?c_13)) (not (= ?c_14 ?c_10)) (not (= ?c_13 ?c_11)) (not (= ?c_15 ?c_11)) (not (= ?c_14 ?c_9)) (not (= ?c_11 ?c_10)) (not (= ?c_15 ?c_12)) (not (= ?c_13 ?c_9)) (not (= ?c_12 ?c_10)) (not (= ?c_16 ?c_10)) (not (= ?c_15 ?c_14)) (not (= ?c_16 ?c_9)) (not (= ?c_16 ?c_12)) (not (= ?c_12 ?c_11)) (not (= ?c_16 ?c_14)) (not (= ?c_13 ?c_10)) (not (= ?c_9 ?c_11)) (not (= ?c_15 ?c_10)) (not (= ?c_13 ?c_12)) (not (= ?c_15 ?c_9)) (not (= ?c_13 ?c_14)) (bond ?n_8 ?k_1) (doublebond ?c_15 ?o_5) (doublebond ?c_16 ?o_4) (bond ?c_16 ?c_13) (bond ?n_8 ?c_16) (bond ?c_15 ?n_8) (bond ?c_12 ?c_15) (aromaticbond ?c_14 ?c_9) (aromaticbond ?c_13 ?c_14) (aromaticbond ?c_12 ?c_13) (aromaticbond ?c_11 ?c_12) (aromaticbond ?c_10 ?c_11) (aromaticbond ?c_9 ?c_10) (bond ?r1_2 ?r2_3) (bond ?n_6 ?n_7))
    :effect (and (bond ?k_1 ?r2_3) (bond ?r2_3 ?k_1) (not (bond ?n_8 ?k_1)) (not (bond ?k_1 ?n_8)) (not (bond ?r1_2 ?r2_3)) (not (bond ?r2_3 ?r1_2)) (bond ?r1_2 ?n_8) (bond ?n_8 ?r1_2) (bond ?n_6 ?c_15) (bond ?c_15 ?n_6) (bond ?c_16 ?n_7) (bond ?n_7 ?c_16) (not (bond ?c_15 ?n_8)) (not (bond ?n_8 ?c_15)) (not (bond ?n_8 ?c_16)) (not (bond ?c_16 ?n_8))))

	(:action GrignardAdditionToAcidChlorides
    :parameters (?mg_9 - magnesium ?cl_5 - chlorine ?o_12 - oxygen ?o_4 - oxygen ?mg_3 - magnesium ?c_2 - carbon ?c_7 - carbon ?c_8 - carbon ?h_11 - hydrogen ?r1_1 - halogen ?h_13 - hydrogen ?r1_10 - halogen ?c_6 - carbon)
    :precondition (and (not (= ?c_2 ?c_7)) (not (= ?c_2 ?c_8)) (not (= ?c_7 ?c_8)) (not (= ?o_4 ?o_12)) (not (= ?mg_3 ?mg_9)) (bond ?mg_3 ?r1_1) (bond ?c_2 ?mg_3) (not (= ?h_11 ?h_13)) (bond ?h_11 ?o_12) (bond ?o_12 ?h_13) (bond ?c_8 ?mg_9) (bond ?mg_9 ?r1_10) (not (= ?c_7 ?c_6)) (bond ?cl_5 ?c_7) (bond ?c_6 ?c_7) (doublebond ?o_4 ?c_7))
    :effect (and (not (bond ?c_2 ?mg_3)) (not (bond ?mg_3 ?c_2)) (bond ?c_7 ?c_2) (bond ?c_2 ?c_7) (bond ?cl_5 ?mg_3) (bond ?mg_3 ?cl_5) (not (doublebond ?o_4 ?c_7)) (not (doublebond ?c_7 ?o_4)) (bond ?o_4 ?c_7) (bond ?c_7 ?o_4) (bond ?o_4 ?h_11) (bond ?h_11 ?o_4) (not (bond ?cl_5 ?c_7)) (not (bond ?c_7 ?cl_5)) (bond ?c_8 ?c_7) (bond ?c_7 ?c_8) (not (bond ?c_8 ?mg_9)) (not (bond ?mg_9 ?c_8)) (bond ?mg_9 ?o_12) (bond ?o_12 ?mg_9) (not (bond ?h_11 ?o_12)) (not (bond ?o_12 ?h_11))))

	(:action GrignardReaction
    :parameters (?c_6 - carbon ?o_2 - oxygen ?c_5 - carbon ?mg_4 - magnesium ?h_1 - hydrogen ?r1_3 - halogen)
    :precondition (and (not (= ?c_5 ?c_6)) (bond ?c_6 ?mg_4) (bond ?mg_4 ?r1_3) (doublebond ?o_2 ?c_5))
    :effect (and (bond ?h_1 ?o_2) (bond ?o_2 ?h_1) (not (doublebond ?o_2 ?c_5)) (not (doublebond ?c_5 ?o_2)) (bond ?o_2 ?c_5) (bond ?c_5 ?o_2) (not (bond ?c_6 ?mg_4)) (not (bond ?mg_4 ?c_6)) (bond ?c_6 ?c_5) (bond ?c_5 ?c_6)))
	
	(:action GrignardReagentFormation
    :parameters (?mg_3 - magnesium ?c_2 - carbon ?r2_1 - halogen )
    :precondition (bond ?c_2 ?r2_1)
    :effect (and (not (bond ?c_2 ?r2_1)) (not (bond ?r2_1 ?c_2)) (bond ?r2_1 ?mg_3) (bond ?mg_3 ?r2_1) (bond ?c_2 ?mg_3) (bond ?mg_3 ?c_2)))
	
	(:action HydrationOfAldehydesAndKetones
    :parameters (?o_4 - oxygen ?c_5 - carbon ?h_2 - hydrogen ?o_3 - oxygen ?h_1 - hydrogen ?r1_6 - r_group ?r1_7 - r_group)
    :precondition (and (not (= ?o_3 ?o_4)) (not (= ?h_1 ?h_2)) (bond ?h_1 ?o_3) (bond ?h_2 ?o_3) (not (= ?r1_7 ?r1_6)) (doublebond ?o_4 ?c_5) (bond ?c_5 ?r1_7) (bond ?r1_6 ?c_5))
    :effect (and (not (bond ?h_2 ?o_3)) (not (bond ?o_3 ?h_2)) (bond ?h_2 ?o_4) (bond ?o_4 ?h_2) (bond ?c_5 ?o_3) (bond ?o_3 ?c_5) (not (doublebond ?o_4 ?c_5)) (not (doublebond ?c_5 ?o_4)) (bond ?o_4 ?c_5) (bond ?c_5 ?o_4)))

	(:action HydrationOfAlkenes
    :parameters (?h_6 - hydrogen ?o_1 - oxygen ?h_2 - hydrogen ?c_4 - carbon ?c_5 - carbon ?h_3 - hydrogen)
    :precondition (and (not (= ?c_5 ?c_4)) (not (= ?h_2 ?h_6)) (not (= ?h_2 ?h_3)) (bond ?h_2 ?o_1) (bond ?h_3 ?o_1) (doublebond ?c_5 ?c_4))
    :effect (and (not (bond ?h_2 ?o_1)) (not (bond ?o_1 ?h_2)) (bond ?o_1 ?c_5) (bond ?c_5 ?o_1) (not (doublebond ?c_5 ?c_4)) (not (doublebond ?c_4 ?c_5)) (bond ?c_5 ?c_4) (bond ?c_4 ?c_5) (bond ?h_6 ?c_4) (bond ?c_4 ?h_6)))

	(:action HydrolysisOfNitriles
    :parameters (?h_6 - hydrogen ?o_4 - oxygen ?o_7 - oxygen ?h_5 - hydrogen ?n_1 - nitrogen ?h_8 - hydrogen ?c_2 - carbon ?c_3 - carbon ?h_9 - hydrogen ?h_10 - hydrogen)
    :precondition (and (not (= ?h_5 ?h_6)) (not (= ?h_5 ?h_8)) (not (= ?h_6 ?h_8)) (not (= ?o_4 ?o_7)) (not (= ?c_2 ?c_3)) (bond ?c_2 ?c_3) (triplebond ?c_2 ?n_1) (not (= ?h_6 ?h_5)) (bond ?h_6 ?o_4) (bond ?h_5 ?o_4) (not (= ?h_9 ?h_8)) (bond ?h_9 ?o_7) (bond ?h_8 ?o_7))
    :effect (and (not (triplebond ?c_2 ?n_1)) (not (triplebond ?n_1 ?c_2)) (bond ?h_5 ?n_1) (bond ?n_1 ?h_5) (bond ?h_6 ?n_1) (bond ?n_1 ?h_6) (bond ?h_8 ?n_1) (bond ?n_1 ?h_8) (doublebond ?o_4 ?c_2) (doublebond ?c_2 ?o_4) (bond ?o_7 ?c_2) (bond ?c_2 ?o_7) (not (bond ?h_5 ?o_4)) (not (bond ?o_4 ?h_5)) (not (bond ?h_6 ?o_4)) (not (bond ?o_4 ?h_6)) (not (bond ?h_8 ?o_7)) (not (bond ?o_7 ?h_8))))

	(:action HydroxylSubstitutionOfDiazoniumIonSN1
    :parameters (?n_5 - nitrogen ?c_2 - carbon ?o_1 - oxygen ?h_3 - hydrogen ?n_6 - nitrogen ?h_4 - hydrogen)
    :precondition (and (not (= ?n_6 ?n_5)) (triplebond ?n_6 ?n_5) (bond ?c_2 ?n_5) (not (= ?h_4 ?h_3)) (bond ?o_1 ?h_4) (bond ?o_1 ?h_3))
    :effect (and (bond ?o_1 ?c_2) (bond ?c_2 ?o_1) (not (bond ?o_1 ?h_3)) (not (bond ?h_3 ?o_1)) (not (bond ?c_2 ?n_5)) (not (bond ?n_5 ?c_2))))
	
	
	(:action ImineFormation
    :parameters (?c_5 - carbon ?o_8 - oxygen ?h_2 - hydrogen ?n_1 - nitrogen ?h_3 - hydrogen ?c_4 - carbon ?r1_6 - hc ?r1_7 - hc)
    :precondition (and (not (= ?h_2 ?h_3)) (not (= ?h_3 ?h_2)) (bond ?h_3 ?n_1) (bond ?h_2 ?n_1) (bond ?c_4 ?n_1) (not (= ?r1_6 ?r1_7)) (bond ?r1_6 ?c_5) (bond ?r1_7 ?c_5) (doublebond ?o_8 ?c_5))
    :effect (and (not (bond ?h_2 ?n_1)) (not (bond ?n_1 ?h_2)) (not (bond ?h_3 ?n_1)) (not (bond ?n_1 ?h_3)) (doublebond ?n_1 ?c_5) (doublebond ?c_5 ?n_1) (bond ?h_2 ?o_8) (bond ?o_8 ?h_2) (bond ?h_3 ?o_8) (bond ?o_8 ?h_3) (not (doublebond ?o_8 ?c_5)) (not (doublebond ?c_5 ?o_8))))

	(:action ImineReductionToAmine
    :parameters (?al_10 - aluminium ?h_7 - hydrogen ?o_6 - oxygen ?n_1 - nitrogen ?c_2 - carbon ?h_11 - hydrogen ?r1_3 - hc ?r1_4 - hc ?r1_5 - hc ?h_8 - hydrogen ?h_12 - hydrogen ?h_13 - hydrogen ?h_14 - hydrogen ?li_9 - lithium)
    :precondition (and (not (= ?h_7 ?h_11)) (not (= ?r1_4 ?r1_5)) (not (= ?r1_3 ?r1_5)) (not (= ?r1_3 ?r1_4)) (bond ?n_1 ?r1_3) (doublebond ?c_2 ?n_1) (bond ?c_2 ?r1_4) (bond ?c_2 ?r1_5) (not (= ?h_8 ?h_7)) (bond ?h_8 ?o_6) (bond ?h_7 ?o_6) (not (= ?h_11 ?h_12)) (not (= ?h_11 ?h_13)) (not (= ?h_12 ?h_13)) (not (= ?h_13 ?h_14)) (not (= ?h_12 ?h_14)) (not (= ?h_11 ?h_14)) (bond ?h_11 ?al_10) (bond ?h_12 ?al_10) (bond ?h_13 ?al_10) (bond ?h_14 ?al_10))
    :effect (and (not (doublebond ?c_2 ?n_1)) (not (doublebond ?n_1 ?c_2)) (bond ?c_2 ?n_1) (bond ?n_1 ?c_2) (bond ?h_7 ?n_1) (bond ?n_1 ?h_7) (bond ?h_11 ?c_2) (bond ?c_2 ?h_11) (not (bond ?h_7 ?o_6)) (not (bond ?o_6 ?h_7)) (bond ?o_6 ?al_10) (bond ?al_10 ?o_6) (not (bond ?h_11 ?al_10)) (not (bond ?al_10 ?h_11))))
	
	(:action IntramolecularOxymercurationReduction
    :parameters (?o_15 - oxygen ?o_3 - oxygen ?o_2 - oxygen ?c_19 - carbon ?hg_1 - mercury ?c_20 - carbon ?o_21 - oxygen ?h_11 - hydrogen ?b_10 - boron ?o_5 - oxygen ?o_8 - oxygen ?c_4 - carbon ?c_7 - carbon ?c_6 - carbon ?c_9 - carbon ?h_12 - hydrogen ?h_13 - hydrogen ?h_14 - hydrogen ?c_17 - carbon ?c_16 - carbon ?c_18 - carbon)
    :precondition (and (not (= ?c_20 ?c_19)) (not (= ?o_2 ?o_3)) (not (= ?o_2 ?o_15)) (not (= ?o_2 ?o_21)) (not (= ?o_3 ?o_15)) (not (= ?o_3 ?o_21)) (not (= ?o_15 ?o_21)) (not (= ?o_2 ?o_5)) (not (= ?o_2 ?o_8)) (not (= ?o_5 ?o_8)) (not (= ?c_4 ?c_9)) (not (= ?c_6 ?c_7)) (not (= ?o_3 ?o_5)) (not (= ?o_3 ?o_8)) (not (= ?c_6 ?c_9)) (not (= ?c_4 ?c_6)) (not (= ?c_4 ?c_7)) (not (= ?c_7 ?c_9)) (bond ?hg_1 ?o_2) (bond ?hg_1 ?o_3) (bond ?o_2 ?c_4) (doublebond ?c_4 ?o_5) (bond ?c_4 ?c_6) (bond ?o_3 ?c_7) (doublebond ?c_7 ?o_8) (bond ?c_7 ?c_9) (not (= ?h_11 ?h_12)) (not (= ?h_11 ?h_13)) (not (= ?h_12 ?h_13)) (not (= ?h_13 ?h_14)) (not (= ?h_12 ?h_14)) (not (= ?h_11 ?h_14)) (bond ?b_10 ?h_11) (bond ?b_10 ?h_12) (bond ?b_10 ?h_13) (bond ?b_10 ?h_14) (not (= ?c_17 ?c_19)) (not (= ?c_16 ?c_17)) (not (= ?c_16 ?c_19)) (not (= ?c_16 ?c_18)) (not (= ?c_17 ?c_20)) (not (= ?c_19 ?c_20)) (not (= ?c_18 ?c_19)) (not (= ?c_17 ?c_18)) (not (= ?c_18 ?c_20)) (not (= ?c_16 ?c_20)) (bond ?c_16 ?c_17) (bond ?c_17 ?c_18) (bond ?c_18 ?c_19) (doublebond ?c_19 ?c_20) (bond ?c_16 ?o_21))
    :effect (and (not (bond ?hg_1 ?o_2)) (not (bond ?o_2 ?hg_1)) (not (bond ?hg_1 ?o_3)) (not (bond ?o_3 ?hg_1)) (not (bond ?b_10 ?h_11)) (not (bond ?h_11 ?b_10)) (bond ?b_10 ?o_15) (bond ?o_15 ?b_10) (bond ?c_20 ?h_11) (bond ?h_11 ?c_20) (not (doublebond ?c_19 ?c_20)) (not (doublebond ?c_20 ?c_19)) (bond ?c_19 ?c_20) (bond ?c_20 ?c_19) (bond ?c_19 ?o_21) (bond ?o_21 ?c_19)))
	
	
	(:action LAHReductionOfAnhydrides
    :parameters (?h_6 - hydrogen ?o_4 - oxygen ?o_7 - oxygen ?al_1 - aluminium ?o_3 - oxygen ?o_10 - oxygen ?c_13 - carbon ?c_12 - carbon ?li_2 - lithium ?o_11 - oxygen ?h_9 - hydrogen ?h_14 - hydrogen ?h_15 - hydrogen ?h_16 - hydrogen ?h_17 - hydrogen ?h_5 - hydrogen ?h_8 - hydrogen)
    :precondition (and (not (= ?c_12 ?c_13)) (not (= ?h_14 ?h_15)) (not (= ?h_14 ?h_16)) (not (= ?h_14 ?h_17)) (not (= ?h_14 ?h_6)) (not (= ?h_14 ?h_9)) (not (= ?h_15 ?h_16)) (not (= ?h_15 ?h_17)) (not (= ?h_15 ?h_6)) (not (= ?h_15 ?h_9)) (not (= ?h_16 ?h_17)) (not (= ?h_16 ?h_6)) (not (= ?h_16 ?h_9)) (not (= ?h_17 ?h_6)) (not (= ?h_17 ?h_9)) (not (= ?h_6 ?h_9)) (not (= ?o_3 ?o_4)) (not (= ?o_3 ?o_7)) (not (= ?o_3 ?o_11)) (not (= ?o_3 ?o_10)) (not (= ?o_4 ?o_7)) (not (= ?o_4 ?o_11)) (not (= ?o_4 ?o_10)) (not (= ?o_7 ?o_11)) (not (= ?o_7 ?o_10)) (not (= ?o_11 ?o_10)) (not (= ?o_10 ?o_3)) (not (= ?o_11 ?o_3)) (not (= ?o_10 ?o_11)) (doublebond ?o_10 ?c_12) (doublebond ?o_11 ?c_13) (bond ?c_13 ?o_3) (bond ?o_3 ?c_12) (bond ?h_14 ?al_1) (bond ?h_15 ?al_1) (bond ?al_1 ?h_16) (bond ?al_1 ?h_17) (not (= ?h_5 ?h_6)) (bond ?h_5 ?o_4) (bond ?h_6 ?o_4) (not (= ?h_9 ?h_8)) (bond ?o_7 ?h_9) (bond ?o_7 ?h_8))
    :effect (and (bond ?o_3 ?al_1) (bond ?al_1 ?o_3) (bond ?al_1 ?o_4) (bond ?o_4 ?al_1) (bond ?al_1 ?o_7) (bond ?o_7 ?al_1) (not (bond ?h_14 ?al_1)) (not (bond ?al_1 ?h_14)) (not (bond ?h_15 ?al_1)) (not (bond ?al_1 ?h_15)) (not (bond ?al_1 ?h_16)) (not (bond ?h_16 ?al_1)) (not (bond ?al_1 ?h_17)) (not (bond ?h_17 ?al_1)) (bond ?li_2 ?o_3) (bond ?o_3 ?li_2) (not (bond ?o_3 ?c_12)) (not (bond ?c_12 ?o_3)) (not (bond ?c_13 ?o_3)) (not (bond ?o_3 ?c_13)) (not (bond ?h_6 ?o_4)) (not (bond ?o_4 ?h_6)) (bond ?o_11 ?h_6) (bond ?h_6 ?o_11) (not (bond ?o_7 ?h_9)) (not (bond ?h_9 ?o_7)) (bond ?h_9 ?o_10) (bond ?o_10 ?h_9) (not (doublebond ?o_10 ?c_12)) (not (doublebond ?c_12 ?o_10)) (bond ?o_10 ?c_12) (bond ?c_12 ?o_10) (not (doublebond ?o_11 ?c_13)) (not (doublebond ?c_13 ?o_11)) (bond ?o_11 ?c_13) (bond ?c_13 ?o_11) (bond ?c_12 ?h_14) (bond ?h_14 ?c_12) (bond ?c_12 ?h_15) (bond ?h_15 ?c_12) (bond ?c_13 ?h_16) (bond ?h_16 ?c_13) (bond ?c_13 ?h_17) (bond ?h_17 ?c_13)))
	
	(:action LAHReductionOfAldehydesAndKetones
    :parameters (?o_11 - oxygen ?h_6 - hydrogen ?o_7 - oxygen ?al_2 - aluminium ?c_8 - carbon ?h_12 - hydrogen ?li_1 - lithium ?h_13 - hydrogen ?h_4 - hydrogen ?h_5 - hydrogen ?h_3 - hydrogen ?r1_9 - r_group ?c_10 - carbon)
    :precondition (and (not (= ?h_6 ?h_12)) (not (= ?o_11 ?o_7)) (not (= ?h_12 ?h_13)) (bond ?o_11 ?h_12) (bond ?o_11 ?h_13) (not (= ?h_6 ?h_3)) (not (= ?h_6 ?h_5)) (not (= ?h_5 ?h_3)) (not (= ?h_5 ?h_4)) (not (= ?h_6 ?h_4)) (not (= ?h_4 ?h_3)) (bond ?h_6 ?al_2) (bond ?h_5 ?al_2) (bond ?h_4 ?al_2) (bond ?h_3 ?al_2) (not (= ?c_8 ?c_10)) (doublebond ?c_8 ?o_7) (bond ?c_10 ?c_8) (bond ?r1_9 ?c_8))
    :effect (and (bond ?o_11 ?li_1) (bond ?li_1 ?o_11) (not (bond ?h_6 ?al_2)) (not (bond ?al_2 ?h_6)) (bond ?h_6 ?c_8) (bond ?c_8 ?h_6) (not (doublebond ?c_8 ?o_7)) (not (doublebond ?o_7 ?c_8)) (bond ?c_8 ?o_7) (bond ?o_7 ?c_8) (bond ?h_12 ?o_7) (bond ?o_7 ?h_12) (not (bond ?o_11 ?h_12)) (not (bond ?h_12 ?o_11))))

	(:action LAHReductionOfNitriles
    :parameters (?h_6 - hydrogen ?o_11 - oxygen ?al_1 - aluminium ?o_14 - oxygen ?n_7 - nitrogen ?h_5 - hydrogen ?h_10 - hydrogen ?c_8 - carbon ?h_13 - hydrogen ?li_2 - lithium ?h_12 - hydrogen ?h_15 - hydrogen ?h_4 - hydrogen ?h_3 - hydrogen ?c_9 - carbon)
    :precondition (and (not (= ?o_14 ?o_11)) (not (= ?h_5 ?h_6)) (not (= ?h_5 ?h_10)) (not (= ?h_5 ?h_13)) (not (= ?h_6 ?h_10)) (not (= ?h_6 ?h_13)) (not (= ?h_10 ?h_13)) (not (= ?h_10 ?h_12)) (bond ?h_10 ?o_11) (bond ?o_11 ?h_12) (not (= ?h_13 ?h_15)) (bond ?h_13 ?o_14) (bond ?o_14 ?h_15) (not (= ?h_6 ?h_3)) (not (= ?h_6 ?h_5)) (not (= ?h_5 ?h_3)) (not (= ?h_5 ?h_4)) (not (= ?h_6 ?h_4)) (not (= ?h_4 ?h_3)) (bond ?h_6 ?al_1) (bond ?h_5 ?al_1) (bond ?h_4 ?al_1) (bond ?h_3 ?al_1) (not (= ?c_8 ?c_9)) (bond ?c_8 ?c_9) (triplebond ?n_7 ?c_8))
    :effect (and (not (bond ?h_5 ?al_1)) (not (bond ?al_1 ?h_5)) (not (bond ?h_6 ?al_1)) (not (bond ?al_1 ?h_6)) (bond ?al_1 ?o_14) (bond ?o_14 ?al_1) (bond ?li_2 ?o_11) (bond ?o_11 ?li_2) (bond ?h_5 ?c_8) (bond ?c_8 ?h_5) (bond ?h_6 ?c_8) (bond ?c_8 ?h_6) (not (triplebond ?n_7 ?c_8)) (not (triplebond ?c_8 ?n_7)) (bond ?n_7 ?c_8) (bond ?c_8 ?n_7) (bond ?h_10 ?n_7) (bond ?n_7 ?h_10) (bond ?h_13 ?n_7) (bond ?n_7 ?h_13) (not (bond ?h_10 ?o_11)) (not (bond ?o_11 ?h_10)) (not (bond ?h_13 ?o_14)) (not (bond ?o_14 ?h_13))))
		
	(:action MichaelAdditionToUnsaturatedKetones
    :parameters (?c_3 - carbon ?h_5 - hydrogen ?c_7 - carbon ?c_6 - carbon ?c_1 - carbon ?o_4 - oxygen ?c_2 - carbon ?c_8 - carbon ?o_9 - oxygen)
    :precondition (and (not (= ?c_3 ?c_7)) (not (= ?c_3 ?c_6)) (not (= ?c_7 ?c_6)) (not (= ?c_1 ?c_2)) (not (= ?c_2 ?c_3)) (not (= ?c_1 ?c_3)) (doublebond ?o_4 ?c_1) (bond ?c_2 ?c_1) (bond ?c_1 ?c_3) (bond ?h_5 ?c_3) (not (= ?c_7 ?c_8)) (not (= ?c_6 ?c_8)) (doublebond ?c_7 ?c_6) (bond ?c_8 ?c_6) (doublebond ?o_9 ?c_8))
    :effect (and (not (bond ?h_5 ?c_3)) (not (bond ?c_3 ?h_5)) (bond ?c_3 ?c_7) (bond ?c_7 ?c_3) (bond ?h_5 ?c_6) (bond ?c_6 ?h_5) (not (doublebond ?c_7 ?c_6)) (not (doublebond ?c_6 ?c_7)) (bond ?c_7 ?c_6) (bond ?c_6 ?c_7)))	
		
	(:action NitrileSubstitutionOfDiazoniumIonSN1
    :parameters (?r1_6 - chemical_atom ?c_3 - carbon ?c_5 - carbon ?n_1 - nitrogen ?n_2 - nitrogen ?n_4 - nitrogen)
    :precondition (and (not (= ?c_3 ?c_5)) (not (= ?n_1 ?n_2)) (bond ?n_1 ?c_3) (triplebond ?n_2 ?n_1) (bond ?r1_6 ?c_5) (triplebond ?c_5 ?n_4))
    :effect (and (not (bond ?n_1 ?c_3)) (not (bond ?c_3 ?n_1)) (bond ?c_3 ?c_5) (bond ?c_5 ?c_3) (not (bond ?r1_6 ?c_5)) (not (bond ?c_5 ?r1_6))))

	
	(:action OxidationOfAlcoholsWithPCC
    :parameters (?o_5 - oxygen ?o_4 - oxygen ?cl_1 - chlorine ?h_7 - hydrogen ?o_8 - oxygen ?h_9 - hydrogen ?c_3 - carbon ?cr_2 - chromium ?c_15 - carbon ?c_17 - carbon ?c_16 - carbon ?c_13 - carbon ?c_12 - carbon ?h_11 - hydrogen ?n_14 - nitrogen ?o_6 - oxygen)
    :precondition (and (not (= ?h_9 ?h_7)) (not (= ?o_4 ?o_8)) (not (= ?o_4 ?o_5)) (not (= ?o_8 ?o_5)) (bond ?c_3 ?h_9) (bond ?c_3 ?o_8) (bond ?o_8 ?h_7) (not (= ?c_12 ?c_13)) (not (= ?c_12 ?c_15)) (not (= ?c_17 ?c_15)) (not (= ?c_17 ?c_16)) (not (= ?c_13 ?c_15)) (not (= ?c_15 ?c_16)) (not (= ?c_13 ?c_16)) (not (= ?c_13 ?c_17)) (not (= ?c_12 ?c_17)) (not (= ?c_12 ?c_16)) (aromaticbond ?c_12 ?c_13) (aromaticbond ?c_17 ?c_12) (aromaticbond ?c_13 ?n_14) (aromaticbond ?n_14 ?c_15) (bond ?n_14 ?h_11) (aromaticbond ?c_15 ?c_16) (aromaticbond ?c_16 ?c_17) (not (= ?o_5 ?o_4)) (not (= ?o_6 ?o_4)) (not (= ?o_6 ?o_5)) (doublebond ?cr_2 ?o_6) (bond ?cr_2 ?cl_1) (bond ?cr_2 ?o_5) (doublebond ?cr_2 ?o_4))
    :effect (and (not (bond ?cr_2 ?cl_1)) (not (bond ?cl_1 ?cr_2)) (not (doublebond ?cr_2 ?o_4)) (not (doublebond ?o_4 ?cr_2)) (bond ?cr_2 ?o_4) (bond ?o_4 ?cr_2) (not (bond ?c_3 ?o_8)) (not (bond ?o_8 ?c_3)) (doublebond ?c_3 ?o_8) (doublebond ?o_8 ?c_3) (not (bond ?c_3 ?h_9)) (not (bond ?h_9 ?c_3)) (bond ?o_4 ?h_7) (bond ?h_7 ?o_4) (bond ?o_5 ?h_9) (bond ?h_9 ?o_5) (not (bond ?o_8 ?h_7)) (not (bond ?h_7 ?o_8))))

	
	(:action OxidationOfPrimaryAlcoholWithPotassiumPermanganate
    :parameters (?o_5 - oxygen ?o_7 - oxygen ?o_3 - oxygen ?o_2 - oxygen ?h_9 - hydrogen ?c_8 - carbon ?h_10 - hydrogen ?mn_1 - manganese ?o_4 - oxygen ?h_11 - hydrogen)
    :precondition (and (not (= ?h_9 ?h_10)) (not (= ?o_2 ?o_3)) (not (= ?o_2 ?o_5)) (not (= ?o_2 ?o_7)) (not (= ?o_3 ?o_5)) (not (= ?o_3 ?o_7)) (not (= ?o_5 ?o_7)) (not (= ?o_3 ?o_4)) (not (= ?o_2 ?o_4)) (not (= ?o_4 ?o_5)) (doublebond ?o_2 ?mn_1) (doublebond ?o_3 ?mn_1) (doublebond ?o_4 ?mn_1) (bond ?o_5 ?mn_1) (not (= ?h_9 ?h_11)) (not (= ?h_10 ?h_11)) (bond ?h_9 ?o_7) (bond ?c_8 ?o_7) (bond ?h_10 ?c_8) (bond ?h_11 ?c_8))
    :effect (and (not (doublebond ?o_2 ?mn_1)) (not (doublebond ?mn_1 ?o_2)) (not (doublebond ?o_3 ?mn_1)) (not (doublebond ?mn_1 ?o_3)) (not (bond ?o_5 ?mn_1)) (not (bond ?mn_1 ?o_5)) (doublebond ?o_5 ?mn_1) (doublebond ?mn_1 ?o_5) (bond ?o_2 ?c_8) (bond ?c_8 ?o_2) (bond ?h_9 ?o_2) (bond ?o_2 ?h_9) (bond ?o_3 ?h_10) (bond ?h_10 ?o_3) (bond ?o_3 ?h_11) (bond ?h_11 ?o_3) (not (bond ?c_8 ?o_7)) (not (bond ?o_7 ?c_8)) (doublebond ?c_8 ?o_7) (doublebond ?o_7 ?c_8) (not (bond ?h_9 ?o_7)) (not (bond ?o_7 ?h_9)) (not (bond ?h_10 ?c_8)) (not (bond ?c_8 ?h_10)) (not (bond ?h_11 ?c_8)) (not (bond ?c_8 ?h_11))))

	(:action PaalKnorrPyrroleSynthesis
    :parameters (?o_11 - oxygen ?h_4 - hydrogen ?o_12 - oxygen ?h_3 - hydrogen ?n_1 - nitrogen ?c_7 - carbon ?c_6 - carbon ?c_9 - carbon ?c_8 - carbon ?h_13 - hydrogen ?h_14 - hydrogen ?c_2 - carbon ?c_5 - carbon ?c_10 - carbon)
    :precondition (and (not (= ?c_6 ?c_9)) (not (= ?c_6 ?c_7)) (not (= ?c_6 ?c_8)) (not (= ?c_9 ?c_7)) (not (= ?c_9 ?c_8)) (not (= ?c_7 ?c_8)) (not (= ?h_3 ?h_4)) (not (= ?h_3 ?h_14)) (not (= ?h_3 ?h_13)) (not (= ?h_4 ?h_14)) (not (= ?h_4 ?h_13)) (not (= ?h_14 ?h_13)) (not (= ?o_11 ?o_12)) (bond ?h_3 ?n_1) (bond ?h_4 ?n_1) (bond ?c_2 ?n_1) (not (= ?c_9 ?c_10)) (not (= ?c_6 ?c_10)) (not (= ?c_7 ?c_10)) (not (= ?c_5 ?c_10)) (not (= ?c_8 ?c_10)) (not (= ?c_5 ?c_6)) (not (= ?c_8 ?c_9)) (not (= ?c_5 ?c_7)) (not (= ?c_5 ?c_9)) (not (= ?c_5 ?c_8)) (not (= ?c_7 ?c_9)) (bond ?c_5 ?c_6) (bond ?c_6 ?c_7) (doublebond ?o_11 ?c_6) (bond ?c_7 ?c_8) (bond ?h_14 ?c_7) (bond ?c_8 ?c_9) (bond ?h_13 ?c_8) (bond ?c_9 ?c_10) (doublebond ?o_12 ?c_9))
    :effect (and (not (bond ?h_3 ?n_1)) (not (bond ?n_1 ?h_3)) (not (bond ?h_4 ?n_1)) (not (bond ?n_1 ?h_4)) (bond ?c_6 ?n_1) (bond ?n_1 ?c_6) (bond ?c_9 ?n_1) (bond ?n_1 ?c_9) (bond ?h_3 ?o_11) (bond ?o_11 ?h_3) (bond ?h_4 ?o_11) (bond ?o_11 ?h_4) (not (bond ?c_6 ?c_7)) (not (bond ?c_7 ?c_6)) (doublebond ?c_6 ?c_7) (doublebond ?c_7 ?c_6) (not (doublebond ?o_11 ?c_6)) (not (doublebond ?c_6 ?o_11)) (not (bond ?h_14 ?c_7)) (not (bond ?c_7 ?h_14)) (not (bond ?c_8 ?c_9)) (not (bond ?c_9 ?c_8)) (doublebond ?c_8 ?c_9) (doublebond ?c_9 ?c_8) (not (bond ?h_13 ?c_8)) (not (bond ?c_8 ?h_13)) (not (doublebond ?o_12 ?c_9)) (not (doublebond ?c_9 ?o_12)) (bond ?h_13 ?o_12) (bond ?o_12 ?h_13) (bond ?h_14 ?o_12) (bond ?o_12 ?h_14)))
	
	(:action PBr3ConversionOfAlcoholsToAlkylBromides
    :parameters (?o_5 - oxygen ?br_4 - bromine ?c_7 - carbon ?p_1 - phosphorus ?br_3 - bromine ?br_2 - bromine ?h_6 - hydrogen)
    :precondition (and (not (= ?br_2 ?br_3)) (not (= ?br_2 ?br_4)) (not (= ?br_4 ?br_3)) (bond ?br_2 ?p_1) (bond ?p_1 ?br_4) (bond ?p_1 ?br_3) (bond ?h_6 ?o_5) (bond ?o_5 ?c_7))
    :effect (and (not (bond ?p_1 ?br_4)) (not (bond ?br_4 ?p_1)) (bond ?p_1 ?o_5) (bond ?o_5 ?p_1) (bond ?br_4 ?c_7) (bond ?c_7 ?br_4) (not (bond ?o_5 ?c_7)) (not (bond ?c_7 ?o_5))))

	(:action ReductiveOzonolysis
    :parameters (?o_1 - oxygen ?o_3 - oxygen ?s_6 - sulfur ?o_2 - oxygen ?c_5 - carbon ?c_4 - carbon ?h_9 - hydrogen ?c_7 - carbon ?h_11 - hydrogen ?h_10 - hydrogen ?c_8 - carbon ?h_12 - hydrogen ?h_13 - hydrogen ?h_14 - hydrogen)
    :precondition (and (not (= ?c_4 ?c_5)) (not (= ?o_2 ?o_1)) (not (= ?o_2 ?o_3)) (not (= ?o_1 ?o_3)) (not (= ?h_14 ?h_11)) (not (= ?h_12 ?h_11)) (not (= ?h_14 ?h_10)) (not (= ?h_12 ?h_10)) (not (= ?h_9 ?h_11)) (not (= ?h_12 ?h_9)) (not (= ?h_13 ?h_10)) (not (= ?h_13 ?h_9)) (not (= ?h_14 ?h_9)) (not (= ?h_13 ?h_11)) (not (= ?h_13 ?h_12)) (not (= ?h_9 ?h_10)) (not (= ?c_8 ?c_7)) (not (= ?h_10 ?h_11)) (not (= ?h_14 ?h_13)) (not (= ?h_14 ?h_12)) (bond ?s_6 ?c_8) (bond ?s_6 ?c_7) (bond ?h_14 ?c_8) (bond ?h_13 ?c_8) (bond ?h_12 ?c_8) (bond ?c_7 ?h_9) (bond ?c_7 ?h_10) (bond ?c_7 ?h_11) (not (= ?o_3 ?o_1)) (bond ?o_2 ?o_3) (doublebond ?o_2 ?o_1) (not (= ?c_5 ?c_4)) (doublebond ?c_5 ?c_4))
    :effect (and (not (doublebond ?o_2 ?o_1)) (not (doublebond ?o_1 ?o_2)) (doublebond ?c_4 ?o_1) (doublebond ?o_1 ?c_4) (not (bond ?o_2 ?o_3)) (not (bond ?o_3 ?o_2)) (doublebond ?c_5 ?o_2) (doublebond ?o_2 ?c_5) (bond ?o_3 ?s_6) (bond ?s_6 ?o_3) (not (doublebond ?c_5 ?c_4)) (not (doublebond ?c_4 ?c_5))))

	(:action SandmeyerReaction
    :parameters (?cl_6 - chlorine ?n_4 - nitrogen ?r1_1 - halogen ?n_3 - nitrogen ?c_5 - carbon ?cu_2 - copper )
    :precondition (and (not (= ?n_3 ?n_4)) (bond ?r1_1 ?cu_2) (triplebond ?n_3 ?n_4) (bond ?cl_6 ?n_3) (bond ?n_4 ?c_5))
    :effect (and (not (bond ?r1_1 ?cu_2)) (not (bond ?cu_2 ?r1_1)) (bond ?r1_1 ?c_5) (bond ?c_5 ?r1_1) (bond ?cl_6 ?cu_2) (bond ?cu_2 ?cl_6) (not (bond ?cl_6 ?n_3)) (not (bond ?n_3 ?cl_6)) (not (bond ?n_4 ?c_5)) (not (bond ?c_5 ?n_4))))
	
	(:action SodiumDichromateOxidationOfPrimaryAlcohol
    :parameters (?c_25 - carbon ?h_21 - hydrogen ?h_23 - hydrogen ?o_12 - oxygen ?h_27 - hydrogen ?h_29 - hydrogen ?h_28 - hydrogen ?na_10 - sodium ?na_11 - sodium ?o_5 - oxygen ?o_7 - oxygen ?c_19 - carbon ?o_9 - oxygen ?o_8 - oxygen ?c_13 - carbon ?h_22 - hydrogen ?cr_2 - chromium ?cr_1 - chromium ?h_16 - hydrogen ?o_20 - oxygen ?h_14 - hydrogen ?h_15 - hydrogen ?o_26 - oxygen ?o_4 - oxygen ?o_6 - oxygen ?o_3 - oxygen ?r0_17 - carbon ?r0_18 - carbon ?r0_24 - carbon)
    :precondition (and (not (= ?c_13 ?c_19)) (not (= ?c_13 ?c_25)) (not (= ?c_19 ?c_25)) (not (= ?h_15 ?h_14)) (not (= ?h_15 ?h_16)) (not (= ?h_15 ?h_21)) (not (= ?h_15 ?h_27)) (not (= ?h_15 ?h_22)) (not (= ?h_15 ?h_23)) (not (= ?h_15 ?h_28)) (not (= ?h_15 ?h_29)) (not (= ?h_14 ?h_16)) (not (= ?h_14 ?h_21)) (not (= ?h_14 ?h_27)) (not (= ?h_14 ?h_22)) (not (= ?h_14 ?h_23)) (not (= ?h_14 ?h_28)) (not (= ?h_14 ?h_29)) (not (= ?h_16 ?h_21)) (not (= ?h_16 ?h_27)) (not (= ?h_16 ?h_22)) (not (= ?h_16 ?h_23)) (not (= ?h_16 ?h_28)) (not (= ?h_16 ?h_29)) (not (= ?h_21 ?h_27)) (not (= ?h_21 ?h_22)) (not (= ?h_21 ?h_23)) (not (= ?h_21 ?h_28)) (not (= ?h_21 ?h_29)) (not (= ?h_27 ?h_22)) (not (= ?h_27 ?h_23)) (not (= ?h_27 ?h_28)) (not (= ?h_27 ?h_29)) (not (= ?h_22 ?h_23)) (not (= ?h_22 ?h_28)) (not (= ?h_22 ?h_29)) (not (= ?h_23 ?h_28)) (not (= ?h_23 ?h_29)) (not (= ?h_28 ?h_29)) (not (= ?cr_1 ?cr_2)) (not (= ?o_5 ?o_9)) (not (= ?o_5 ?o_7)) (not (= ?o_5 ?o_8)) (not (= ?o_5 ?o_12)) (not (= ?o_5 ?o_20)) (not (= ?o_5 ?o_26)) (not (= ?o_9 ?o_7)) (not (= ?o_9 ?o_8)) (not (= ?o_9 ?o_12)) (not (= ?o_9 ?o_20)) (not (= ?o_9 ?o_26)) (not (= ?o_7 ?o_8)) (not (= ?o_7 ?o_12)) (not (= ?o_7 ?o_20)) (not (= ?o_7 ?o_26)) (not (= ?o_8 ?o_12)) (not (= ?o_8 ?o_20)) (not (= ?o_8 ?o_26)) (not (= ?o_12 ?o_20)) (not (= ?o_12 ?o_26)) (not (= ?o_20 ?o_26)) (not (= ?na_11 ?na_10)) (not (= ?o_5 ?o_6)) (not (= ?o_9 ?o_5)) (not (= ?o_8 ?o_6)) (not (= ?o_4 ?o_8)) (not (= ?o_4 ?o_3)) (not (= ?o_4 ?o_9)) (not (= ?na_10 ?na_11)) (not (= ?o_5 ?o_3)) (not (= ?o_3 ?o_8)) (not (= ?o_4 ?o_5)) (not (= ?o_7 ?o_6)) (not (= ?o_9 ?o_3)) (not (= ?o_3 ?o_7)) (not (= ?o_3 ?o_6)) (not (= ?o_9 ?o_6)) (not (= ?o_4 ?o_6)) (not (= ?o_4 ?o_7)) (doublebond ?cr_1 ?o_4) (bond ?cr_1 ?o_9) (doublebond ?cr_1 ?o_5) (bond ?cr_1 ?o_3) (bond ?cr_2 ?o_3) (bond ?o_9 ?na_10) (doublebond ?cr_2 ?o_7) (bond ?cr_2 ?o_8) (doublebond ?cr_2 ?o_6) (bond ?o_8 ?na_11) (not (= ?h_16 ?h_15)) (not (= ?h_16 ?h_14)) (bond ?c_13 ?r0_17) (bond ?c_13 ?h_16) (bond ?c_13 ?h_15) (bond ?o_12 ?h_14) (bond ?c_13 ?o_12) (not (= ?h_22 ?h_21)) (bond ?c_19 ?r0_18) (bond ?c_19 ?h_22) (bond ?c_19 ?h_21) (bond ?c_19 ?o_20) (bond ?o_20 ?h_23) (bond ?c_25 ?r0_24) (bond ?c_25 ?h_27) (bond ?c_25 ?h_28) (bond ?c_25 ?o_26) (bond ?o_26 ?h_29))
    :effect (and (not (doublebond ?cr_1 ?o_5)) (not (doublebond ?o_5 ?cr_1)) (not (bond ?cr_1 ?o_9)) (not (bond ?o_9 ?cr_1)) (not (doublebond ?cr_2 ?o_7)) (not (doublebond ?o_7 ?cr_2)) (not (bond ?cr_2 ?o_8)) (not (bond ?o_8 ?cr_2)) (bond ?c_13 ?o_5) (bond ?o_5 ?c_13) (bond ?h_15 ?o_5) (bond ?o_5 ?h_15) (bond ?h_14 ?o_7) (bond ?o_7 ?h_14) (bond ?o_7 ?h_16) (bond ?h_16 ?o_7) (not (bond ?o_8 ?na_11)) (not (bond ?na_11 ?o_8)) (bond ?o_8 ?c_19) (bond ?c_19 ?o_8) (bond ?o_8 ?h_21) (bond ?h_21 ?o_8) (not (bond ?o_9 ?na_10)) (not (bond ?na_10 ?o_9)) (bond ?o_9 ?c_25) (bond ?c_25 ?o_9) (bond ?o_9 ?h_27) (bond ?h_27 ?o_9) (not (bond ?c_13 ?o_12)) (not (bond ?o_12 ?c_13)) (doublebond ?c_13 ?o_12) (doublebond ?o_12 ?c_13) (not (bond ?o_12 ?h_14)) (not (bond ?h_14 ?o_12)) (not (bond ?c_13 ?h_15)) (not (bond ?h_15 ?c_13)) (not (bond ?c_13 ?h_16)) (not (bond ?h_16 ?c_13)) (not (bond ?c_19 ?o_20)) (not (bond ?o_20 ?c_19)) (doublebond ?c_19 ?o_20) (doublebond ?o_20 ?c_19) (not (bond ?c_19 ?h_21)) (not (bond ?h_21 ?c_19)) (not (bond ?c_19 ?h_22)) (not (bond ?h_22 ?c_19)) (not (bond ?o_20 ?h_23)) (not (bond ?h_23 ?o_20)) (not (bond ?c_25 ?o_26)) (not (bond ?o_26 ?c_25)) (doublebond ?c_25 ?o_26) (doublebond ?o_26 ?c_25) (not (bond ?c_25 ?h_27)) (not (bond ?h_27 ?c_25)) (not (bond ?c_25 ?h_28)) (not (bond ?h_28 ?c_25)) (not (bond ?o_26 ?h_29)) (not (bond ?h_29 ?o_26))))
	
	(:action SodiumDichromateOxidationOfSecondaryAlcohol
    :parameters (?c_26 - carbon ?c_20 - carbon ?h_21 - hydrogen ?h_23 - hydrogen ?o_12 - oxygen ?h_29 - hydrogen ?h_28 - hydrogen ?na_10 - sodium ?na_11 - sodium ?o_5 - oxygen ?o_7 - oxygen ?o_9 - oxygen ?o_8 - oxygen ?c_13 - carbon ?cr_2 - chromium ?cr_1 - chromium ?h_30 - hydrogen ?h_31 - hydrogen ?o_22 - oxygen ?h_14 - hydrogen ?h_15 - hydrogen ?o_27 - oxygen ?r1_25 - chemical_atom ?r1_24 - chemical_atom ?r1_18 - chemical_atom ?r1_19 - chemical_atom ?r1_16 - chemical_atom ?r1_17 - chemical_atom ?o_4 - oxygen ?o_6 - oxygen ?o_3 - oxygen)
    :precondition (and (not (= ?h_14 ?h_15)) (not (= ?h_14 ?h_21)) (not (= ?h_14 ?h_23)) (not (= ?h_14 ?h_30)) (not (= ?h_14 ?h_31)) (not (= ?h_14 ?h_28)) (not (= ?h_14 ?h_29)) (not (= ?h_15 ?h_21)) (not (= ?h_15 ?h_23)) (not (= ?h_15 ?h_30)) (not (= ?h_15 ?h_31)) (not (= ?h_15 ?h_28)) (not (= ?h_15 ?h_29)) (not (= ?h_21 ?h_23)) (not (= ?h_21 ?h_30)) (not (= ?h_21 ?h_31)) (not (= ?h_21 ?h_28)) (not (= ?h_21 ?h_29)) (not (= ?h_23 ?h_30)) (not (= ?h_23 ?h_31)) (not (= ?h_23 ?h_28)) (not (= ?h_23 ?h_29)) (not (= ?h_30 ?h_31)) (not (= ?h_30 ?h_28)) (not (= ?h_30 ?h_29)) (not (= ?h_31 ?h_28)) (not (= ?h_31 ?h_29)) (not (= ?h_28 ?h_29)) (not (= ?c_13 ?c_20)) (not (= ?c_13 ?c_26)) (not (= ?c_20 ?c_26)) (not (= ?cr_1 ?cr_2)) (not (= ?o_5 ?o_9)) (not (= ?o_5 ?o_7)) (not (= ?o_5 ?o_8)) (not (= ?o_5 ?o_12)) (not (= ?o_5 ?o_22)) (not (= ?o_5 ?o_27)) (not (= ?o_9 ?o_7)) (not (= ?o_9 ?o_8)) (not (= ?o_9 ?o_12)) (not (= ?o_9 ?o_22)) (not (= ?o_9 ?o_27)) (not (= ?o_7 ?o_8)) (not (= ?o_7 ?o_12)) (not (= ?o_7 ?o_22)) (not (= ?o_7 ?o_27)) (not (= ?o_8 ?o_12)) (not (= ?o_8 ?o_22)) (not (= ?o_8 ?o_27)) (not (= ?o_12 ?o_22)) (not (= ?o_12 ?o_27)) (not (= ?o_22 ?o_27)) (not (= ?na_11 ?na_10)) (not (= ?r1_24 ?r1_25)) (bond ?c_26 ?r1_24) (bond ?c_26 ?r1_25) (bond ?c_26 ?h_28) (bond ?c_26 ?o_27) (bond ?o_27 ?h_29) (not (= ?r1_18 ?r1_19)) (bond ?r1_18 ?c_20) (bond ?r1_19 ?c_20) (bond ?c_20 ?h_21) (bond ?c_20 ?o_22) (bond ?o_22 ?h_23) (not (= ?r1_17 ?r1_16)) (bond ?c_13 ?r1_17) (bond ?c_13 ?o_12) (bond ?c_13 ?h_14) (bond ?c_13 ?r1_16) (bond ?o_12 ?h_15) (not (= ?o_5 ?o_6)) (not (= ?o_9 ?o_5)) (not (= ?o_8 ?o_6)) (not (= ?o_4 ?o_8)) (not (= ?o_4 ?o_3)) (not (= ?o_4 ?o_9)) (not (= ?na_10 ?na_11)) (not (= ?o_5 ?o_3)) (not (= ?o_3 ?o_8)) (not (= ?o_4 ?o_5)) (not (= ?o_7 ?o_6)) (not (= ?o_9 ?o_3)) (not (= ?o_3 ?o_7)) (not (= ?o_3 ?o_6)) (not (= ?o_9 ?o_6)) (not (= ?o_4 ?o_6)) (not (= ?o_4 ?o_7)) (doublebond ?cr_1 ?o_4) (bond ?cr_1 ?o_9) (doublebond ?cr_1 ?o_5) (bond ?cr_1 ?o_3) (bond ?cr_2 ?o_3) (bond ?o_9 ?na_10) (doublebond ?cr_2 ?o_7) (bond ?cr_2 ?o_8) (doublebond ?cr_2 ?o_6) (bond ?o_8 ?na_11))
    :effect (and (not (doublebond ?cr_1 ?o_5)) (not (doublebond ?o_5 ?cr_1)) (not (bond ?cr_1 ?o_9)) (not (bond ?o_9 ?cr_1)) (not (doublebond ?cr_2 ?o_7)) (not (doublebond ?o_7 ?cr_2)) (not (bond ?cr_2 ?o_8)) (not (bond ?o_8 ?cr_2)) (bond ?o_5 ?h_14) (bond ?h_14 ?o_5) (bond ?o_5 ?h_15) (bond ?h_15 ?o_5) (bond ?o_7 ?h_21) (bond ?h_21 ?o_7) (bond ?o_7 ?h_23) (bond ?h_23 ?o_7) (not (bond ?o_8 ?na_11)) (not (bond ?na_11 ?o_8)) (bond ?h_30 ?o_8) (bond ?o_8 ?h_30) (bond ?o_8 ?h_31) (bond ?h_31 ?o_8) (not (bond ?o_9 ?na_10)) (not (bond ?na_10 ?o_9)) (bond ?o_9 ?h_28) (bond ?h_28 ?o_9) (bond ?o_9 ?h_29) (bond ?h_29 ?o_9) (not (bond ?c_13 ?o_12)) (not (bond ?o_12 ?c_13)) (doublebond ?c_13 ?o_12) (doublebond ?o_12 ?c_13) (not (bond ?o_12 ?h_15)) (not (bond ?h_15 ?o_12)) (not (bond ?c_13 ?h_14)) (not (bond ?h_14 ?c_13)) (not (bond ?c_20 ?h_21)) (not (bond ?h_21 ?c_20)) (not (bond ?c_20 ?o_22)) (not (bond ?o_22 ?c_20)) (doublebond ?c_20 ?o_22) (doublebond ?o_22 ?c_20) (not (bond ?o_22 ?h_23)) (not (bond ?h_23 ?o_22)) (not (bond ?c_26 ?o_27)) (not (bond ?o_27 ?c_26)) (doublebond ?c_26 ?o_27) (doublebond ?o_27 ?c_26) (not (bond ?c_26 ?h_28)) (not (bond ?h_28 ?c_26)) (not (bond ?o_27 ?h_29)) (not (bond ?h_29 ?o_27))))

	(:action StetterReaction
    :parameters (?c_1 - carbon ?c_8 - carbon ?c_3 - carbon ?h_10 - hydrogen ?r1_2 - carbon ?o_6 - oxygen ?c_5 - carbon ?c_4 - carbon ?c_9 - carbon ?o_7 - oxygen)
    :precondition (and (not (= ?c_1 ?c_3)) (not (= ?c_1 ?c_8)) (not (= ?c_3 ?c_8)) (not (= ?c_5 ?c_3)) (not (= ?c_4 ?r1_2)) (not (= ?c_5 ?c_1)) (not (= ?c_4 ?c_1)) (not (= ?c_1 ?r1_2)) (not (= ?c_4 ?c_3)) (not (= ?c_3 ?c_1)) (not (= ?c_4 ?c_5)) (not (= ?c_3 ?r1_2)) (not (= ?c_5 ?r1_2)) (doublebond ?o_6 ?c_4) (bond ?c_4 ?c_5) (bond ?c_3 ?c_4) (doublebond ?c_1 ?c_3) (bond ?r1_2 ?c_1) (not (= ?c_8 ?c_9)) (bond ?h_10 ?c_8) (bond ?c_8 ?c_9) (doublebond ?o_7 ?c_8))
    :effect (and (not (doublebond ?c_1 ?c_3)) (not (doublebond ?c_3 ?c_1)) (bond ?c_1 ?c_3) (bond ?c_3 ?c_1) (bond ?c_8 ?c_1) (bond ?c_1 ?c_8) (bond ?h_10 ?c_3) (bond ?c_3 ?h_10) (not (bond ?h_10 ?c_8)) (not (bond ?c_8 ?h_10))))
	
	(:action ThionylChlorideConversionOfCarboxylicAcidsToAcidChlorides
    :parameters (?o_5 - oxygen ?s_4 - sulfur ?cl_2 - chlorine ?h_9 - hydrogen ?c_7 - carbon ?cl_1 - chlorine ?o_3 - oxygen ?c_8 - carbon ?o_6 - oxygen)
    :precondition (and (not (= ?cl_1 ?cl_2)) (bond ?s_4 ?cl_1) (bond ?s_4 ?cl_2) (doublebond ?s_4 ?o_3) (not (= ?c_7 ?c_8)) (not (= ?o_5 ?o_6)) (bond ?c_7 ?o_5) (bond ?h_9 ?o_5) (doublebond ?c_7 ?o_6) (bond ?c_8 ?c_7))
    :effect (and (not (bond ?s_4 ?cl_1)) (not (bond ?cl_1 ?s_4)) (bond ?c_7 ?cl_1) (bond ?cl_1 ?c_7) (not (bond ?s_4 ?cl_2)) (not (bond ?cl_2 ?s_4)) (bond ?h_9 ?cl_2) (bond ?cl_2 ?h_9) (doublebond ?o_5 ?s_4) (doublebond ?s_4 ?o_5) (not (bond ?c_7 ?o_5)) (not (bond ?o_5 ?c_7)) (not (bond ?h_9 ?o_5)) (not (bond ?o_5 ?h_9))))
	
	(:action TosylationOfAlcohols
    :parameters (?s_1 - sulfur ?r1_2 - halogen ?o_6 - oxygen ?h_8 - hydrogen ?o_5 - oxygen ?o_4 - oxygen ?c_3 - carbon ?c_7 - carbon)
    :precondition (and (not (= ?o_5 ?o_4)) (bond ?s_1 ?c_3) (bond ?s_1 ?r1_2) (doublebond ?s_1 ?o_5) (doublebond ?s_1 ?o_4) (bond ?h_8 ?o_6) (bond ?c_7 ?o_6))
    :effect (and (not (bond ?s_1 ?r1_2)) (not (bond ?r1_2 ?s_1)) (bond ?o_6 ?s_1) (bond ?s_1 ?o_6) (bond ?h_8 ?r1_2) (bond ?r1_2 ?h_8) (not (bond ?h_8 ?o_6)) (not (bond ?o_6 ?h_8))))
	
	(:action WilliamsonEtherSynthesis 
    :parameters (?c_1 - carbon ?r1_2 - halogen ?h_5 - hydrogen ?o_4 - oxygen ?c_3 - carbon)
    :precondition (and (bond ?c_1 ?r1_2) (bond ?c_3 ?o_4) (bond ?h_5 ?o_4))
    :effect (and (not (bond ?c_1 ?r1_2)) (not (bond ?r1_2 ?c_1)) (bond ?o_4 ?c_1) (bond ?c_1 ?o_4) (bond ?h_5 ?r1_2) (bond ?r1_2 ?h_5) (not (bond ?h_5 ?o_4)) (not (bond ?o_4 ?h_5))))

)