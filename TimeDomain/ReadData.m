EmitterBegin = 0;
EmitterEnd = 7;
TotalEm = EmitterEnd - EmitterBegin + 1;

TimeList = dlmread("Data_XDisplacementSource/TimeList.dat");
TimeList(1,:) = [];
TimeList = reshape(TimeList',1,[]);
NT = length(TimeList);

Sensors = dlmread("Data_XDisplacementSource/Sensors.dat");
Sensors(1,:) = [];
NSensors = length(Sensors);


Sources = dlmread("Data_XDisplacementSource/Sources.dat");
Sources(1,:) = [];
NSources = length(Sources);


ListDossier = [...
    "Data_XDisplacementSource/","Data_YDisplacementSource/"];

d = 0;
SuffixesSave = ["X","Y"];

for dossier = ListDossier
    d = d+1

    UX = zeros(NT,NSensors,NSources);
    UY = zeros(NT,NSensors,NSources);

    for Em = EmitterBegin:EmitterEnd

        StrEm = num2str(Em);
        StrFile0 = [StrEm '-' StrEm '.dat'];

        % UX
        StrFileI = strcat(dossier,"UXI_",StrFile0);
        TempI = dlmread(StrFileI);
        StrFileR = strcat(dossier,"UXR_",StrFile0);
        TempR = dlmread(StrFileR);
        TempI(1,:) = []; TempR(1,:) = [];
        UX(:,:,Em+1) = TempR'+1i*TempI';

        % UY
        StrFileI = strcat(dossier,"UYI_",StrFile0);
        TempI = dlmread(StrFileI);
        StrFileR = strcat(dossier,"UYR_",StrFile0);
        TempR = dlmread(StrFileR);
        TempI(1,:) = []; TempR(1,:) = [];
        UY(:,:,Em+1) = TempR'+1i*TempI';


    end

        save(strcat(dossier,'Data_', SuffixesSave(d), '.mat'),'UX','UY','TimeList','Sensors','Sources');
end
