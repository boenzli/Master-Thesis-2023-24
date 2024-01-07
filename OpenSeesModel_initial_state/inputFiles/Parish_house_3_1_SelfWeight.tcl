# -------------------------------------------- 
# Self Weight analysis------------------------ 
# -------------------------------------------- 

# set recorders 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/outputFiles/analysis1_SelfWeight_allDispl.out"  -time -nodeRange 1 1315 -dof 1 2 3 4 5 6 disp
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/outputFiles/analysis1_SelfWeight_allForce.out"  -time -nodeRange 1 1315 -dof 1 2 3 4 5 6 reaction 

recorder Element -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/outputFiles/analysis1_SelfWeight_allElementForce.out"  -time -eleRange 1 121 localForce 
recorder Element -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/outputFiles/analysis1_SelfWeight_allElementDrift.out"  -time -eleRange 1 121 drift 
recorder Element -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/outputFiles/analysis1_SelfWeight_allElementShearDamage.out"  -time -eleRange 1 121 shear state 

# Define constant axial load
#NODAL LOADS------------------------------------------------------------ 
pattern Plain 1 "Linear" {
	#load	$nodeTag	$FX	$FY	$FZ	$RX	$RY 	$RZ
    load	1	0.0	0.0	-43952.8	0.0			13656.0		0.0
    load	2	0.0	0.0	-62705.6	0.0			-10258.0	0.0
    load	3	0.0	0.0	-59635.6	0.0			0.0			0.0
    load	5	0.0	0.0	-56568.7	0.0			10258.0		0.0
    load	6	0.0	0.0	-26358.2	0.0			-13656.0	0.0
    load	7	0.0	0.0	-34157.4	0.0			35524.0		0.0
    load	8	0.0	0.0	-58779.3	0.0			-26686.0	0.0
    load	9	0.0	0.0	-64381.0	0.0			0.0			0.0
    load	11	0.0	0.0	-60600.1	0.0			26686.0		0.0
    load	12	0.0	0.0	-44929.8	0.0			-35524.0	0.0
    load	13	0.0	0.0	-20567.6	0.0			21391.0		0.0
    load	14	0.0	0.0	-24721.2	0.0			-16069.0	0.0
    load	17	0.0	0.0	-24721.2	0.0			16069.0		0.0
    load	18	0.0	0.0	-20567.6	0.0			-21391.0	0.0
    load	19	0.0	0.0	-28695.3	5613.0		0.0			0.0
    load	20	0.0	0.0	-52286.8	1389.0		0.0			0.0
    load	21	0.0	0.0	-21407.0	16408.0		0.0			0.0
    load	22	0.0	0.0	-85404.6	14602.0		0.0			0.0
    load	23	0.0	0.0	-120219.3	3613.0		0.0			0.0
    load	24	0.0	0.0	-37441.8	42684.0		0.0			0.0
    load	27	0.0	0.0	-22545.3	25702.0		0.0			0.0
    load	28	0.0	0.0	-72373.4	0.0			9374.0		0.0
    load	29	0.0	0.0	-66608.5	0.0			-15908.0	0.0
    load	30	0.0	0.0	-85353.1	0.0			-9374.0		0.0
    load	31	0.0	0.0	-43534.2	0.0			13656.0		0.0
    load	32	0.0	0.0	-139336.6	0.0			24387.0		0.0
    load	33	0.0	0.0	-130066.9	0.0			-41383.0	0.0
    load	34	0.0	0.0	-161666.9	0.0			-24387.0	0.0
    load	35	0.0	0.0	-98313.4	0.0			35524.0		0.0
    load	36	0.0	0.0	-26698.9	0.0			14684.0		0.0
    load	37	0.0	0.0	-27687.7	0.0			-24919.0	0.0
    load	38	0.0	0.0	-26698.9	0.0			-14684.0	0.0
    load	39	0.0	0.0	-20567.6	0.0			21391.0		0.0
    load	40	0.0	0.0	-70582.4	1389.0		0.0			0.0
    load	41	0.0	0.0	-137622.4	3613.0		0.0			0.0
    load	42	0.0	0.0	-43509.3	2175.0		0.0			0.0
    load	43	0.0	0.0	-103348.5	0.0			11589.0		0.0
    load	44	0.0	0.0	-71580.9	0.0			-17717.0	0.0
    load	45	0.0	0.0	-123260.3	0.0			5754.0		0.0
    load	46	0.0	0.0	-157475.9	0.0			14361.0		0.0
    load	47	0.0	0.0	-110858.9	0.0			-21954.0	0.0
    load	48	0.0	0.0	-110497.1	0.0			7130.0		0.0
    load	52	0.0	0.0	-9341.1		-3503.0		0.0			0.0
    load	53	0.0	0.0	-73779.8	-3617.0		0.0			0.0
	load	55	0.0	0.0	-22993.2	0.0			0.0			0.0
	load	56	0.0	0.0	-35259.6	0.0			0.0			0.0
    load	58	0.0	0.0	-25198.5	-16408.0	0.0			0.0
    load	59	0.0	0.0	-8167.0		-1511.0		0.0			0.0
    load	60	0.0	0.0	-3492.4		-751.0		0.0			0.0
	load	61	0.0	0.0	-1909.4		0.0			0.0			0.0
    load	62	0.0	0.0	-102807.7	-42684.0	0.0			0.0
    load	63	0.0	0.0	-80426.7	-1717.0		0.0			0.0
    load	64	0.0	0.0	-5752.3		-775.0		0.0			0.0
    load	66	0.0	0.0	-22545.3	-25702.0	0.0			0.0
    load	70	0.0	0.0	-52126.7	0.0			-49184.0	0.0
    load	71	0.0	0.0	-62954.0	0.0			-29607.0	0.0
    load	72	0.0	0.0	-43520.8	0.0			-13656.0	0.0
    load	73	0.0	0.0	-34123.1	0.0			-40631.0	0.0
    load	74	0.0	0.0	-88995.1	0.0			-33630.0	0.0
    load	75	0.0	0.0	-98241.0	0.0			-35524.0	0.0
    load	78	0.0	0.0	-20567.6	0.0			-21391.0	0.0
    load	79	0.0	0.0	-18113.2	20197.0		0.0			0.0
    load	80	0.0	0.0	-18113.2	20197.0		0.0			0.0
    load	81	0.0	0.0	-24991.1	16408.0		0.0			0.0
    load	82	0.0	0.0	-18704.7	20855.0		0.0			0.0
    load	83	0.0	0.0	-18704.7	20855.0		0.0			0.0
    load	84	0.0	0.0	-37441.8	42684.0		0.0			0.0
    load	87	0.0	0.0	-22545.3	25702.0		0.0			0.0
    load	88	0.0	0.0	-70463.9	0.0			31841.0		0.0
    load	89	0.0	0.0	-92041.8	0.0			39040.0		0.0
    load	91	0.0	0.0	-79855.1	44267.0		0.0			0.0
	load	92	0.0	0.0	-15511.9	0.0			0.0			0.0
    load	93	0.0	0.0	-63934.5	-1584.0		0.0			0.0
    load	94	0.0	0.0	-123949.7	45710.0		0.0			0.0
	load	95	0.0	0.0	-25711.1	0.0			0.0			0.0
    load	96	0.0	0.0	-94156.2	-1636.0		0.0			0.0
    load	100	0.0	0.0	-29546.1	0.0			1990.0		0.0
    load	101	0.0	0.0	-21323.5	0.0			1644.0		0.0

    eleLoad -ele 1 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 2 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 3 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 4 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 5 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 6 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 7 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 9 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 10 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 11 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 12 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 13 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 14 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 15 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 16 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 17 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 18 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 19 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 20 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 21 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 22 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 23 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 24 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 25 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 26 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 28 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 29 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 30 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 31 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 32 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 34 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 35 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 36 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 37 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 38 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 39 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 40 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 41 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 42 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 43 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 44 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 45 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 46 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 47 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 48 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 49 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 50 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 51 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 52 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 53 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 54 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 55 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 56 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 57 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 58 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 59 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 60 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 61 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 62 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 63 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 64 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 65 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 66 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 67 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 68 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 69 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 70 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 71 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 72 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 73 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 74 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 75 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 76 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 77 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 78 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 79 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 80 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 81 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 82 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 83 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 84 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 85 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 86 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 87 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 88 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 89 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 90 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 91 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 92 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 93 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 94 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 95 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 96 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 97 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 98 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 99 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 100 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 101 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 102 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 103 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 104 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 105 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 106 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 107 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 108 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 109 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 110 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 111 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 112 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 113 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 114 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 115 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 116 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 117 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 118 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 119 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 120 -type -selfWeight  0.000  0.000 -9.810 
    eleLoad -ele 121 -type -selfWeight  0.000  0.000 -9.810 
}
#END LOADS ------------------------------------------------------------ 

# Define analysis parameters
wipeAnalysis
system BandGeneral;  
numberer RCM 
constraints Transformation 

integrator LoadControl 1
test NormUnbalance 8.00e-03 300 1

algorithm Newton
analysis Static
analyze 1 

#set self weight as constant load and reset the time to 0
loadConst -time 0.0 

puts "Self Weight analysis completed." 
remove recorders; 

