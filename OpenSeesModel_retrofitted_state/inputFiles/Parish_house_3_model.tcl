wipe 
 
setMaxOpenFiles 2048;	        		# Max number of recorders 
set Ubig 1.e10; 			   	 		# a really large number 
set Usmall [expr 1.0/$Ubig]; 			# a really small number 
set g         9.81;  
set pi   3.1415927;  
 
# Create ModelBuilder (with three-dimensions (-ndm) and 6 DOF/node (-ndf)) 
model basic -ndm 3 -ndf 6 
 
#NODES ------------------------------------------------------------  
#node	tag	$X	$Y	$Z 
node	1	0.000	0.000	6.100 
node	2	5.180	0.000	6.100 
node	3	8.580	0.000	6.100 
node	5	11.980	0.000	6.100 
node	6	17.150	0.000	6.100 
node	7	0.000	0.000	2.700 
node	8	5.180	0.000	2.700 
node	9	8.580	0.000	2.700 
node	11	11.980	0.000	2.700 
node	12	17.150	0.000	2.700 
node	13	0.000	0.000	0.000 
node	14	5.180	0.000	0.000 
node	15	7.310	0.000	0.000 
node	16	9.490	0.000	0.000 
node	17	11.980	0.000	0.000 
node	18	17.150	0.000	0.000 
node	19	17.150	1.530	6.100 
node	20	17.150	5.730	6.100 
node	21	17.150	11.350	6.100 
node	22	17.150	1.530	2.700 
node	23	17.150	5.730	2.700 
node	24	17.150	11.350	2.700 
node	25	17.150	1.530	0.000 
node	26	17.150	5.730	0.000 
node	27	17.150	11.350	0.000 
node	28	11.980	11.350	6.100 
node	29	9.480	11.350	6.100 
node	30	5.180	11.350	6.100 
node	31	0.000	11.350	6.100 
node	32	11.980	11.350	2.700 
node	33	9.480	11.350	2.700 
node	34	5.180	11.350	2.700 
node	35	0.000	11.350	2.700 
node	36	11.980	11.350	0.000 
node	37	9.480	11.350	0.000 
node	38	5.180	11.350	0.000 
node	39	0.000	11.350	0.000 
node	40	0.000	5.730	6.100 
node	41	0.000	5.730	2.700 
node	42	0.000	5.730	0.000 
node	43	5.180	5.730	6.100 
node	44	9.480	5.730	6.100 
node	45	11.980	5.730	6.100 
node	46	5.180	5.730	2.700 
node	47	9.480	5.730	2.700 
node	48	11.980	5.730	2.700 
node	49	5.180	5.730	0.000 
node	50	9.480	5.730	0.000 
node	51	11.980	5.730	0.000 
node	52	11.980	1.530	6.100 
node	53	11.980	1.530	2.700 
node	54	11.980	1.530	0.000 
node	55	7.310	3.980	6.100 
node	56	7.310	3.980	2.700 
node	57	7.310	3.980	0.000 
node	58	0.000	0.000	6.100 
node	59	5.180	0.000	6.100 
node	60	11.980	0.000	6.100 
node	61	17.150	0.000	6.100 
node	62	0.000	0.000	2.700 
node	63	5.180	0.000	2.700 
node	64	11.980	0.000	2.700 
node	65	17.150	0.000	2.700 
node	66	0.000	0.000	0.000 
node	67	5.180	0.000	0.000 
node	68	11.980	0.000	0.000 
node	69	17.150	0.000	0.000 
node	70	17.150	1.530	6.100 
node	71	17.150	5.730	6.100 
node	72	17.150	11.350	6.100 
node	73	17.150	1.530	2.700 
node	74	17.150	5.730	2.700 
node	75	17.150	11.350	2.700 
node	76	17.150	1.530	0.000 
node	77	17.150	5.730	0.000 
node	78	17.150	11.350	0.000 
node	79	11.980	11.350	6.100 
node	80	5.180	11.350	6.100 
node	81	0.000	11.350	6.100 
node	82	11.980	11.350	2.700 
node	83	5.180	11.350	2.700 
node	84	0.000	11.350	2.700 
node	85	11.980	11.350	0.000 
node	86	5.180	11.350	0.000 
node	87	0.000	11.350	0.000 
node	88	0.000	5.730	6.100 
node	89	0.000	5.730	2.700 
node	90	0.000	5.730	0.000 
node	91	5.180	5.730	6.100 
node	92	9.480	5.730	6.100 
node	93	11.980	5.730	6.100 
node	94	5.180	5.730	2.700 
node	95	9.480	5.730	2.700 
node	96	11.980	5.730	2.700 
node	97	5.180	5.730	0.000 
node	98	9.480	5.730	0.000 
node	99	11.980	5.730	0.000 
node	100	11.980	1.530	6.100 
node	101	11.980	1.530	2.700 
node	102	11.980	1.530	0.000 
node	103	2.680	0.000	5.775 
node	104	6.380	0.000	5.775 
node	105	10.790	0.000	5.775 
node	106	14.490	0.000	5.775 
node	107	1.040	0.000	4.600 
node	108	4.530	0.000	4.600 
node	109	8.580	0.000	4.600 
node	110	12.680	0.000	4.600 
node	111	16.120	0.000	4.600 
node	112	2.680	0.000	2.975 
node	113	6.380	0.000	2.975 
node	114	10.790	0.000	2.975 
node	115	14.490	0.000	2.975 
node	116	1.040	0.000	1.500 
node	117	4.530	0.000	1.500 
node	118	7.410	0.000	1.100 
node	119	9.760	0.000	1.100 
node	120	12.630	0.000	1.500 
node	121	16.120	0.000	1.500 
node	122	2.680	0.000	0.400 
node	123	6.380	0.000	0.400 
node	124	10.790	0.000	0.400 
node	125	14.490	0.000	0.400 
node	126	17.150	2.880	5.775 
node	127	17.150	8.480	5.775 
node	128	17.150	1.140	4.600 
node	129	17.150	5.680	4.600 
node	130	17.150	10.220	4.600 
node	131	17.150	2.880	2.975 
node	132	17.150	8.480	2.975 
node	133	17.150	1.140	1.100 
node	134	17.150	5.680	1.100 
node    135 17.150  10.220	1.500  
node	136	17.150	8.480	0.400 
node	137	14.470	11.350	5.775 
node	138	10.570	11.350	5.775 
node	139	6.570	11.350	5.775 
node	140	2.670	11.350	5.775 
node	141	16.110	11.350	4.600 
node	142	12.520	11.350	4.600 
node	143	8.570	11.350	4.600 
node	144	4.620	11.350	4.600 
node	145	1.030	11.350	4.600 
node	146	14.470	11.350	2.975 
node	147	10.570	11.350	2.975 
node	148	6.570	11.350	2.975 
node	149	2.670	11.350	2.975 
node	150	16.110	11.350	1.500 
node	151	12.520	11.350	1.500 
node	152	8.570	11.350	1.500 
node	153	4.620	11.350	1.500 
node	154	1.030	11.350	1.500 
node	155	14.470	11.350	0.400 
node	156	10.570	11.350	0.400 
node	157	6.570	11.350	0.400 
node	158	2.670	11.350	0.400 
node	159	0.000	8.470	5.775 
node	160	0.000	2.870	5.775 
node	161	0.000	10.210	4.600 
node	162	0.000	5.670	4.600 
node	163	0.000	1.130	4.600 
node	164	0.000	8.470	2.975 
node	165	0.000	2.870	2.975 
node	166	0.000	10.210	1.500 
node	167	0.000	5.670	1.500 
node	168	0.000	1.130	1.500 
node	169	0.000	8.470	0.400 
node	170	0.000	2.870	0.400 
node	171	3.325	5.730	5.530 
node	172	10.830	5.730	5.530 
node	173	13.840	5.730	5.530 
node	174	1.400	5.730	3.950 
node	175	5.590	5.730	3.950 
node	176	8.660	5.730	3.950 
node	177	12.440	5.730	3.950 
node	178	15.810	5.730	3.950 
node	179	3.325	5.730	2.480 
node	180	10.830	5.730	2.480 
node	181	13.840	5.730	2.480 
node	182	1.400	5.730	1.000 
node	183	5.590	5.730	1.000 
node	184	8.660	5.730	1.000 
node	185	12.440	5.730	1.000 
node	186	15.810	5.730	1.000 
node	187	5.180	1.240	5.530 
node	188	5.180	8.430	5.530 
node	189	5.180	0.310	3.950 
node	190	5.180	4.800	3.950 
node	191	5.180	10.250	3.950 
node	192	5.180	1.240	2.480 
node	193	5.180	8.430	2.480 
node	194	5.180	0.310	1.000 
node	195	5.180	4.800	1.000 
node	196	5.180	10.250	1.000 
node	197	11.980	0.880	5.530 
node	198	11.980	3.160	5.530 
node	199	11.980	8.430	5.530 
node	200	11.980	0.220	3.950 
node	201	11.980	1.910	3.950 
node	202	11.980	5.780	3.950 
node	203	11.980	10.250	3.950 
node	204	11.980	0.880	2.480 
node	205	11.980	3.160	2.480 
node	206	11.980	8.430	2.480 
node	207	11.980	0.220	1.000 
node	208	11.980	1.910	1.000 
node	209	11.980	5.780	1.000 
node	210	11.980	10.250	1.000 
node	211	13.180	1.530	5.530 
node	212	12.330	1.530	3.950 
node	213	15.420	1.530	3.950 
node	214	13.180	1.530	2.480 
node	215	12.330	1.530	1.000 
node	216	15.420	1.530	1.000 
node	217	7.310	2.930	4.400 
node	218	7.310	2.930	1.350 
node	219	9.480	3.805	4.400 
node	220	9.480	3.805	1.350 
 
