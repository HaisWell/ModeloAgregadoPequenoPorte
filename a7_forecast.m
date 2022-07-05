%%%%%%%%%%%%%%%%%%%%%%%%
%%% In-sample Simulation
%%%%%%%%%%%%%%%%%%%%%%%%



clear('all');
close('all');
home();

a0_readDefinitions;
addpath Functions/
version = 'VER0';
fprintf('Version to report: %s.\n',version);
fprintf('%s...\n',country);
load(sprintf('Results/Version%s/Estimates/%s%s.mat',version,country,version),...
    'f');


load('data_bc.mat', 'd');
load('model_bc.mat','m');



%% Set time ranges
stime = qq(2022,2);
etime = qq(2026,4);
       
%% Selection of model variables to include in the report:

list_xnames = {'DLA_CPI','HIATO', 'JURO_NOMINAL', 'E_D4L_CPI', 'STANCE', 'JURO_NEUTRO' , 'META'}; 


%% Load model 

% get model variables descriptions 
desc = get(m,'descript');

%% Database preparation

% load Kalman filter results
%h = databank.fromCSV('results/kalm_his.csv');
% Remove all residuals from the database filter database
f = rmfield(f,get(m,'eList'));
% get range of the database h
f_range = databank.range(f);

% initialize results database "res"
for i = 1:length(list_xnames)
    res.(list_xnames{i}) = tseries();
end

%% Simulations ... (done in a "FOR loop")
%Beginning of the "FOR loop" ...


fcastrng = stime:etime;
exorng = stime:etime;

disp(' ');
disp('---------------------------------------------------------------------')
disp(['The first simulated time period of this projection round: ',char(dat2str(stime+1))]);
disp(' ');

% Create simulation plan
fcast_plan  = plan(m,fcastrng);
    
% condition the forecast on the inflation target
fcast_plan  = exogenize(fcast_plan,'META',exorng);
fcast_plan  = endogenize(fcast_plan,'RES_META',exorng);

%fcast_plan  = exogenize(fcast_plan,'CLIMA',exorng);
%fcast_plan  = endogenize(fcast_plan,'SHK_CLIMA',exorng);

%fcast_plan  = exogenize(fcast_plan,'INCERTEZA',exorng);
%fcast_plan  = endogenize(fcast_plan,'SHK_INCERTEZA',exorng);


% fcast_plan  = exogenize(fcast_plan,'DLA_S',exorng);
% fcast_plan  = endogenize(fcast_plan,'SHK_L_S',exorng);

% fcast_plan  = exogenize(fcast_plan,'E_DLA_CPI',exorng);
% fcast_plan  = endogenize(fcast_plan,'SHK_E_CPI_DLA',exorng);

% fcast_plan  = exogenize(fcast_plan,'NUCI',exorng);
% fcast_plan  = endogenize(fcast_plan,'SHK_NUCI',exorng);



% condition the forecast on the foreign inflation rate
% fcast_plan  = exogenize( fcast_plan,'ss_DLA_GDP_BAR',exorng);
% fcast_plan  = endogenize(fcast_plan,'SHK_DLA_GDP_BAR',exorng);



% Simulate the model
dbfcast = simulate(m,f,fcastrng,'plan',fcast_plan,'anticipate',false);

% combine Kalman filter results with the simulation results
s = dbextend(dbclip(f,f_range(1):fcastrng(1)-1),dbfcast);
    
% Add the results into the database "res"
for i = 1:length(list_xnames)
    res.(list_xnames{i}) = [res.(list_xnames{i}), s.(list_xnames{i})];
end



%% Generate report

srep = stime-28; % beginning of reported range
erep = etime; % end of reported range

% Start the report
x = report.new('Forecasts','visible',false);

% Define style for figures
sty = struct();
sty.line.linewidth = 2;
sty.title.fontsize = 14;
sty.axes.fontsize = 14;

% plot figure in a FOR loop
for i = 1:length(list_xnames)
    % open new figure window
    x.figure('','range',srep:erep,'dateformat','YY:P','style',sty);
    % open new graph
    x.graph(desc.(list_xnames{i}),'legend',true,'dateTick', srep:2:erep);
    % plot simulation results
    x.series('',res.(list_xnames{i}));
    % plot filtered data
    x.series('',f.(list_xnames{i}),'plotOptions',{'color','k'});
end

% x.figure('','style',sty,'range',srep:erep,'dateformat','YY:P');
% x.graph('Inflation decomposition, qoq percent','legend',true);
% x.series('',[s.a1*s.DLA_CPI{-1} (1-s.a1)*s.E_DLA_CPI s.a2*s.a3*s.L_GDP_GAP s.a2*(1-s.a3)*s.L_Z_GAP s.SHK_DLA_CPI],...
%   'legendEntry=',{'Persistency','Expectations','Output Gap','RER Gap','Shock'},'plotfunc',@barcon);
% x.series('',s.DLA_CPI,'legendEntry=',{'Inflation'});




% generate the PDF file
x.publish('results/Forecast.pdf','display',false);






