# -------------------------------------------------------------------------------------------- 
# Dynamic analysis

# -------------------------------------------------------------------------------------------- 

# set recorders 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/analysis3_Dynamic_allDispl.out"  -time -nodeRange 1 1315 -dof 1 2 3 4 5 6 disp
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/analysis3_Dynamic_allForce.out"  -time -nodeRange 1 1315 -dof 1 2 3 4 5 6 reaction 

recorder Element -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/analysis3_Dynamic_allElementForce.out"  -time -eleRange 1 315 localForce 
recorder Element -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/analysis3_Dynamic_allElementDrift.out"  -time -eleRange 1 315 drift 
recorder Element -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/analysis3_Dynamic_allElementShearDamage.out"  -time -eleRange 1 315 shear state 

# Define dynamic excitation
# ----------------------------------------------
set dt_GM  0.005000;
set currentTime 0.0;
loadConst -time $currentTime

set groundMotionPath1 "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/montenegro_ns.txt";
set groundMotionPath2 "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/montenegro_ew.txt"; 
set direction    
set factor		

timeSeries Path 1  -dt $dt_GM  -filePath $groundMotionPath1  -factor $factor
timeSeries Path 2  -dt $dt_GM  -filePath $groundMotionPath2  -factor $factor
#                           $patternTag $dir -accel $tsTag <-vel0 $vel0> <-fact $cFactor>
pattern UniformExcitation   3    2   -accel 1
pattern UniformExcitation   4    1   -accel 2 

# Define damping model
# ----------------------------------------------
set betaKinitial    1.0;
set betaKcurrent    0.0;
set betaKcommitted  0.0;
set beta_matlab     
set alpha

# User defined. Alpha (mass proportional) 0.922265, beta (initial stiffness proprotional) 0.002315
rayleigh     $alpha      [expr $betaKcurrent* 1.0]     [expr $betaKinitial* $beta_matlab]    [expr $betaKcommitted* 1.0];


# Create the analysis
# ----------------------------------------------
#wipeAnalysis
constraints Transformation
numberer RCM 
system SparseGEN; 
integrator Newmark 0.5 0.25 
analysis Transient

set maxTime   55.3900
set subd 1.000000;
set incr 0.0050000;
set substepIfNotConverged  1.
set counter 0
set counterLimit 30

while {$currentTime<$maxTime} {
    set nSteps [expr int(abs($maxTime-$currentTime)/$incr)]
    if ($nSteps<1) {
       break;
    }
    test NormUnbalance 7.0e+03 1000 2
    algorithm Newton 

    set ok  [analyze $nSteps  $incr]

    if ($ok!=0) {
		if ($counter>$counterLimit) { 
		puts "Building failed."
		throw {ARITH DIVZERO {divide by zero}} {divide by zero}
		} 
		incr counter 1;
        test NormUnbalance 10.5e+03 1000 5
        algorithm Newton -initial
        set ok  [analyze [expr int($substepIfNotConverged)]  [expr $incr/$substepIfNotConverged]]

    }
    set currentTime [getTime]
    puts [format "Continues from time %.3f s" $currentTime]; 

}

after 5000

remove loadPattern 3

puts "Dynamic analysis completed." 

