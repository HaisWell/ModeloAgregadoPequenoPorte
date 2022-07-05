%% |printReport.m| -- creates a detailed report of the results

%% Clear workspace.
% Read definitions of dates and the list of countries.

clear('all');
close('all');
home();

a0_readDefinitions;
addpath Functions/

%add the path to functions used througout the file to do certain tasks

%% Version to report. BE SURE TO MAKE CHANGES TO VERSION DESCRIPTION !!!
% Each time you run |estimateParams|, the results are saved under a new
% version number. To access and report the correct results, you need to
% change the following line accordingly.

version = 'VER2';

fprintf('Version to report: %s.\n',version);

%% Check for output directories.
% The result files will be moved to |Reports|, |Graphs|, |OutputData|
% |TexFiles| directories. Make sure they exist.



fprintf('%s...\n',country);
load(sprintf('Results/Version%s/Estimates/%s%s.mat',version,country,version),...
    'f','d','mstar','Hess','Estar','E','starthist','p');

gray = 0.3*[1,1,1];
generalstyle = struct();
generalstyle.axes.xgrid = 'on';
generalstyle.axes.ygrid = 'on';


%% Create new empty report.

x = report.new('Modelo Agregado de Pequeno Porte','visible',false);


% x.include('Modelo Agregado de Pequeno Porte','Modelo_BC_Debug.model','verbatim',true);

x.clearpage();

sty = struct();
sty.line.linewidth = 2;
sty.title.fontsize = 14;
sty.axes.fontsize = 14;


%% Include model code listing.

%x.include('The Model','MODYUK.model','verbatim',true)

%x.clearpage();

%% Add economic activity gaps graph.

thisstyle = generalstyle;
thisstyle.line.color = {'blue',[0,0.5,0],'red', 'yellow'};
thisstyle.line.lineStyle = '-';

x.figure('Hiatos da Atividade Econômica',...
    'range',starthist:endproj);

x.graph('','legend',true,'zeroline',true,'style',thisstyle,'highlight',endhist+1:endproj);
x.series('Output gap',f.HIATO);
x.series('Unemployment gap',f.UNR_GAP/f.p2);
x.series('Capacity utilization gap',f.CAPU_GAP/f.kappa2);
x.series('caged gap', f.CAGED_GAP/f.kappa3);
x.series('pib gap', f.PIB_GAP);


x.highlight('Projecões', endhist+1:endproj);
x.clearpage();


%% Add neutral rate decomposition

thisstyle = generalstyle;
thisstyle.line.color = {'blue',[0,0.5,0],'red'};
thisstyle.line.lineStyle = '-';

x.figure('Política Monetária',...
    'range',starthist:endproj);

x.graph('','legend',true,'zeroline',true,'style',thisstyle,'highlight',endhist+1:endproj);
% x.series('Stance',-(f.STANCE),'plotfunc',@bar);
% x.series('Juro Nominal Esperado',f.E_JURO_NOMINAL);
% x.series('Selic',f.JURO_NOMINAL);
% x.series('Juro Real Ex.Ante',f.JURO_REAL);
% x.series('Juro Nominal Neutro',f.JURO_NEUTRO + f.E_D4L_CPI);
x.band('Taxa Selic Projetada',f.JURO_NOMINAL,-2*f.std.JURO_NOMINAL,2*f.std.JURO_NOMINAL);
x.series('Taxa Selic Realizada', d.JURO_NOMINAL);
x.highlight('Projecões', endhist+1:endproj);


x.clearpage();
%% Add economic activity gaps graph.

thisstyle = generalstyle;
thisstyle.line.color = {'blue',[0,0.5,0],'red', 'yellow'};
thisstyle.line.lineStyle = '-';

x.figure('Hiatos da Atividade Econômica',...
    'range',starthist:endproj);

x.graph('','legend',true,'zeroline',true,'style',thisstyle,'highlight',endhist+1:endproj);
x.series('Output gap',f.HIATO);
x.series('Output gap BC',d.HIATO_BC);


x.highlight('Projecões', endhist+1:endproj);
x.clearpage();

%% Add economic activity gaps graph.

thisstyle = generalstyle;
thisstyle.line.color = {'blue',[0,0.5,0],'red', 'yellow'};
thisstyle.line.lineStyle = '-';

x.figure('Hiatos da Atividade Econômica',...
    'range',starthist:endproj);

x.graph('','legend',true,'zeroline',true,'style',thisstyle,'highlight',endhist+1:endproj);
x.series('L gdp',f.L_GDP);
x.series('L gdp bar',f.L_GDP_BAR);


