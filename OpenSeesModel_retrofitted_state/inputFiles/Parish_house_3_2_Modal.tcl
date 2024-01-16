# -------------------------------------------- 
# Modal Analysis ----------------------------- 
# -------------------------------------------- 

set numModes 10; 

system BandGeneral 
numberer RCM 
constraints Transformation 

# set recorders for modal analysis 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode1.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 1" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode2.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 2" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode3.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 3" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode4.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 4" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode5.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 5" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode6.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 6" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode7.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 7" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode8.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 8" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode9.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 9" 
recorder Node -file "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_mode10.out" -nodeRange 1 220 -dof 1 2 3 4 5 6 "eigen 10" 


# eigenvalues analysis 
set lambda [eigen  $numModes]; 

set omega {} 
set f {} 
set T {} 

foreach lam $lambda { 
  lappend omega [expr sqrt($lam)] 
  lappend f [expr sqrt($lam)/(2.*$pi)] 
  lappend T [expr (2.*$pi)/sqrt($lam)] 
} 
# write output 
set period "C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/13_RetrofittedModel/outputFiles/Modal2/Parish_house_3_periods.out" 
set Periods [open $period "w"] 
set ind 0; 
foreach tt $T {  
   set toPlot    [lindex $f  $ind]		 
   puts $Periods " $tt $toPlot" 
   set ind [expr $ind+1];	 
	 puts [expr $tt]  
}  
close $Periods  

record 

puts "Eigenvalues analysis completed." 
remove recorders; 

