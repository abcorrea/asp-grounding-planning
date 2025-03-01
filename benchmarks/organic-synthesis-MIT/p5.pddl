(define (problem MIT_P05) (:domain Chemical)
(:objects
c1 - carbon
c10 - carbon
c17 - carbon
c18 - carbon
c19 - carbon
c2 - carbon
c20 - carbon
c21 - carbon
c22 - carbon
c23 - carbon
c24 - carbon
c25 - carbon
c26 - carbon
c3 - carbon
c4 - carbon
c5 - carbon
c6 - carbon
c7 - carbon
c8 - carbon
c9 - carbon
cl3 - chlorine
cr2 - chromium
cr3 - chromium
h1 - hydrogen
h10 - hydrogen
h11 - hydrogen
h12 - hydrogen
h13 - hydrogen
h14 - hydrogen
h15 - hydrogen
h16 - hydrogen
h19 - hydrogen
h2 - hydrogen
h25 - hydrogen
h3 - hydrogen
h4 - hydrogen
h5 - hydrogen
h50 - hydrogen
h51 - hydrogen
h52 - hydrogen
h6 - hydrogen
h7 - hydrogen
h8 - hydrogen
h9 - hydrogen
n5 - nitrogen
n6 - nitrogen
na - sodium
o1 - oxygen
o10 - oxygen
o11 - oxygen
o12 - oxygen
o2 - oxygen
o50 - oxygen
o51 - oxygen
o7 - oxygen
o8 - oxygen
o9 - oxygen
)
(:init
(bond c1 h1)
(bond h1 c1)

(bond c1 h2)
(bond h2 c1)

(bond c1 h3)
(bond h3 c1)

(bond c1 c2)
(bond c2 c1)

(bond c10 h16)
(bond h16 c10)

(aromaticbond c10 c5)
(aromaticbond c5 c10)

(aromaticbond c10 c9)
(aromaticbond c9 c10)

(aromaticbond c17 n5)
(aromaticbond n5 c17)

(aromaticbond c17 c18)
(aromaticbond c18 c17)

(aromaticbond c18 c19)
(aromaticbond c19 c18)

(aromaticbond c19 c20)
(aromaticbond c20 c19)

(bond c2 c3)
(bond c3 c2)

(doublebond c2 o1)
(doublebond o1 c2)

(aromaticbond c20 c21)
(aromaticbond c21 c20)

(aromaticbond c21 n5)
(aromaticbond n5 c21)

(aromaticbond c22 n6)
(aromaticbond n6 c22)

(aromaticbond c22 c23)
(aromaticbond c23 c22)

(aromaticbond c23 c24)
(aromaticbond c24 c23)

(aromaticbond c24 c25)
(aromaticbond c25 c24)

(aromaticbond c25 c26)
(aromaticbond c26 c25)

(aromaticbond c26 n6)
(aromaticbond n6 c26)

(bond c3 h5)
(bond h5 c3)

(bond c3 h6)
(bond h6 c3)

(bond c3 h7)
(bond h7 c3)

(bond c4 h10)
(bond h10 c4)

(bond c4 h11)
(bond h11 c4)

(bond c4 o2)
(bond o2 c4)

(bond c4 c5)
(bond c5 c4)

(aromaticbond c5 c6)
(aromaticbond c6 c5)

(bond c6 h12)
(bond h12 c6)

(aromaticbond c6 c7)
(aromaticbond c7 c6)

(bond c7 h13)
(bond h13 c7)

(aromaticbond c7 c8)
(aromaticbond c8 c7)

(bond c8 h14)
(bond h14 c8)

(aromaticbond c8 c9)
(aromaticbond c9 c8)

(bond c9 h15)
(bond h15 c9)

(bond cl3 cr3)
(bond cr3 cl3)

(bond cr2 o7)
(bond o7 cr2)

(bond cr2 o9)
(bond o9 cr2)

(doublebond cr2 o8)
(doublebond o8 cr2)

(bond cr3 o10)
(bond o10 cr3)

(doublebond cr3 o11)
(doublebond o11 cr3)

(doublebond cr3 o12)
(doublebond o12 cr3)

(bond h19 n5)
(bond n5 h19)

(bond h25 n6)
(bond n6 h25)

(bond h4 o7)
(bond o7 h4)

(bond h50 o50)
(bond o50 h50)

(bond h51 o51)
(bond o51 h51)

(bond h52 o51)
(bond o51 h52)

(bond h8 o9)
(bond o9 h8)

(bond h9 o2)
(bond o2 h9)

(bond n5 o7)
(bond o7 n5)

(bond n6 o10)
(bond o10 n6)

(bond na o50)
(bond o50 na)
)
(:goal
(and
(doublebond c1 c4)
(doublebond c4 c1)

(bond c1 c2)
(bond c2 c1)

(bond c1 h3)
(bond h3 c1)

(aromaticbond c10 c9)
(aromaticbond c9 c10)

(aromaticbond c10 c5)
(aromaticbond c5 c10)

(bond c10 h16)
(bond h16 c10)

(doublebond c2 o1)
(doublebond o1 c2)

(bond c2 c3)
(bond c3 c2)

(bond c3 h5)
(bond h5 c3)

(bond c3 h6)
(bond h6 c3)

(bond c3 h7)
(bond h7 c3)

(bond c4 c5)
(bond c5 c4)

(bond c4 h11)
(bond h11 c4)

(aromaticbond c5 c6)
(aromaticbond c6 c5)

(aromaticbond c6 c7)
(aromaticbond c7 c6)

(bond c6 h12)
(bond h12 c6)

(aromaticbond c7 c8)
(aromaticbond c8 c7)

(bond c7 h13)
(bond h13 c7)

(aromaticbond c8 c9)
(aromaticbond c9 c8)

(bond c8 h14)
(bond h14 c8)

(bond c9 h15)
(bond h15 c9)
)
)
)