#Fictitious nodes floor 1 
node	301	7.310	5.730	2.700 
node	302	5.180	3.980	2.700 
node	303	9.480	3.980	2.700 
node	304	11.980	3.980	2.700 
node	305	5.180	1.880	2.700 
node	306	7.310	1.880	2.700 
node	307	9.480	1.880	2.700 
node	308	7.310	0.000	2.700 
node	309	9.480	0.000	2.700 
 
# Fictitious nodes floor 2 
node	310	7.310	5.730	6.100 
node	311	9.480	3.980	6.100 
node	312	5.180	1.880	6.100 
node	313	7.310	1.880	6.100 
node	314	9.480	1.880	6.100 
node	315	9.480	0.000	6.100 
 
 
#END NODES ------------------------------------------------------------  
puts "Nodes defined."    
 
 
geomTransf PDelta      1  0.000 -1.000  0.000 
geomTransf PDelta      2  1.000 -0.000  0.000 
geomTransf PDelta      3  0.000  1.000 -0.000 
geomTransf PDelta      4 -1.000  0.000  0.000 
geomTransf PDelta      5  0.000 -1.000  0.000 
geomTransf PDelta      6  1.000 -0.000  0.000 
geomTransf PDelta      7  1.000 -0.000  0.000 
geomTransf PDelta      8  0.000 -1.000  0.000 
geomTransf PDelta      9  1.000 -0.000  0.000 
geomTransf PDelta     10  1.000 -0.000  0.000 
 
