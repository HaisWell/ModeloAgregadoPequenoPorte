function createRMSETable(pe,ylist)
%
% |pe|, structure containing prediction errors
% |ylist|, list of measurement variables for which you want RMSEs computed
% and displayed

np = numel(ylist);

for j = 1 : length(ylist)
    tmp = pe.(ylist{j});
    nrng = get(tmp,'nanrange'); %make sure you are basing RMSEs on same number of forecasts
    tmp = tmp{nrng(2:end)}; %drop forecast based on initial condition for longest horizon
    rmse.(ylist{j}) = sqrt(mean(tmp.^2));
end

for j = 1 : np
   qahead1 = rmse.(ylist{j})(1);
   qahead4 = rmse.(ylist{j})(4);
   qahead8 = rmse.(ylist{j})(8);
   qahead12 = rmse.(ylist{j})(12);
   table(j,:) = {
      ['\texttt{',latex.replaceSpecChar(ylist{j}),'}'],...
      sprintf('$%.3f$',qahead1),...
      sprintf('$%.3f$',qahead4),...
      sprintf('$%.3f$',qahead8),... 
      sprintf('$%.3f$',qahead12)}; 
end

nl = sprintf('\n');
c = [nl,nl,'\begin{tabular}{lrrrr}\hline',nl,...
   'Parameter & \makebox[4em]{\hfill 1Q Ahead} & \makebox[4em]{\hfill 4Q Ahead} & \makebox[4em]{\hfill 8Q Ahead} & \makebox[4em]{\hfill 12Q Ahead} \\ \hline'];
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

if exist('RMSETable.tex','file')
   delete('RMSETable.tex');
end
char2file(c,'RMSETable.tex');
rehash('path');
