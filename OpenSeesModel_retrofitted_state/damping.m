
function[alfa,beta]=damping(Ti,Tj,ksi)

fi=1/Ti;
fj=1/Tj;


wi=2*pi*fi;
wj=2*pi*fj;

alfa=ksi*2*wi*wj/(wi+wj);
beta=ksi*2/(wi+wj);