#Geometric transformation for ring beam 
geomTransf Linear	100		0	0	1 
 
 
#MACROELEMENTS ---------------------------------------------------------  
#Set material parameters for macroelements 
set Eelement 1500000000 
set Gs  500000000 
set fc  3200000 
set mus  0.65 
set coh  180000 
set Gc  3 
set dropDrift  0.0065 
set muR  0.65 
set rho  1800 
set driftF  0.00989 
set driftS  0.00667 
set betaTremuri  0.8 
 
#element	element Macroelement3d	$eTag	$nI	$nJ	$nE	$aX	$aY	$aZ	$oopX	$oopY	$oopZ	$element	$h	$L	$t	$Eelement	$G	$fc	$mu	$c	$Gc	$dropDrift	$muR	-density	density	-pDelta	-secantDamping 
#Wall 1 
element Macroelement3d	1	1	2	103	1	0	0	0	-1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	2	2	3	104	1	0	0	0	-1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	3	3	5	105	1	0	0	0	-1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	4	5	6	106	1	0	0	0	-1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	5	7	1	107	0	0	1	0	-1	0	-pier    	1.700	2.080	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	6	8	2	108	0	0	1	0	-1	0	-pier    	1.700	2.500	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	7	9	3	109	0	0	1	0	-1	0	-pier    	1.700	3.200	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	9	11	5	110	0	0	1	0	-1	0	-pier    	1.700	2.500	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	10	12	6	111	0	0	1	0	-1	0	-pier    	1.700	2.080	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	11	7	8	112	1	0	0	0	-1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	12	8	9	113	1	0	0	0	-1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	13	9	11	114	1	0	0	0	-1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	14	11	12	115	1	0	0	0	-1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	15	13	7	116	0	0	1	0	-1	0	-pier    	1.400	2.080	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	16	14	8	117	0	0	1	0	-1	0	-pier    	1.400	2.500	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	17	15	9	118	0	0	1	0	-1	0	-pier    	2.200	0.850	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	18	16	9	119	0	0	1	0	-1	0	-pier    	2.200	0.850	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	19	17	11	120	0	0	1	0	-1	0	-pier    	1.400	2.500	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	20	18	12	121	0	0	1	0	-1	0	-pier    	1.400	2.080	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	21	13	14	122	1	0	0	0	-1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	22	14	15	123	1	0	0	0	-1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	23	16	17	124	1	0	0	0	-1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	24	17	18	125	1	0	0	0	-1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 2 
element Macroelement3d	25	19	20	126	0	1	0	1	0	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	26	20	21	127	0	1	0	1	0	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	28	22	19	128	0	0	1	1	0	0	-pier    	1.700	2.280	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	29	23	20	129	0	0	1	1	0	0	-pier    	1.700	4.400	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	30	24	21	130	0	0	1	1	0	0	-pier    	1.700	2.280	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	31	22	23	131	0	1	0	1	0	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	32	23	24	132	0	1	0	1	0	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	34	25	22	133	0	0	1	1	0	0	-pier    	2.200	2.280	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	35	26	23	134	0	0	1	1	0	0	-pier    	2.200	4.300	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	36	27	24	135	0	0	1	1	0	0	-pier    	1.400	2.280	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	37	26	27	136	0	1	0	1	0	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 3 
element Macroelement3d	38	72	28	137	-1	0	0	0	1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	39	28	29	138	-1	0	0	0	1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	40	29	30	139	-1	0	0	0	1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	41	30	31	140	-1	0	0	0	1	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	42	75	72	141	0	0	1	0	1	0	-pier    	1.700	2.080	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	43	32	28	142	0	0	1	0	1	0	-pier    	1.700	2.700	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	44	33	29	143	0	0	1	0	1	0	-pier    	1.700	2.800	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	45	34	30	144	0	0	1	0	1	0	-pier    	1.700	2.700	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	46	35	31	145	0	0	1	0	1	0	-pier    	1.700	2.080	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	47	75	32	146	-1	0	0	0	1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	48	32	33	147	-1	0	0	0	1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	49	33	34	148	-1	0	0	0	1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	50	34	35	149	-1	0	0	0	1	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	51	78	75	150	0	0	1	0	1	0	-pier    	1.400	2.080	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	52	36	32	151	0	0	1	0	1	0	-pier    	1.400	2.700	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	53	37	33	152	0	0	1	0	1	0	-pier    	1.400	2.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	54	38	34	153	0	0	1	0	1	0	-pier    	1.400	2.700	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	55	39	35	154	0	0	1	0	1	0	-pier    	1.400	2.080	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	56	78	36	155	-1	0	0	0	1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	57	36	37	156	-1	0	0	0	1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	58	37	38	157	-1	0	0	0	1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	59	38	39	158	-1	0	0	0	1	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 4 
element Macroelement3d	60	81	40	159	0	-1	0	-1	0	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	61	40	58	160	0	-1	0	-1	0	0	-spandrel	1.200	0.650	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	62	84	81	161	0	0	1	-1	0	0	-pier    	1.700	2.280	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	63	41	40	162	0	0	1	-1	0	0	-pier    	1.700	4.400	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	64	62	58	163	0	0	1	-1	0	0	-pier    	1.700	2.280	0.550	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	65	84	41	164	0	-1	0	-1	0	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	66	41	62	165	0	-1	0	-1	0	0	-spandrel	1.200	1.550	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	67	87	84	166	0	0	1	-1	0	0	-pier    	1.700	2.280	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	68	42	41	167	0	0	1	-1	0	0	-pier    	1.700	4.400	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	69	66	62	168	0	0	1	-1	0	0	-pier    	1.700	2.280	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	70	87	42	169	0	-1	0	-1	0	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	71	42	66	170	0	-1	0	-1	0	0	-spandrel	1.200	0.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 5 
element Macroelement3d	72	88	43	171	1	0	0	0	-1	0	-spandrel	1.050	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	73	44	45	172	1	0	0	0	-1	0	-spandrel	1.680	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	74	45	71	173	1	0	0	0	-1	0	-spandrel	1.250	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho			-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	75	89	88	174	0	0	1	0	-1	0	-pier    	2.000	2.800	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	76	46	43	175	0	0	1	0	-1	0	-pier    	2.000	3.480	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	77	47	44	176	0	0	1	0	-1	0	-pier    	2.000	2.660	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	78	48	45	177	0	0	1	0	-1	0	-pier    	2.000	1.540	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	79	74	71	178	0	0	1	0	-1	0	-pier    	2.000	2.700	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	80	89	46	179	1	0	0	0	-1	0	-spandrel	1.050	1.150	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	81	47	48	180	1	0	0	0	-1	0	-spandrel	1.680	1.150	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	82	48	74	181	1	0	0	0	-1	0	-spandrel	1.250	1.150	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	83	90	89	182	0	0	1	0	-1	0	-pier    	2.000	2.800	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	84	49	46	183	0	0	1	0	-1	0	-pier    	2.000	3.480	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	85	50	47	184	0	0	1	0	-1	0	-pier    	2.000	2.660	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	86	51	48	185	0	0	1	0	-1	0	-pier    	2.000	1.540	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	87	77	74	186	0	0	1	0	-1	0	-pier    	2.000	2.700	0.700	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 6 
element Macroelement3d	88	59	91	187	0	1	0	1	0	0	-spandrel	1.260	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	89	91	80	188	0	1	0	1	0	0	-spandrel	1.400	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	90	63	59	189	0	0	1	1	0	0	-pier    	2.000	0.600	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	91	94	91	190	0	0	1	1	0	0	-pier    	2.000	5.860	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	92	83	80	191	0	0	1	1	0	0	-pier    	2.000	2.230	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	93	63	94	192	0	1	0	1	0	0	-spandrel	1.260	0.950	0.450	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	94	94	83	193	0	1	0	1	0	0	-spandrel	1.400	0.950	0.450	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	95	67	63	194	0	0	1	1	0	0	-pier    	2.000	0.600	0.500	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	96	97	94	195	0	0	1	1	0	0	-pier    	2.000	5.860	0.500	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	97	86	83	196	0	0	1	1	0	0	-pier    	2.000	2.230	0.500	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 7 
element Macroelement3d	98	60	52	197	0	1	0	1	0	0	-spandrel	0.900	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	99	52	93	198	0	1	0	1	0	0	-spandrel	1.350	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	100	93	79	199	0	1	0	1	0	0	-spandrel	1.400	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	101	64	60	200	0	0	1	1	0	0	-pier    	2.000	0.430	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	102	53	52	201	0	0	1	1	0	0	-pier    	2.000	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	103	96	93	202	0	0	1	1	0	0	-pier    	2.000	3.900	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	104	82	79	203	0	0	1	1	0	0	-pier    	2.000	2.230	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	105	64	53	204	0	1	0	1	0	0	-spandrel	0.900	0.950	0.450	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	106	53	96	205	0	1	0	1	0	0	-spandrel	1.350	0.950	0.450	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	107	96	82	206	0	1	0	1	0	0	-spandrel	1.400	0.950	0.450	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	108	68	64	207	0	0	1	1	0	0	-pier    	2.000	0.430	0.500	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	109	54	53	208	0	0	1	1	0	0	-pier    	2.000	1.150	0.500	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	110	99	96	209	0	0	1	1	0	0	-pier    	2.000	3.900	0.500	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	111	85	82	210	0	0	1	1	0	0	-pier    	2.000	2.230	0.500	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 8 
element Macroelement3d	112	100	70	211	1	0	0	0	-1	0	-spandrel	1.000	1.150	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	113	101	100	212	0	0	1	0	-1	0	-pier    	2.000	0.700	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	114	73	70	213	0	0	1	0	-1	0	-pier    	2.000	3.480	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	115	101	73	214	1	0	0	0	-1	0	-spandrel	1.000	0.950	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	116	102	101	215	0	0	1	0	-1	0	-pier    	2.000	0.700	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
element Macroelement3d	117	76	73	216	0	0	1	0	-1	0	-pier    	2.000	3.480	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$dropDrift	$muR	-density	$rho	-pDelta	-secantDamping	-driftS	$driftS	0.8	-driftF	$driftF	0.0    -cmass 
 
