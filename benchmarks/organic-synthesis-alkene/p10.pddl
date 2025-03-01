(define (problem Alkene_P10) (:domain Chemical)
(:objects
c019 - carbon
c020 - carbon
c021 - carbon
c022 - carbon
c023 - carbon
c024 - carbon
c039 - carbon
c040 - carbon
c041 - carbon
c042 - carbon
c043 - carbon
c044 - carbon
c045 - carbon
c046 - carbon
c047 - carbon
c048 - carbon
c049 - carbon
c050 - carbon
cl073 - chlorine
h059 - hydrogen
h060 - hydrogen
h145 - hydrogen
h146 - hydrogen
h147 - hydrogen
h148 - hydrogen
h149 - hydrogen
h150 - hydrogen
h151 - hydrogen
h152 - hydrogen
h153 - hydrogen
h154 - hydrogen
h155 - hydrogen
h156 - hydrogen
h157 - hydrogen
h158 - hydrogen
h159 - hydrogen
h160 - hydrogen
h161 - hydrogen
h162 - hydrogen
h163 - hydrogen
h164 - hydrogen
h165 - hydrogen
h176 - hydrogen
o065 - oxygen
o068 - oxygen
o069 - oxygen
o070 - oxygen
s072 - sulfur
)
(:init
(doublebond c019 c024)
(doublebond c024 c019)

(bond c019 c020)
(bond c020 c019)

(doublebond c020 c021)
(doublebond c021 c020)

(bond c021 s072)
(bond s072 c021)

(bond c021 c022)
(bond c022 c021)

(doublebond c022 c023)
(doublebond c023 c022)

(bond c023 c024)
(bond c024 c023)

(bond c039 h147)
(bond h147 c039)

(bond c039 h146)
(bond h146 c039)

(bond c039 h145)
(bond h145 c039)

(bond c039 c040)
(bond c040 c039)

(bond c040 h060)
(bond h060 c040)

(bond c040 c041)
(bond c041 c040)

(bond c040 c045)
(bond c045 c040)

(bond c041 o065)
(bond o065 c041)

(bond c041 h148)
(bond h148 c041)

(bond c041 c042)
(bond c042 c041)

(bond c042 h150)
(bond h150 c042)

(bond c042 h149)
(bond h149 c042)

(bond c042 c043)
(bond c043 c042)

(bond c043 h152)
(bond h152 c043)

(bond c043 h151)
(bond h151 c043)

(bond c043 c044)
(bond c044 c043)

(bond c044 h154)
(bond h154 c044)

(bond c044 h153)
(bond h153 c044)

(bond c044 c045)
(bond c045 c044)

(bond c045 h156)
(bond h156 c045)

(bond c045 h155)
(bond h155 c045)

(doublebond c046 c047)
(doublebond c047 c046)

(bond c046 h158)
(bond h158 c046)

(bond c046 h157)
(bond h157 c046)

(bond c047 h159)
(bond h159 c047)

(bond c047 c048)
(bond c048 c047)

(bond c048 c049)
(bond c049 c048)

(bond c048 h161)
(bond h161 c048)

(bond c048 h160)
(bond h160 c048)

(bond c049 h163)
(bond h163 c049)

(bond c049 h162)
(bond h162 c049)

(bond c049 c050)
(bond c050 c049)

(bond c050 h165)
(bond h165 c050)

(bond c050 h164)
(bond h164 c050)

(bond c050 o070)
(bond o070 c050)

(bond cl073 s072)
(bond s072 cl073)

(bond h059 o065)
(bond o065 h059)

(bond h176 o070)
(bond o070 h176)

(doublebond o068 s072)
(doublebond s072 o068)

(doublebond o069 s072)
(doublebond s072 o069)
)
(:goal
(and
(bond c039 c040)
(bond c040 c039)

(bond c039 h147)
(bond h147 c039)

(bond c039 h145)
(bond h145 c039)

(bond c039 h146)
(bond h146 c039)

(bond c040 c045)
(bond c045 c040)

(bond c040 c041)
(bond c041 c040)

(bond c040 h060)
(bond h060 c040)

(bond c041 c042)
(bond c042 c041)

(bond c041 o065)
(bond o065 c041)

(bond c041 h148)
(bond h148 c041)

(bond c042 c043)
(bond c043 c042)

(bond c042 h149)
(bond h149 c042)

(bond c042 h150)
(bond h150 c042)

(bond c043 c044)
(bond c044 c043)

(bond c043 h152)
(bond h152 c043)

(bond c043 h151)
(bond h151 c043)

(bond c044 c045)
(bond c045 c044)

(bond c044 h154)
(bond h154 c044)

(bond c044 h153)
(bond h153 c044)

(bond c045 h155)
(bond h155 c045)

(bond c045 h156)
(bond h156 c045)

(doublebond c046 c047)
(doublebond c047 c046)

(bond c046 h157)
(bond h157 c046)

(bond c046 h158)
(bond h158 c046)

(bond c047 c048)
(bond c048 c047)

(bond c047 h159)
(bond h159 c047)

(bond c048 c049)
(bond c049 c048)

(bond c048 h161)
(bond h161 c048)

(bond c048 h160)
(bond h160 c048)

(bond c049 c050)
(bond c050 c049)

(bond c049 h163)
(bond h163 c049)

(bond c049 h162)
(bond h162 c049)

(bond c050 o065)
(bond o065 c050)

(bond c050 h165)
(bond h165 c050)

(bond c050 h164)
(bond h164 c050)
)
)
)