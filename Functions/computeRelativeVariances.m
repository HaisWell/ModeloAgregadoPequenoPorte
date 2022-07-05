function [Rgap, Rpot] = computeRelativeVariances(f,starthist,endhist)
%Assumes LGDP, Y and LGDP_BAR exist in the input structure f

Vgdp = nan([20,1]);
Vgap = nan([20,1]);
Vpot = nan([20,1]);
for j = 1 : 20
   x1 = f.LGDP - f.LGDP{-j};
   x2 = f.Y - f.Y{-j};
   x3 = f.LGDP_BAR - f.LGDP_BAR{-j};
   Vgdp(j) = mynanvar(x1(starthist:endhist));
   Vgap(j) = mynanvar(x2(starthist:endhist));
   Vpot(j) = mynanvar(x3(starthist:endhist));
end
Rgap = tseries(1:20,Vgap./Vgdp);
Rpot = tseries(1:20,Vpot./Vgdp);