#Wall 9 
element Macroelement3d	118	56	55	217	0	0	1	1	0	0	-tremuri	3.400	2.100	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$betaTremuri	-density	$rho	-secantDamping 
element Macroelement3d	119	57	56	218	0	0	1	1	0	0	-tremuri	2.700	2.100	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$betaTremuri	-density	$rho	-secantDamping 
 
#Wall 10 
element Macroelement3d	120	95	92	219	0	0	1	1	0	0	-tremuri	3.400	3.850	0.400	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$betaTremuri	-density	$rho	-secantDamping 
element Macroelement3d	121	98	95	220	0	0	1	1	0	0	-tremuri	2.700	3.850	0.600	$Eelement	$Gs	$fc	$mus	$coh	$Gc	$betaTremuri	-density	$rho	-secantDamping 
 
#SECTIONS-------------------------------------------------------------------- 
#sectionOrthotropicMembraneSection	$secTag	$E1		$E2			$ni		$G			$h		$rho	$angle 
section	OrthotropicMembraneSection	1	1754568317	309154		0.20	135768163	0.15	0.00	0 
section	OrthotropicMembraneSection	2	309154		1754568317	0.20	135768163	0.15	0.00	0 
section	OrthotropicMembraneSection	3	309154		1754568317	0.20	135768163	0.15	0.00	0 
section	OrthotropicMembraneSection	4	309154		1754568317	0.20	135768163	0.15	0.00	0 
section	OrthotropicMembraneSection	5	1803534972	456997		0.20	351620872	0.15	0.00	0 
section	OrthotropicMembraneSection	6	975017078	959396996	0.20	409235621	0.15	0.00	0 
section	OrthotropicMembraneSection	7	1500000000	861183695	0.20	336823496	0.15	0.00	0 
section	OrthotropicMembraneSection	8	1804744716	460640		0.20	351229786	0.15	0.00	0 
section	OrthotropicMembraneSection	9	1675884813	2342463		0.20	443483476	0.15	0.00	0 
section	OrthotropicMembraneSection	10	1696460033	861183695	0.20	335391416	0.15	0.00	0 
section	OrthotropicMembraneSection	11	869434314	864123379	0.20	330234631	0.15	0.00	0 
section	OrthotropicMembraneSection	12	869434314	863563119	0.20	330234631	0.15	0.00	0 
section	OrthotropicMembraneSection	13	875537140	861183695	0.20	325375608	0.15	0.00	0 
section	OrthotropicMembraneSection	14	2438581		1563096345	0.20	664824666	0.15	0.00	0 
section	OrthotropicMembraneSection	20	975017078	958326986	0.20	408346783	0.15	0.00	0 
section	OrthotropicMembraneSection	23	960258849	958326986	0.20	408346783	0.15	0.00	0 
section	OrthotropicMembraneSection	30	30000000000	30000000000	0.20	12500000000	0.10	0.00	0 
 
