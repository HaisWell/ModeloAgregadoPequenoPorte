%%%%%%%%%%%%%%%%%%%%%%%%
%%% In-sample Simulation
%%%%%%%%%%%%%%%%%%%%%%%%

% close all figure windows
close all;

% clear workspace
clearvars;

% add folder "utils" on matlab path
addpath Functions

%% Set time ranges
stime = qq(2005,2); %starting point of the first simulation 
                    %stime-1 is the initial state
                    %stime is the first simulated time period
etime = qq(2026,4); %the end of the known history
       
%% Selection of model variables to include in the report:

list_xnames = {'DLA_CPI', 'DLA_CPI_LIVRES', 'DLA_CPI_C','D4L_CPI','E_D4L_CPI','HIATO','JURO_NOMINAL', 'META', 'INCERTEZA', 'JURO_NEUTRO', 'G', 'UNR'}; 

%% Calling function (stored in "utils" folder) which generates the in-sample simulations and reports the results

country = 'BR';

version = 'VER0';

fprintf('Version to report: %s.\n',version);

fprintf('%s...\n',country);
load(sprintf('C:/Modelos/Modelo_Agreg_BC_Formal/Results/Version%s/Estimates/%s%s.mat',version,country,version),...
    'f','d','mstar','Hess','Estar','E','starthist','p');



% get model variables descriptions 
desc = get(mstar,'descript');

%% Database preparation

% load Kalman filter results
h = f;
% Remove all residuals from the database filter database
h = rmfield(h,get(mstar,'eList'));
% get range of the database h
h_range = dbrange(h);

% initialize results database "res"
for i = 1:length(list_xnames)
    res.(list_xnames{i}) = tseries();
end

%% Simulations ... (done in a "FOR loop")
%Beginning of the "FOR loop" ...
for time = stime:1:etime
  
    % set simulation range
    fcastrng = time:time+8;
    if fcastrng(end)>etime
        exorng = time:etime;
    else
        exorng = time:time+8;
    end

disp(' ');
disp('---------------------------------------------------------------------')
disp(['The first simulated time period of this projection round: ',char(dat2str(time+1))]);
disp(' ');

% Create simulation plan
fcast_plan  = Plan.forModel(mstar,fcastrng);
    
% condition the forecast on the inflation target
fcast_plan  = exogenize(fcast_plan,exorng,'META');
fcast_plan  = endogenize(fcast_plan,exorng,'RES_META');

fcast_plan  = exogenize(fcast_plan,exorng,'INCERTEZA');
fcast_plan  = endogenize(fcast_plan,exorng,'RES_INCERTEZA');

fcast_plan  = exogenize(fcast_plan,exorng,'CDS');
fcast_plan  = endogenize(fcast_plan,exorng,'RES_CDS');

fcast_plan  = exogenize(fcast_plan,exorng,'FEDFUNDS');
fcast_plan  = endogenize(fcast_plan,exorng,'RES_FEDFUNDS');

fcast_plan  = exogenize(fcast_plan,exorng,'D_LANINA');
fcast_plan  = endogenize(fcast_plan,exorng,'RES_D_LANINA');

fcast_plan  = exogenize(fcast_plan,exorng,'D_ELNINO');
fcast_plan  = endogenize(fcast_plan,exorng,'RES_D_ELNINO');

fcast_plan  = exogenize(fcast_plan,exorng,'DUM_ENERGIA');
fcast_plan  = endogenize(fcast_plan,exorng,'RES_DUM_ENERGIA');




% Simulate the model
dbfcast = simulate(mstar,h,fcastrng,'plan',fcast_plan);

% combine Kalman filter results with the simulation results
s = dbextend(dbclip(h,h_range(1):fcastrng(1)-1),dbfcast);
    
% Add the results into the database "res"
for i = 1:length(list_xnames)
    res.(list_xnames{i}) = [res.(list_xnames{i}), s.(list_xnames{i})];
end

end %end of the simulation "loop"

%% Generate report

srep = stime-4; % beginning of reported range
erep = etime; % end of reported range

% Start the report
x = report.new('In-Sample Forecasts','visible',false);

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
    x.graph(desc.(list_xnames{i}),'legend',false);
    % plot simulation results
    x.series('',res.(list_xnames{i}));
    % plot filtered data
    x.series('',h.(list_xnames{i}),'plotOptions',{'color','k'});
end

% generate the PDF file
x.publish('results/In_sample.pdf','display',false);

