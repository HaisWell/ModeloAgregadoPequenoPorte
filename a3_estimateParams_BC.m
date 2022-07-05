%% |estimateParams.m| -- Estimate parameters using maximum regularised likelihood.

%% Clearing the workspace

a1_readModel_BC;
a2_readData_BC;

clear all;
close all;
home();

%% Load data and model

load('data_bc.mat', 'd');
load('model_bc.mat','m', 'P');

%% Read important dates

a0_readDefinitions;


%% Display some summary information 

fprintf('%s...\n',country);
display(version);
starthist = qq(2005,2);
fprintf('start date = %s\n',dat2char(starthist));

%% Some housekeeping

if ~(exist(sprintf('Results/Version%s',version),'dir') == 7)
    mkdir(sprintf('Results/Version%s',version))
end

%Write a short description of current version to a text file
fid = fopen(sprintf('Results/Version%s/Description%s.txt',version,version),'w');
fprintf(fid,'Model \r\n'); %Notepad doesn't recognize \n as new line
fclose(fid);

%% Prior database.
% The prior for each parameter is a truncated normal distribution.
% Each parameter is assigned four numbers:
% 
% [ prior mode, lower bound, upper bound, 1/(prior std dev before penalty)^2 ]
   


exog = struct( );
exog.RES_CDS = d.CDS_-200;
exog.RES_FEDFUNDS = d.FEDFUNDS_-2;
exog.RES_INCERTEZA = d.INCERTEZA_;
exog.RES_META = (d.META)-3;
exog.RES_D_LANINA = d.d_lanina*d.ONI*d.ONI;
exog.RES_D_ELNINO = d.d_elnino*d.ONI*d.ONI;
exog.RES_DUM_ENERGIA = d.DUM_ENERGIA;
exog.RES_DLA_COMM_METAL = d.DLA_COMM_METAL_ - 0.1966*d.DLA_COMM_METAL_{-1};
exog.RES_DLA_COMM_AGRO = d.DLA_COMM_AGRO_ - 0.1702*d.DLA_COMM_AGRO_{-1};
exog.RES_DLA_COMM_ENERGY = d.DLA_COMM_ENERGY_ - 0.2875*d.DLA_COMM_ENERGY_{-1};



init = get(m, "parameters");
E = struct();

E.alpha1l = {init.alpha1l, 0.01,  0.95};
E.alpha1i = {init.alpha1i, 0.01,  0.95};
E.alpha2 = {init.alpha2, 0,  0.95};
E.alpha3 = {init.alpha3, 0.01,  0.95};
E.alpha4 = {init.alpha4, 0.01,  0.95};
E.alpha5 = {init.alpha5, 0.01,  2};
E.alpha6 = {init.alpha6, 0.01,  2};


E.beta1    = {init.beta1, 0.01,  0.95};
E.beta2    = {init.beta2,   0.01,    1};

E.teta1     = {init.teta1, 0.01,    2};
E.teta2     = {init.teta2, -1,    1};
E.teta3     = {init.teta3, 1.5,    8};


E.phi1    = {init.phi1, 0.01,    0.95};
E.phi2    = {init.phi2, 0.01,    0.95};
E.phi3    = {init.phi3, 0.01,    0.95};
% E.phi4    = {init.phi4, 0.01,    0.95};


E.mi1 = {init.mi1, 0,    1};
% E.mi2 = {0.05, 0,    1};
E.mi3 = {init.mi3, 0,    1};
E.mi4 = {init.mi4, 0,    25};

E.tau     = {init.tau, 0.01,    0.2};
E.deltadiff = {init.deltadiff, 0.01, 10};
E.gaps_devpad = {init.gaps_devpad, 0, 2};
E.p2    = {init.p2, 0.1,    3};
E.kappa2  = {init.kappa2, 0.01,    3 };
E.kappa3  = {init.kappa3, 0.01,    3 };



E.std_RES_JURO_NOMINAL  = {init.std_RES_JURO_NOMINAL,   0.01, 3}; %ok
E.std_RES_E_JURO_NOMINAL  = {init.std_RES_E_JURO_NOMINAL,   0.01, 3}; %ok
E.std_RES_E_D4L_CPI  = {init.std_RES_E_D4L_CPI,   0.01, 3}; %ok

E.std_RES_DLA_CPI_C= {init.std_RES_DLA_CPI_C,   0.01, 30}; %ok
E.std_RES_DLA_CPI_LIVRES      = {init.std_RES_DLA_CPI_LIVRES,   0, 5}; %ok

E.std_RES_DLA_CAMBIO = {init.std_RES_DLA_CAMBIO,   0.01, 30}; %ok
E.std_RES_HIATO        = {init.std_RES_HIATO,     0.01, 0.9}; %ok
E.std_RES_Z  = {init.std_RES_Z,   0.01, 1};
E.std_RES_G        = {init.std_RES_G,     0.01, 5};
E.std_RES_W_CPI_C= {init.std_RES_W_CPI_C,   0, 0.1}; %ok








for n = databank.fieldNames(E)
    E.(n){4} = distribution.Uniform.fromLowerUpper(E.(n){2},E.(n){3});
end


E.beta4    = {0.05,   0.01,    0.95, distribution.Beta.fromMeanStd(0.05,0.005)};



filterOpt = {
    "relative"; false
    "Override"; exog
    "ahead"; 12
};




optimSet = { ...
    "MaxFunEvals"; 10000
    "MaxIter"; 100
};


p = 0.1;

[Estar,pos,Grad,Hess,mstar] = estimate(m, d, starthist:qq(2019,4), E ...
    , "filter", filterOpt,'penalty',p,'tolx',1e-12,'tolfun',1e-12,'noSolution','penalty', 'SState', false, "MaxFunEvals", 2000, ...
    "MaxIter", 3000);

Estar







output_kalman = kalmanFilter(mstar, d, starthist:endproj, 'ahead',12, 'Override', exog, 'Contributions', true);
f = output_kalman.Mean;
f.std = output_kalman.Std;


dirs = {'Estimates'};
for ii = 1 : numel(dirs)
    if exist(sprintf('Results/Version%s/%s',version,dirs{ii}),'dir') ~= 7
        mkdir(sprintf('Results/Version%s/%s',version,dirs{ii}));
    end
end



filename = sprintf('Results/Version%s/Estimates/%s%s.mat',version,country,version);
fprintf('Saving %s.\n',filename);
save(filename);
    

a4_printReport_BC