#sectionElastic	$secTag	$E		$A		$Iz			$Iy			$G			$J 
section	Elastic	100	30000000000	0.15	0.001125	0.003125	2500000000	0.004250 
section	Elastic	200	1500000000	0.69	0.076044	0.020700	500000000	0.096744 
section	Elastic	300	1500000000	0.46	0.050696	0.006133	500000000	0.056829 
 
#END SECTIONS---------------------------------------------------------------- 
 
#SHELLS  ---------------------------------------------------------  
#element	ShellMITC4	$eTag	$nI	$nJ	$nK	$nL	$secTag 
element	ShellMITC4	201	89	46	34	35	1 
element	ShellMITC4	202	46	47	33	34	2 
element	ShellMITC4	203	47	48	32	33	3 
element	ShellMITC4	204	48	74	75	32	4 
element	ShellMITC4	205	62	63	94	41	5 
element	ShellMITC4	206	302	56	301	46	6 
element	ShellMITC4	207	303	304	96	95	7 
element	ShellMITC4	208	53	22	23	96	8 
element	ShellMITC4	209	305	306	56	302	9 
element	ShellMITC4	210	307	53	304	303	10 
element	ShellMITC4	211	8	308	306	305	11 
element	ShellMITC4	212	308	309	307	306	12 
element	ShellMITC4	213	309	11	101	307	13 
element	ShellMITC4	214	11	12	73	101	14 
element	ShellMITC4	215	88	43	30	31	30 
element	ShellMITC4	216	43	44	29	30	30 
element	ShellMITC4	217	44	45	28	29	30 
element	ShellMITC4	218	45	71	72	28	30 
element	ShellMITC4	219	1	2	43	88	30 
element	ShellMITC4	220	55	311	44	310	20 
element	ShellMITC4	221	315	5	45	44	30 
element	ShellMITC4	222	100	70	71	45	30 
element	ShellMITC4	223	313	314	311	55	23 
element	ShellMITC4	224	2	315	314	312	30 
element	ShellMITC4	225	5	6	70	100	30 
#END Shells ------------------------------------------------------------  
 
