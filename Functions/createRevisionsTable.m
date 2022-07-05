function [HPY0,Y0,targ_Y,targ_Y_hp] = createRevisionsTable(mstar,f,d,endhist) 

% Compute quasi real-time estimates of the output and unemployment gap;
r.Y = tseries(); r.UNR_GAP = tseries();
hp.Y = tseries(); hp.UNR_GAP = tseries();

d1 =  get(d.LGDP,'start');
d2 =  get(d.UNR,'start');
start = max(d1,d2);

targ_Y = f.Y;
targ_UNR_GAP = f.UNR_GAP;
targ_Y_hp = hpf2(f.LGDP,start:endhist);
targ_UNR_GAP_hp = hpf2(f.UNR,start:endhist);

for t = 1 : length(start +12 :endhist - 12);
    %MV filter
    [m1,smooth] = filter(mstar,d,start:start + 12 + t,'objectivesample',start:start+t);
    r.Y(start:start + 12 + t,t) = smooth.mean.Y;
    r.UNR_GAP(start:start + 12 + t,t) = smooth.mean.UNR_GAP;
    
    %HP filter
    hp.Y(start:start + 12 + t,t) = hpf2(d.LGDP{start:start + 12 + t});
    hp.UNR_GAP(start:start + 12 + t,t) = hpf2(d.UNR{start:start + 12 + t});
end;

clear('mar');

HPY0 = tseries(); Y0 = tseries();
for t = 1 : length(start + 12 : endhist - 12);
          HPY0(start + 12 + t) = hp.Y{start + 12 + t, t};
          
          mar.HPY0(t) = abs(targ_Y_hp(start + 12 + t) - hp.Y(start + 12 + t, t));
          mar.HPY4(t) = abs(targ_Y_hp(start + 12 + t - 3) - hp.Y(start + 12 + t - 3, t));
          mar.HPY8(t) = abs(targ_Y_hp(start + 12 + t - 7) - hp.Y(start + 12 + t - 7, t));
          mar.HPY12(t) = abs(targ_Y_hp(start + 12 + t - 11) - hp.Y(start + 12 + t - 11, t));
          
          Y0(start + 12 + t) = r.Y{start + 12 + t, t};
          mar.Y0(t) = abs(targ_Y(start + 12 + t) - r.Y(start + 12 + t, t));
          mar.Y4(t) = abs(targ_Y(start + 12 + t - 3) - r.Y(start + 12 + t - 3, t));
          mar.Y8(t) = abs(targ_Y(start + 12 + t - 7) - r.Y(start + 12 + t - 7, t));
          mar.Y12(t) = abs(targ_Y(start + 12 + t - 11) - r.Y(start + 12 + t - 11, t));
          
          mar.HPUNR_GAP0(t) = abs(targ_UNR_GAP_hp(start + 12 + t) - hp.UNR_GAP(start + 12 + t, t));
          mar.HPUNR_GAP4(t) = abs(targ_UNR_GAP_hp(start + 12 + t - 3) - hp.UNR_GAP(start + 12 + t - 3, t));
          mar.HPUNR_GAP8(t) = abs(targ_UNR_GAP_hp(start + 12 + t - 7) - hp.UNR_GAP(start + 12 + t - 7, t));
          mar.HPUNR_GAP12(t) = abs(targ_UNR_GAP_hp(start + 12 + t - 11) - hp.UNR_GAP(start + 12 + t - 11, t));
          
          mar.UNR_GAP0(t) = abs(targ_UNR_GAP(start + 12 + t) - r.UNR_GAP(start + 12 + t, t));
          mar.UNR_GAP4(t) = abs(targ_UNR_GAP(start + 12 + t - 3) - r.UNR_GAP(start + 12 + t - 3, t));
          mar.UNR_GAP8(t) = abs(targ_UNR_GAP(start + 12 + t - 7) - r.UNR_GAP(start + 12 + t - 7, t));
          mar.UNR_GAP12(t) = abs(targ_UNR_GAP(start + 12 + t - 11) - r.UNR_GAP(start + 12 + t - 11, t));
 end;

 table = {};
 
 table(1,:) = {
       ['\texttt{',latex.replaceSpecChar('Y'),'}'],...
      sprintf('$%.3f$',mean(mar.Y12)),... 
      sprintf('$%.3f$',mean(mar.Y8)),...
      sprintf('$%.3f$',mean(mar.Y4)),... 
      sprintf('$%.3f$',mean(mar.Y0))};
  
   table(2,:) = {
       ['\texttt{',latex.replaceSpecChar('Y (HP)'),'}'],...
      sprintf('$%.3f$',mean(mar.HPY12)),... 
      sprintf('$%.3f$',mean(mar.HPY8)),...
      sprintf('$%.3f$',mean(mar.HPY4)),... 
      sprintf('$%.3f$',mean(mar.HPY0))};
 
  table(3,:) = {
      ['\texttt{',latex.replaceSpecChar('UNR_GAP'),'}'],...
      sprintf('$%.3f$',mean(mar.UNR_GAP12)),...
      sprintf('$%.3f$',mean(mar.UNR_GAP8)),...
      sprintf('$%.3f$',mean(mar.UNR_GAP4)),... 
      sprintf('$%.3f$',mean(mar.UNR_GAP0))};
   
  table(4,:) = {
      ['\texttt{',latex.replaceSpecChar('UNR_GAP (HP)'),'}'],...
      sprintf('$%.3f$',mean(mar.HPUNR_GAP12)),...
      sprintf('$%.3f$',mean(mar.HPUNR_GAP8)),...
      sprintf('$%.3f$',mean(mar.HPUNR_GAP4)),... 
      sprintf('$%.3f$',mean(mar.HPUNR_GAP0))};
 
nl = sprintf('\n');
c = [nl,nl,'\begin{tabular}{lrrrr}\hline',nl,...
   'quarter & \makebox[4em]{\hfill $t-12$} & \makebox[4em]{\hfill $t-8$} & \makebox[4em]{\hfill $t-4$} & \makebox[4em]{\hfill $t$ (nowcast)} \\ \hline'];
for row = 1 : size(table,1)
   c = [c,nl];
   for col = 1 : size(table,2)
      c = [c,table{row,col}];
      if col < size(table,2)
         c = [c,' & '];
      else
         c = [c,' \\ '];
      end
   end
end
c = [c,nl,'\hline \end{tabular}',nl,nl];

if exist('RevisionsTable.tex','file')
   delete('RevisionsTable.tex');
end
char2file(c,'RevisionsTable.tex');
rehash('path');
