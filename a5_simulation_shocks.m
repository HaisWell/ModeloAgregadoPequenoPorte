%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% IMPULSE RESPONSE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housekeeping
clearvars
close all

%% If non-existent, create "results" folder where all results will be stored
[~,~,~] = mkdir('results');

%% Read the model
load C:/Modelos/Modelo_Agreg_BC_Formal/Results/VersionVER1/Estimates/BRVER1.mat m


version = 'VER0';
country = 'BR';

load(sprintf('Results/Version%s/Estimates/%s%s.mat',version,country,version),...
    'm');

%% Define shocks
% One period unexpected shocks: inflation, output, exchange rate, interest rate
% Create a list of shock variables and a list of their titles. The shock variables
% must have the names found in the model code (in file 'model.model')
listshocks = {'RES_HIATO','RES_DLA_CAMBIO','RES_JURO_NOMINAL', 'RES_CDS', 'RES_E_D4L_CPI', 'RES_INCERTEZA'}; % The last shock (monetary policy) is added in the video
listtitles = {'Aggregate Demand Shock', 'Exchange Rate Shock', 'Interest Rate (monetary policy) Shock', 'cds shock', 'expectativa', 'RES_INCERTEZA'}; % The last shock (monetary policy) is added in the video

% Set the time frame for the simulation 
startsim = qq(0,1);
endsim = qq(3,4); % four-year simulation horizon

% For each shock a zero database is created (command 'zerodb') and named as 
% database 'd.{shock_name}'
for i = 1:length(listshocks)
    d.(listshocks{i}) = zerodb(m,startsim:endsim);
end

% Fill the respective databases with the shock values for the starting
% point of the simulation (startsim). For simplicity, all shocks are set to
% 1 percent
d.RES_HIATO.RES_HIATO(startsim) = -1;
d.RES_DLA_CAMBIO.RES_DLA_CAMBIO(startsim) = 10;
d.RES_JURO_NOMINAL.RES_JURO_NOMINAL(startsim) = 1;
d.RES_JURO_NOMINAL.RES_JURO_NOMINAL(qq(0,2)) = -0.45;
d.RES_JURO_NOMINAL.RES_JURO_NOMINAL(qq(0,3)) = 0.1;
d.RES_JURO_NOMINAL.RES_JURO_NOMINAL(qq(0,4)) = 0.1;
d.RES_CDS.RES_CDS(qq(0,2)) = 100;
d.RES_E_D4L_CPI.RES_E_D4L_CPI(qq(0,1)) = 1;
d.RES_INCERTEZA.RES_INCERTEZA(qq(0,1)) = 10;

%% Simulate IRFs
% Simulate the model's response to a given shock using the command 'simulate'.
% The inputs are model 'm' and the respective database 'd.{shock_name}'.
% Results are written in database 's.{shock_name}'.
for i=1:length(listshocks)    
    s.(listshocks{i}) = simulate(m,d.(listshocks{i}),startsim:endsim,'deviation',true);
end

%% Generate pdf report
x = report.new('Shocks');

% Figure style
sty = struct();
sty.line.linewidth = 1;
sty.line.linestyle = {'-';'--'};
sty.line.color = {'k';'r'};
sty.legend.location = 'Best';

% Create separate page with IRFs for each shock
for i = 1:length(listshocks)

x.figure(listtitles{i},'zeroline',true,'style',sty, ...
         'range',startsim:endsim,'legend',false,'marks',{'Baseline','Alternative'});

x.graph('CPI Inflation QoQ (% ar)','legend',true);
x.series('',s.(listshocks{i}).D4L_CPI);

x.graph('Nominal Interest Rate (% ar)');
x.series('',s.(listshocks{i}).JURO_NOMINAL);

% x.graph('Nominal ER Deprec. QoQ (% ar)');
% x.series('',s.(listshocks{i}).DLA_S);

x.graph('Output Gap (%)');
x.series('',[s.(listshocks{i}).HIATO]);

x.graph('Stance (%)');
x.series('', s.(listshocks{i}).STANCE);

x.graph('Juro neutro (%)');
x.series('', s.(listshocks{i}).JURO_NEUTRO);

x.graph('Expectativa (%)');
x.series('', s.(listshocks{i}).E_D4L_CPI);

% x.graph('Real Exchange Rate Gap (%)');
% x.series('', s.(listshocks{i}).L_Z_GAP);
 
% This graph is added in the video 
% x.graph('Real Monetary Condition Index (%)');
% x.series('', s.(listshocks{i}).MCI);

end
s.RES_JURO_NOMINAL.JURO_NOMINAL
x.publish('results/Shocks.pdf','display',false);
disp('Done!!!');