# RING BEAM ELEMENTS-------------------------------------------------------------- 
# Ring beam material parameters 
set Abeam 0.35; 
set Ebeam 3e10; 
set Gbeam 1.25e10; 
set J 0.010417; 
set Iy 0.005208; 
set Iz 0.005208; 
 
#$elasticBeamColumn	$eleTag	$nodeI	$nodeJ	$secTag	$transfTag 
element	elasticBeamColumn	301	1		2	100	100 
element	elasticBeamColumn	302	2		3	100	100 
element	elasticBeamColumn	303	3		315	100	100 
element	elasticBeamColumn	304	315		5	100	100 
element	elasticBeamColumn	305	5		6	100	100 
element	elasticBeamColumn	306	61		19	100	100 
element	elasticBeamColumn	307	19		20	100	100 
element	elasticBeamColumn	308	20		21	100	100 
element	elasticBeamColumn	309	72		28	100	100 
element	elasticBeamColumn	310	28		29	100	100 
element	elasticBeamColumn	311	29		30	100	100 
element	elasticBeamColumn	312	30		31	100	100 
element	elasticBeamColumn	313	81		40	100	100 
element	elasticBeamColumn	314	40		58	100	100 
# END Ring beam elements------------------------------------------------------------------------------- 
 
#Irregularities in walls------------------------------------------------------------------------------- 
element	elasticBeamColumn	315	46	47	200	100 
element	elasticBeamColumn	316	43	44	300	100 
# END Irregularities in walls------------------------------------------------------------------------------- 
 
# Steel tie elements------------------------------------------------------------------------------- 
#uniaxialMaterial	Steel01	$matTag	$Fy		$E0				$b 
uniaxialMaterial	Steel01	1	355000000	210000000000	0 
#$truss	$eleTag	$nodeI	$nodeJ	$A	$matTag	$-cMass	$cFlag 
element	truss	401	35	89	0.000254	1	-cMass	1 
element	truss	402	34	46	0.000509	1	-cMass	1 
element	truss	403	33	47	0.000382	1	-cMass	1 
element	truss	404	32	48	0.000382	1	-cMass	1 
element	truss	405	75	74	0.000254	1	-cMass	1 
element	truss	406	41	94	0.000254	1	-cMass	1 
element	truss	407	62	63	0.000254	1	-cMass	1 
element	truss	408	96	23	0.000254	1	-cMass	1 
element	truss	409	53	22	0.000254	1	-cMass	1 
element	truss	410	101	11	0.000509	1	-cMass	1 
element	truss	411	73	12	0.000509	1	-cMass	1 
# END Steel tie elements------------------------------------------------------------------------------- 
 
#CONSTRAINTS ---------------------------------------------------------  
#fix	$node	X	Y	Z	RX	RY	RZ 
# Ground floor nodes 
fix	13	1	1	1	1	1	1 
fix	14	1	1	1	1	1	1 
fix	15	1	1	1	1	1	1 
fix	16	1	1	1	1	1	1 
fix	17	1	1	1	1	1	1 
fix	18	1	1	1	1	1	1 
fix	69	1	1	1	1	1	1 
fix	25	1	1	1	1	1	1 
fix	26	1	1	1	1	1	1 
fix	27	1	1	1	1	1	1 
fix	78	1	1	1	1	1	1 
fix	36	1	1	1	1	1	1 
fix	37	1	1	1	1	1	1 
fix	38	1	1	1	1	1	1 
fix	39	1	1	1	1	1	1 
fix	87	1	1	1	1	1	1 
fix	42	1	1	1	1	1	1 
fix	66	1	1	1	1	1	1 
fix	90	1	1	1	1	1	1 
fix	49	1	1	1	1	1	1 
fix	50	1	1	1	1	1	1 
fix	51	1	1	1	1	1	1 
fix	77	1	1	1	1	1	1 
fix	67	1	1	1	1	1	1 
fix	97	1	1	1	1	1	1 
fix	86	1	1	1	1	1	1 
fix	68	1	1	1	1	1	1 
fix	54	1	1	1	1	1	1 
fix	99	1	1	1	1	1	1 
fix	85	1	1	1	1	1	1 
fix	102	1	1	1	1	1	1 
fix	76	1	1	1	1	1	1 
fix	57	1	1	1	1	1	1 
fix	98	1	1	1	1	1	1 
 
 
#Fictitious nodes floor 1 
fix	301	0	0	1	1	1	0 
fix	302	0	0	1	1	1	0 
fix	303	0	0	1	1	1	0 
fix	304	0	0	1	1	1	0 
fix	305	0	0	1	1	1	0 
fix	306	0	0	1	1	1	0 
fix	307	0	0	1	1	1	0 
 
