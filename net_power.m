function line =  net_power(e,f ,zhilu)
    [hang lie ] =size(zhilu);
    line=zeros(hang ,10);
    
    line(:,1:3)=zhilu(:,1:3);
    line(:,10) =zhilu(:,lie);
    
    U=e+f*j;
    
    for k=1:hang 
         n = zhilu(k,2);
         m = zhilu(k,3);
         Z = zhilu(k,4)+ j * zhilu(k,5);
         Yl= zhilu(k,6)+ j * zhilu(k,7);
         Yr= zhilu(k,8)+ j * zhilu(k,9);
         bianbi = zhilu(k,10);
         
         if (n==0)
             Un= 0;
         else          
            Un=U(n)/bianbi;
         end
         
         if (m==0) 
             Um=0;
         else
            Um=U(m);
         end
         
         
         Snm= Un*conj( (Un-Um)/Z )  +Un*conj( (Un - 0)*Yl);
         Smn= Um*conj( (Um-Un)/Z )  +Um*conj( (Um-0)  *Yr);
         waste = Snm+Smn;
         
         line(k,4) = real(Snm);
         line(k,5) = imag(Snm);
         line(k,6) = real(Smn);
         line(k,7) = imag(Smn);
         line(k,8) = real(waste);
         line(k,9) = imag(waste);    
         
    end
end

         
        