x.highlight('Projecões', endhist+1:endproj);
x.clearpage();


%% Add real rate graph

thisstyle = generalstyle;
thisstyle.line.color = {'blue',[0,0.5,0],'red'};
thisstyle.line.lineStyle = '-';

x.figure('Política Monetária',...
    'range',starthist:endproj);

x.graph('','legend',true,'zeroline',true,'style',thisstyle,'highlight',endhist+1:endproj);
x.series('Stance',-(f.STANCE),'plotfunc',@bar);
x.series('Juro Real Ex.Ante',f.JURO_REAL);
x.band('Juro Neutro',f.JURO_NEUTRO,-2*f.std.JURO_NEUTRO,2*f.std.JURO_NEUTRO);
x.highlight('Projecões', endhist+1:endproj);


x.clearpage();

% %% Add neutral rate decomposition
% 
% thisstyle = generalstyle;
% thisstyle.line.color = {'blue',[0,0.5,0],'red'};
% thisstyle.line.lineStyle = '-';
% 
% x.figure('Política Monetária',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true,'zeroline',true,'style',thisstyle,'highlight',endhist+1:endproj);
% x.band('Taxa Selic Projetada',f.JURO_NOMINAL,-2*f.std.JURO_NOMINAL,2*f.std.JURO_NOMINAL);
% x.series('Taxa Selic Realizada', d.JURO_NOMINAL);
% x.highlight('Projecões', endhist+1:endproj);
% 
% 
% x.clearpage();

%% Add neutral rate decomposition

thisstyle = generalstyle;
thisstyle.line.color = {'blue',[0,0.5,0],'red'};
thisstyle.line.lineStyle = '-';

x.figure('Política Monetária',...
    'range',starthist:endproj);

x.graph('','legend',true,'zeroline',true,'style',thisstyle,'highlight',endhist+1:endproj);
x.band('Taxa Selic Projetada',f.E4_JURO_NOMINAL,-2*f.std.E4_JURO_NOMINAL,2*f.std.E4_JURO_NOMINAL);
x.series('Taxa Selic Realizada', d.JURO_NOMINAL);
x.highlight('Projecões', endhist+1:endproj);


x.clearpage();



%% Add output gap decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

x.figure('Deomposição do Juro',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[f.teta1*f.JURO_NOMINAL{-1} f.teta2*f.JURO_NOMINAL{-2} (1-f.teta1-f.teta2)*[f.JURO_NEUTRO + f.META + f.teta3*(f.E_D4L_CPI - f.META)] f.RES_JURO_NOMINAL ],...
    'legendEntry=',{'Inércia 1','Inercia 2','Desvio da Meta', 'res'},'plotfunc',@barcon);
x.highlight('Projecões', endhist+1:endproj);
x.clearpage();


%% Add output gap decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';
% 
% x.figure('Peso Controlados',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);
% 
% x.series('',[f.W_CPI_C{-1}*((1+f.DLA_CPI_C/400)/(1+f.DLA_CPI/400))  f.RES_W_CPI_C],...
%     'legendEntry=',{'Ajuste','res'},'plotfunc',@barcon);
% x.series('Peso real', f.W_CPI_C);
% x.highlight('Projecões', endhist+1:endproj);
% x.clearpage();
% 


%% Add output gap decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

x.figure('Peso Controlados',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[f.W_CPI_C{-1}*f.DLA_CPI_C  f.W_CPI_LIVRES{-1}*f.DLA_CPI_LIVRES],...
    'legendEntry=',{'Controlados','Livres'},'plotfunc',@barcon);
x.series('Peso real', f.DLA_CPI);
x.highlight('Projecões', endhist+1:endproj);
x.clearpage();



%% Add output gap decomposition
thisstyle = generalstyle;
thisstyle.line.color = {'blue',[0,0.5,0],'red'};
thisstyle.line.lineStyle = '-';

x.figure('Deomposição do Juro',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[f.JURO_NOMINAL_/8 f.E1_JURO_NOMINAL/4 f.E2_JURO_NOMINAL/4 f.E3_JURO_NOMINAL/4 f.E4_JURO_NOMINAL/8 f.RES_E_JURO_NOMINAL],...
    'legendEntry=',{'juro 0', 'juro 1','juro 2','juro 3','juro 4','Residuo'},'plotfunc',@barcon);
x.series('Juro experado', f.E_JURO_NOMINAL_);
x.highlight('Projecões', endhist+1:endproj);
x.clearpage();

 