# Fictitious nodes floor 2 
fix	310	0	0	1	1	1	0 
fix	311	0	0	1	1	1	0 
#fix	312	0	0	1	1	1	0 
fix	313	0	0	1	1	1	0 
fix	314	0	0	1	1	1	0 
#fix	315	0	0	1	1	1	0 
 
# Staircase NODES 
equalDOF 95 92 1 4 6 
equalDOF 56 55 1 4 6 
equalDOF 98 95 1 6 
equalDOF 57 56 1 6 
#END Constraints------------------------------------------------------------------- 
 
#WALL TO WALL CONNECTIONS --------------------------------------------------------- 
equalDOF	1	58	1 2 3 
equalDOF	2	59	1 2 
equalDOF	5	60	1 2 
equalDOF	6	61	1 2 3 
equalDOF	7	62	1 2 
equalDOF	8	63	1 2 
equalDOF	11	64	1 2 
equalDOF	65	12	1 2 
equalDOF	19	70	1 2 
equalDOF	20	71	1 2 
equalDOF	21	72	1 2 3 
equalDOF	22	73	1 2 
equalDOF	23	74	1 2 
equalDOF	24	75	1 2 
equalDOF	28	79	1 2 
equalDOF	30	80	1 2 
equalDOF	31	81	1 2 3 
equalDOF	32	82	1 2 
equalDOF	34	83	1 2 
equalDOF	35	84	1 2 
equalDOF	40	88	1 2 
equalDOF	41	89	1 2 
equalDOF	43	91	1 2 
equalDOF	92	44	1 2 
equalDOF	45	93	1 2 
equalDOF	46	94	1 2 
equalDOF	47	95	1 2 
equalDOF	48	96	1 2 
equalDOF	52	100	1 2 
equalDOF	53	101	1 2 
 
# Beam corners 
rigidLink	beam	6	61 
rigidLink	beam	21	72 
rigidLink	beam	31	81 
rigidLink	beam	58	1 
 
#Irregularities in walls 
rigidLink	beam	19	61 
rigidLink	beam	22	65 
 
#FLOOR TO WALL CONNECTIONS --------------------------------------------------------- 
 
#Fictitious NODES 
rigidLink	beam		3	315 
rigidLink	beam		9	308 
rigidLink	beam		9	309 
rigidLink	beam		2	312 
#END Connections ------------------------------------------------------  
 
