function createEstimTable(Hess,E,mstar)

Cov = inv(Hess{1});
plist = fieldnames(E);
np = numel(plist);
table = {};

for j = 1 : np
   priormode = E.(plist{j}){1};
   lowerbound = E.(plist{j}){2}; %prior standard deviation after imposition of penalty
   upperbound = E.(plist{j}){3};
   postmode = mstar.(plist{j})(1);
   poststd = sqrt(Cov(j,j));
   distri = E.(plist{j}){4}.Name;
   table(j,:) = {
      ['\texttt{',latex.replaceSpecChar(plist{j}),'}'],...
      sprintf('$%.3f$',priormode),...
      sprintf('$%.3f$',lowerbound),...
      sprintf('$%.3f$',upperbound),...
      sprintf('$%s$',distri),...
      sprintf('$%.3f$',postmode),...
      sprintf('$%.3f$',poststd)}; 
end

nl = sprintf('\n');
c = [nl,nl,'\begin{tabular}{lrrrrrr}\hline',nl,...
   'Parameter & \multicolumn{4}{c}{Prior} & \multicolumn{2}{c}{Posterior} \\ ',nl,...
   '& \makebox[4em]{\hfill Mode} & \makebox[6em]{\hfill Lower Bound} & \makebox[6em]{\hfill Upper Bound} & \makebox[5em]{\hfill Distribution} & \makebox[6em]{\hfill Mode} & \makebox[5em]{\hfill Dispersion}  \\ \hline'];
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

if exist('estimTable.tex','file')
   delete('estimTable.tex');
end
char2file(c,'estimTable.tex');
rehash('path'); 
