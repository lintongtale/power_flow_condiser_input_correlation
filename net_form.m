function y = net_form(zhilu,jiedian)
    [hang lie ]= size (jiedian);
    jiedianshu = hang;
    
    Yzheng = zeros(hang,hang);
    %------------------------   
    
    [hang2 lie2 ]= size (zhilu);
    
    new_zhilu = zeros(hang2 , 7);
    
    new_zhilu(:,1:3) =zhilu(:,1:3);
    new_zhilu(:,4)  = zhilu(:,4)+ zhilu(:,5)*j;
    new_zhilu(:,5)  = zhilu(:,6)+ zhilu(:,7)*j;
    new_zhilu(:,6)  = zhilu(:,8)+ zhilu(:,9)*j;
    new_zhilu(:,7)  = zhilu(:,10);
    
    new_zhilu(:,4)  = 1./new_zhilu(:,4);
   %---------------------------    
    
    
    for i = 1:hang2
        
        num_i = new_zhilu(i,2);
        num_j = new_zhilu(i,3);
        YT=new_zhilu(i,4);
        YL=new_zhilu(i,5);
        YR=new_zhilu(i,6);
        K =new_zhilu(i,7);
        
        if (num_i==0 || num_j ==0)
            if ( num_j == 0 )
                Yzheng(num_i,num_i) = Yzheng(num_i,num_i) + YT/K/K +YL/K/K;
            else
                Yzheng(num_j,num_j) = Yzheng(num_j,num_j) + YT/K/K +YL/K/K;
            end
        else 
            Yzheng(num_i,num_i) = Yzheng(num_i,num_i) + YT/K/K +YL/K/K;
            Yzheng(num_j,num_j) = Yzheng(num_j,num_j) + YT+ YR;
            Yzheng(num_i,num_j) = Yzheng(num_i,num_j) - YT/K;
            Yzheng(num_j,num_i) = Yzheng(num_j,num_i) - YT/K;
        end
    end
    y=Yzheng;
end
    
    
            
        
        
                
                
        
            
        
    
    
    
    
    
    
    