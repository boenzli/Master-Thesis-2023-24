#load Model 
source C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/inputFiles/Parish_house_3_model.tcl;

#execute analysis: SelfWeight 
source C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/inputFiles/Parish_house_3_1_SelfWeight.tcl;

#execute analysis: Modal 
source C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/inputFiles/Parish_house_3_2_Modal.tcl;

#execute analysis: Dynamic 
source C:/Users/aline/OneDrive/Dokumente/EPFL/12_Master_Thesis/08_OpenSees_Model/inputFiles/Parish_house_3_3_Dynamic.tcl;

puts "---------------------------------------------------------------" 
puts "All analyses completed-----------------------------------------" 
puts "---------------------------------------------------------------" 
wipe 
exit 
