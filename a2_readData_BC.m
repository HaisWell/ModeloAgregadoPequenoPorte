%% |readData.m| -- Read data from a CSV file.

%% Clear the workspace

clear('all');
close('all');
home();

%% Define dates and the country of interest.

a0_readDefinitions;

%% Download data from CSV file and load model

d = databank.fromCSV(sprintf('InputData/data_%s.csv',country));
load model_bc.mat m

%% Create measurement variables
d = dbbatch(d,'$1','x12(d.$0,Inf,''mode'',''m'')','namefilter','(.*)_U','fresh',false);

d.L_CAGED = log(d.CAGED)*100;

JUDGEMENT = tseries(qq(2017,1):qq(2019,4),[-3.38 -3.32 -3.09 -2.57 -2.15 -2.27 -2.22 -2.11  -2 -2.17 -2.19 -2.12]);
[~, d.PIB_GAP_] = hpf(d.L_GDP,inf,'lambda',1600,'level',d.L_GDP-JUDGEMENT);

JUDGEMENT = tseries(qq(2017,1):qq(2019,4),[-3.38 -3.32 -3.09 -2.57 -2.15 -2.27 -2.22 -2.11  -2 -2.17 -2.19 -2.12]);
[LEVEL, d.CAGED_GAP_] = hpf(d.L_CAGED,inf,'lambda',1600,'level',d.L_CAGED-JUDGEMENT);

plot([d.L_CAGED, LEVEL])


d.DLA_CPI_LIVRES_ = 4*diff(d.L_LIVRES);
d.DLA_CPI_C_ = 4*diff(d.L_CPI_C);
d.DLA_CPI_ = 4*diff(d.L_CPI);
d.E_D4L_CPI_ = d.EXPECTATIVA;
d.CAMBIO_ = d.L_CAMBIO;
d.INCERTEZA_  = d.INCERTEZA;
d.JURO_NOMINAL_ = d.JURO_NOMINAL;
d.META_ = d.META;
d.CDS_= d.CDS;
d.FEDFUNDS_ = d.UST10;
d.L_GDP_ = d.L_GDP;
d.L_CPI_ = d.L_LIVRES;
d.CAPU_ = d.CAPU;
d.UNR_ = d.UNR;
d.CAGED_ = d.L_CAGED;
d.E_JURO_NOMINAL_ = d.E_JURO_NOMINAL;
d.HIATO_ = d.HIATO_BC;
d.DLA_COMM_METAL_ = diff(log(d.COMM_METAL)*400);
d.DLA_COMM_AGRO_ = diff(log(d.COMM_AGRO)*400);
d.DLA_COMM_ENERGY_ = diff(log(d.COMM_ENERGIA)*400);
d.W_CPI_C_ = d.W_CPI_C/100;
d.PRIMARIO_ = d.PRIMARIO;
% d.PIB_GAP_ = d.GDP_GAP;
% d.CAGED_GAP_ = d.CAGED_GAP;
%% Check if any measurement variables are missing from the database

ylist = get(m,'ylist');
list = fieldnames(d);
missing = ylist - list;
if isempty(missing)
   disp('All measurement variables available.');
else
   disp('Measurement variables missing from the database:');
   disp(missing);
end



%% Save data structure for future use.

save('data_bc.mat','d');