%% Add neutral rate decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

x.figure('Decomposição do Juro Neutro',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[f.G, f.Z;],...
    'legendEntry=',{'Produto Potencial','Z Component'},'plotfunc',@barcon);
x.series('Juro Neutro', f.JURO_NEUTRO);
x.highlight('Projecões', endhist+1:endproj);


x.clearpage();


%% Add Inflation Decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

x.figure('Decomposição da Inflação',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[f.alpha1l*f.DLA_CPI_LIVRES{-1}  f.alpha1i*f.D4L_CPI (1-f.alpha1l - f.alpha1i)*f.E_D4L_CPI f.alpha2*f.D_COMM f.alpha3*f.D_DLA_CAMBIO{-2}/4  f.alpha4*f.HIATO ...
    [(f.alpha5*f.D_ELNINO + f.alpha6*f.D_LANINA) + (f.alpha5*f.D_ELNINO{-1} + f.alpha6*f.D_LANINA{-1}) + (f.alpha5*f.D_ELNINO{-2} + f.alpha6*f.D_LANINA{-2})]/3-[(f.alpha5*f.D_ELNINO{-3} + f.alpha6*f.D_LANINA{-3}) + (f.alpha5*f.D_ELNINO{-4} + f.alpha6*f.D_LANINA{-4}) + (f.alpha5*f.D_ELNINO{-5} + f.alpha6*f.D_LANINA{-5})]/3 ...
    f.RES_DLA_CPI_LIVRES;],...
    'legendEntry=',{'Inércia Setorial', 'Inércia IPCA','Expectativa','Commodities', 'Câmbio','Hiato', 'CLIMA_1', 'Resíduo'},'plotfunc',@barcon);

x.series('Inflação',f.DLA_CPI_LIVRES);
x.highlight('Projecões', endhist+1:endproj);


x.clearpage();



%% Add Inflation Decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

x.figure('Decomposição da Inflação de Controlados',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[f.mi1*f.DLA_CPI{-1}  (1-f.mi1)*f.E_D4L_CPI  f.mi3*(f.D_COMM{-1})  f.mi4*f.DUM_ENERGIA f.RES_DLA_CPI_C;],...
    'legendEntry=',{'Inércia','Expectativa', 'Comm (-1)','Dummie', 'Resíduo'},'plotfunc',@barcon);

x.series('Inflação',f.DLA_CPI_C);
x.highlight('Projecões', endhist+1:endproj);


x.clearpage();




%% Add Inflation Decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

x.figure('Decomposição da Expectativa de Inflação',...
    'range',starthist:endproj);

x.graph('Composição da Expectativa','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[ f.phi1*f.D_E_D4L_CPI{-1}  f.phi2*(f.E4_D4L_CPI - f.E4_META)  f.phi3*(f.D4L_CPI{-1} - f.META{-1})  f.RES_E_D4L_CPI;],...
    'legendEntry=',{ 'Inércia','Expectativa Consistente','Inflação Passada', 'Hiato','Resíduo'},'plotfunc',@barcon);
x.series('Expectativa',f.D_E_D4L_CPI);
x.highlight('Projecões', endhist+1:endproj);
x.clearpage();




%% Add output gap decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

x.figure('Deomposição do Hiato',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);

x.series('',[f.beta1*f.HIATO{-1} -f.beta2*f.STANCE -f.beta4*f.INCERTEZA  f.RES_HIATO],...
    'legendEntry=',{'Inércia','Stance de Politica Monetária','Incerteza','Residuo'},'plotfunc',@barcon);
x.highlight('Projecões', endhist+1:endproj);
x.clearpage();








%% Juros
thisstyle = generalstyle;
thisstyle.line.color = {'k','k', 'red','red'};
thisstyle.line.lineStyle = {'-', '--', '--', '--'};

x.figure('Inflação & Meta',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj,  'style', thisstyle);

x.band('Inflação YoY',f.D4L_CPI, -2*f.std.D4L_CPI, 2*f.std.D4L_CPI);
x.series('Meta',f.META);
x.series('Teto da Meta',f.META+1.5, 'color', 'r');
x.series('Piso da Meta',f.META-1.5, 'color', 'r');
x.highlight('Projecões', endhist+1:endproj);
x.clearpage();


%% Juros
thisstyle = generalstyle;
thisstyle.line.color = {'k','k', 'red','red'};
thisstyle.line.lineStyle = {'-', '--', '--', '--'};

