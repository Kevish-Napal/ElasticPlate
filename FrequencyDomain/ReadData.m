EmitterBegin = 0;
EmitterEnd = 7;
TotalEm = EmitterEnd - EmitterBegin + 1;

ListDossier = [...
    "Data_XDisplacementSource/","Data_YDisplacementSource/"];

d = 0;
SuffixesSave = ["X","Y"];

Sensors = dlmread("Data_XDisplacementSource/Sensors.dat");
Sensors(1,:) = [];
NSensors = length(Sensors)


Sources = dlmread("Data_XDisplacementSource/Sources.dat");
Sources(1,:) = [];
NSources = length(Sources)


for dossier = ListDossier
    d = d+1
    
    UX = zeros(NSensors,NSources);
    UY = zeros(NSensors,NSources);

    for Em = EmitterBegin:EmitterEnd

        StrEm = num2str(Em);
        StrFile0 = [StrEm '-' StrEm '.dat'];
        
        % UX
        StrFileI = strcat(dossier,"UXI_",StrFile0);
        TempI = dlmread(StrFileI);
        StrFileR = strcat(dossier,"UXR_",StrFile0);
        TempR = dlmread(StrFileR);
        TempI(1,:) = []; TempR(1,:) = [];
        TempI(:,2) = []; TempR(:,2) = [];
        
        UX(:,Em+1) = TempR+1i*TempI;

        % UY
        StrFileI = strcat(dossier,"UYI_",StrFile0);
        TempI = dlmread(StrFileI);
        StrFileR = strcat(dossier,"UYR_",StrFile0);
        TempR = dlmread(StrFileR);
        TempI(1,:) = []; TempR(1,:) = [];
        TempI(:,2) = []; TempR(:,2) = [];
        
        UY(:,Em+1) = TempR+1i*TempI;

    end
    
        save(strcat(dossier,'Data_', SuffixesSave(d), '.mat'),'UX','UY','Sensors','Sources');

end


            
            
        
        