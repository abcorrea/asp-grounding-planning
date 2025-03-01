(define (problem MIT_P02) (:domain Chemical)
(:objects
c1 - carbon
c2 - carbon
c3 - carbon
c4 - carbon
c5 - carbon
c6 - carbon
c7 - carbon
c8 - carbon
cl1 - chlorine
h1 - hydrogen
h10 - hydrogen
h11 - hydrogen
h12 - hydrogen
h13 - hydrogen
h16 - hydrogen
h2 - hydrogen
h3 - hydrogen
h4 - hydrogen
h6 - hydrogen
h7 - hydrogen
h8 - hydrogen
n - nitrogen
n2 - nitrogen
na - sodium
o1 - oxygen
o10 - oxygen
o6 - oxygen
o9 - oxygen
)
(:init
(bond c1 h1)
(bond h1 c1)

(aromaticbond c1 c6)
(aromaticbond c6 c1)

(aromaticbond c1 c2)
(aromaticbond c2 c1)

(bond c2 c7)
(bond c7 c2)

(aromaticbond c2 c3)
(aromaticbond c3 c2)

(bond c3 h2)
(bond h2 c3)

(aromaticbond c3 c4)
(aromaticbond c4 c3)

(bond c4 h3)
(bond h3 c4)

(aromaticbond c4 c5)
(aromaticbond c5 c4)

(bond c5 h4)
(bond h4 c5)

(aromaticbond c5 c6)
(aromaticbond c6 c5)

(bond c6 n)
(bond n c6)

(bond c7 c8)
(bond c8 c7)

(doublebond c7 o1)
(doublebond o1 c7)

(bond c8 h6)
(bond h6 c8)

(bond c8 h7)
(bond h7 c8)

(bond c8 h8)
(bond h8 c8)

(bond cl1 h16)
(bond h16 cl1)

(bond h10 o6)
(bond o6 h10)

(bond h11 o6)
(bond o6 h11)

(bond h12 n)
(bond n h12)

(bond h13 n)
(bond n h13)

(bond n2 o10)
(bond o10 n2)

(doublebond n2 o9)
(doublebond o9 n2)

(bond na o10)
(bond o10 na)
)
(:goal
(and
(aromaticbond c1 c6)
(aromaticbond c6 c1)

(bond c1 h1)
(bond h1 c1)

(aromaticbond c1 c2)
(aromaticbond c2 c1)

(bond c2 c7)
(bond c7 c2)

(aromaticbond c2 c3)
(aromaticbond c3 c2)

(bond c3 h2)
(bond h2 c3)

(aromaticbond c3 c4)
(aromaticbond c4 c3)

(bond c4 h3)
(bond h3 c4)

(aromaticbond c4 c5)
(aromaticbond c5 c4)

(aromaticbond c5 c6)
(aromaticbond c6 c5)

(bond c5 h4)
(bond h4 c5)

(bond c6 o6)
(bond o6 c6)

(bond c7 c8)
(bond c8 c7)

(doublebond c7 o1)
(doublebond o1 c7)

(bond c8 h6)
(bond h6 c8)

(bond c8 h7)
(bond h7 c8)

(bond c8 h8)
(bond h8 c8)

(bond h10 o6)
(bond o6 h10)
)
)
)