x.figure('Meta e Expectativa de Inflação',...
    'range',starthist:endproj);

x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj,  'style', thisstyle);

x.band('Expectativa de Inflação',f.E_D4L_CPI, -2*f.std.E_D4L_CPI, 2*f.std.E_D4L_CPI);
x.series('Meta',f.META);
x.series('Teto da Meta',f.META+1.5, 'color', 'r');
x.series('Piso da Meta',f.META-1.5, 'color', 'r');
x.highlight('Projecões', endhist+1:endproj);
x.clearpage();

%% Add Expectativa Decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';



%% Add Inflation Decomposition
%thisstyle = generalstyle;
%thisstyle.line.color = {'blue',[0,0.5,0],'red'};
%thisstyle.line.lineStyle = '-';

%% Add output gap graph.

% x.figure('Output Gap +/- 2 std devs (w/o model or parameter uncertainty)',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true,'highlight',endhist+1:endproj,'zeroline',true,'style',generalstyle);
% x.series('Inflation',f.D4L_CPI);
% x.band('Output gap',f.HIATO,-2*f.std.HIATO,2*f.std.HIATO);
% x.highlight('Projecões', endhist+1:endproj);
% x.clearpage();
% 


%% Add unemployment rate graph.

% x.figure('Unemployment Rate',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true,'legendlocation','North','highlight',endhist+1:endproj,'style',generalstyle);
% x.series('Actual ',f.UNR);
% x.band('Equilibrium +/- 2 std devs',f.UNR_BAR,-2*f.std.UNR_BAR,2*f.std.UNR_BAR);
% % x.series('Steady-state unemployment rate',tseries(starthist:endproj,f.unr_ss));
% x.highlight('Projecões', endhist+1:endproj);
% 
% x.clearpage();

%% Add capacity utilization graph.

% x.figure('Equilibrium Capacity Utilization +/- 2 std devs (w/o model or parameter uncertainty)',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true,'highlight',endhist+1:endproj,'style',generalstyle);
% x.series('Actual',f.CAPU);
% x.band('Equilibrium+/- 2 std devs',f.CAPU_BAR,-2*f.std.CAPU_BAR,2*f.std.CAPU_BAR);
% x.highlight('Projecões', endhist+1:endproj);
% 
% x.clearpage();
% 

% plot([f.DLA_CPI_LIVRES, f.DLA_CPI_C, f.DLA_CPI])

%% Add capacity utilization graph.

% x.figure('Caged',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true,'highlight',endhist+1:endproj,'style',generalstyle);
% x.series('Actual',f.CAGED);
% x.band('Equilibrium+/- 2 std devs',f.CAGED_BAR,-2*f.std.CAGED_BAR,2*f.std.CAGED_BAR);
% x.highlight('Projecões', endhist+1:endproj)
% 
% x.clearpage();


%% Add capacity utilization graph.

% x.figure('Caged',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true,'highlight',endhist+1:endproj,'style',generalstyle);
% x.series('Actual',f.CAGED_GAP);
% x.highlight('Projecões', endhist+1:endproj)
% 
% x.clearpage();




%% Add capacity utilization graph.

% x.figure('Cambio',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true,'highlight',endhist+1:endproj,'style',generalstyle);
% x.band('Equilibrium+/- 2 std devs',exp(f.CAMBIO/100),-2*(exp(f.std.CAMBIO/100)-1),2*(exp(f.std.CAMBIO/100)-1));
% x.highlight('Projecões', endhist+1:endproj);
% 
% x.clearpage();



%% Add capacity utilization graph.
% 
% x.figure('Deomposição do Cambio',...
%     'range',starthist:endproj);
% 
% x.graph('','legend',true, 'zeroline',true,'highlight',endhist+1:endproj);
% 
% x.series('',[f.CAMBIO_PPC -f.deltadiff*(f.DIFF_JURO - f.DIFF_JURO{-1}) f.RES_DLA_CAMBIO],...
%     'legendEntry=',{'Cambio PPC','Diferencial de Juros','Residuo'},'plotfunc',@barcon);
% x.series('Cambio',f.DLA_CAMBIO);
% x.highlight('Projecões', endhist+1:endproj);
% x.clearpage();




%% Create and include file with parameter estimate table.

createEstimTable(Hess,E,mstar);
x.include('Regularized Maximum Likelihood','estimTable.tex');

x.clearpage();



%% Compile PDF.

x.publish(sprintf('%sReport%s.pdf',country,version),'display',true);


plot([f.W_CPI_LIVRES, f.W_CPI_C])
