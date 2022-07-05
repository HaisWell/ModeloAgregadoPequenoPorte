function createCalibTable(mstar,Estar)

% elist = fieldnames(Estar);
alist = fieldnames(get(mstar,'parameters'));
clist = alist;
np = numel(clist);
table = {};

for j = 1 : np

   table(j,:) = {
      ['\texttt{',latex.replaceSpecChar(clist{j}),'}'],...
      sprintf('$%.3f$',mstar.(clist{j}))}; 
  
end

nl = sprintf('\n');
c = [nl,nl,'\begin{tabular}{lr}\hline',nl,...
   'Parameter & Value \\ \hline '];

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

if exist('calibTable.tex','file')
   delete('calibTable.tex');
end
char2file(c,'calibTable.tex');

rehash('path'); 