#NODAL MASSES ------------------------------------------------------------  
#mass	Nodes	X	Y	Z	RX	RY	RZ 
mass	1	4483.8	4483.8	4483.8	141.4	1589.1	1447.7 
mass	2	7058.8	7058.8	7058.8	169.9	849.6	679.7 
mass	3	4109.6	4109.6	4109.6	237.3	237.3	0.0 
mass	5	5781.6	5781.6	5781.6	169.9	849.6	679.7 
mass	6	2695.9	2695.9	2695.9	141.4	1589.1	1447.7 
mass	7	3481.9	3481.9	3481.9	263.3	4029.4	3766.0 
mass	8	5119.4	5119.4	5119.4	316.5	2084.7	1768.2 
mass	9	5356.8	5356.8	5356.8	405.1	405.1	0.0 
mass	11	6288.0	6288.0	6288.0	316.5	2084.7	1768.2 
mass	12	4590.3	4590.3	4590.3	263.3	4029.4	3766.0 
mass	13	2096.6	2096.6	2096.6	335.5	2603.2	2267.7 
mass	14	2520.0	2520.0	2520.0	403.2	1467.9	1064.7 
mass	17	2520.0	2520.0	2520.0	403.2	1467.9	1064.7 
mass	18	2096.6	2096.6	2096.6	335.5	2603.2	2267.7 
mass	19	2925.1	2925.1	2925.1	378.1	155.0	223.2 
mass	20	5329.9	5329.9	5329.9	306.1	299.1	7.1 
mass	21	2182.2	2182.2	2182.2	2061.7	155.0	1906.7 
mass	22	8694.1	8694.1	8694.1	869.2	288.6	580.5 
mass	23	12243.0	12243.0	12243.0	575.4	557.0	18.4 
mass	24	3816.7	3816.7	3816.7	5248.8	288.6	4960.2 
mass	27	2298.2	2298.2	2298.2	3354.5	367.7	2986.8 
mass	28	7376.3	7376.3	7376.3	183.5	709.1	525.6 
mass	29	6801.0	6801.0	6801.0	190.3	1649.8	1459.5 
mass	30	8707.0	8707.0	8707.0	183.5	709.1	525.6 
mass	31	4437.0	4437.0	4437.0	141.4	1589.1	1447.7 
mass	32	14202.2	14202.2	14202.2	341.8	1709.0	1367.2 
mass	33	13271.3	13271.3	13271.3	354.5	4151.1	3796.6 
mass	34	16487.0	16487.0	16487.0	341.8	1709.0	1367.2 
mass	35	10021.0	10021.0	10021.0	263.3	4029.4	3766.0 
mass	36	2721.6	2721.6	2721.6	435.5	1258.7	823.3 
mass	37	2822.4	2822.4	2822.4	451.6	2737.7	2286.1 
mass	38	2721.6	2721.6	2721.6	435.5	1258.7	823.3 
mass	39	2096.6	2096.6	2096.6	335.5	2603.2	2267.7 
mass	40	7194.9	7194.9	7194.9	306.1	299.1	7.1 
mass	41	14032.7	14032.7	14032.7	575.4	557.0	18.4 
mass	42	4435.2	4435.2	4435.2	720.7	709.6	11.1 
mass	43	12977.0	12977.0	12977.0	952.7	1437.0	484.4 
mass	44	6868.4	6868.4	6868.4	728.2	2209.1	1480.9 
mass	45	11057.7	11057.7	11057.7	421.6	691.4	269.8 
mass	46	15885.7	15885.7	15885.7	180.8	781.0	600.2 
mass	47	11313.3	11313.3	11313.3	138.2	1973.3	1835.1 
mass	48	11262.4	11262.4	11262.4	80.0	414.3	334.3 
mass	52	952.2	952.2	952.2	448.7	314.8	133.9 
mass	53	6785.7	6785.7	6785.7	188.0	49.8	138.3 
mass	55	779.8	779.8	779.8	0.0	0.0	0.0 
mass	56	1041.9	1041.9	1041.9	0.0	0.0	0.0 
mass	58	2568.7	2568.7	2568.7	2061.7	155.0	1906.7 
mass	59	505.1	505.1	505.1	214.0	167.0	47.0 
mass	60	356.0	356.0	356.0	134.2	117.7	16.5 
mass	61	194.6	194.6	194.6	0.0	0.0	0.0 
mass	62	10483.8	10483.8	10483.8	5248.8	288.6	4960.2 
mass	63	7240.8	7240.8	7240.8	82.4	29.0	53.4 
mass	64	367.6	367.6	367.6	35.6	18.6	17.0 
mass	66	2298.2	2298.2	2298.2	3354.5	367.7	2986.8 
mass	70	5312.3	5312.3	5312.3	952.7	9676.5	8723.8 
mass	71	6401.7	6401.7	6401.7	739.1	4813.5	4074.4 
mass	72	4431.1	4431.1	4431.1	141.4	1589.1	1447.7 
mass	73	3488.7	3488.7	3488.7	120.5	7327.2	7206.7 
mass	74	9065.8	9065.8	9065.8	128.6	4756.5	4628.0 
mass	75	10008.3	10008.3	10008.3	263.3	4029.4	3766.0 
mass	78	2096.6	2096.6	2096.6	335.5	2603.2	2267.7 
mass	79	1846.4	1846.4	1846.4	2906.0	610.5	2295.5 
mass	80	1846.4	1846.4	1846.4	2906.0	610.5	2295.5 
mass	81	2547.5	2547.5	2547.5	2061.7	155.0	1906.7 
mass	82	1906.7	1906.7	1906.7	2466.9	96.5	2370.4 
mass	83	1906.7	1906.7	1906.7	2466.9	96.5	2370.4 
mass	84	3816.7	3816.7	3816.7	5248.8	288.6	4960.2 
mass	87	2298.2	2298.2	2298.2	3354.5	367.7	2986.8 
mass	88	7142.9	7142.9	7142.9	766.5	5310.6	4544.1 
mass	89	9381.7	9381.7	9381.7	150.4	5721.8	5571.4 
mass	91	8140.2	8140.2	8140.2	5800.8	1604.2	4196.6 
mass	93	6517.3	6517.3	6517.3	1075.7	1067.7	8.1 
mass	94	11677.4	11677.4	11677.4	4587.1	253.6	4333.4 
mass	95	408.4	408.4	408.4	0.0	0.0	0.0 
mass	96	8620.3	8620.3	8620.3	177.1	168.8	8.3 
mass	100	3010.5	3010.5	3010.5	191.6	262.6	71.0 
mass	101	2581.8	2581.8	2581.8	24.2	82.9	58.7 
 
#Fictitious nodes floor 1 
mass	301	347.9	347.9	347.9	0.0	0.0	0.0 
mass	302	765.5	765.5	765.5	0.0	0.0	0.0 
mass	303	939.3	939.3	939.3	0.0	0.0	0.0 
mass	304	939.3	939.3	939.3	0.0	0.0	0.0 
mass	305	791.3	791.3	791.3	0.0	0.0	0.0 
mass	306	1172.1	1172.1	1172.1	0.0	0.0	0.0 
mass	307	1309.6	1309.6	1309.6	0.0	0.0	0.0 
mass	308	754.6	754.6	754.6	0.0	0.0	0.0 
mass	309	778.7	778.7	778.7	0.0	0.0	0.0 
 
# Fictitious nodes floor 2 
mass	310	354.5	354.5	354.5	0.0	0.0	0.0 
mass	311	779.8	779.8	779.8	0.0	0.0	0.0 
mass	312	663.4	663.4	663.4	0.0	0.0	0.0 
mass	313	425.4	425.4	425.4	0.0	0.0	0.0 
mass	314	1088.7	1088.7	1088.7	0.0	0.0	0.0 
mass	315	1838.9	1838.9	1838.9	0.0	0.0	0.0 
 
 
#END MASSES ------------------------------------------------------------  
puts "Model defined."    
 
 
