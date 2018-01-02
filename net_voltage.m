function [e,f,totalcircle_num]  = net_voltage (Yzheng,voltage)

    MAX_CIRCLE=20;
    accuracy=0.00000001;
    
    
    
    [Yzheng voltage] = PointTaxis(Yzheng, voltage);       
    
    
    pqNum = PQNum(voltage);
    
    p=SimulationP(voltage);                  %p=Pg-Pl
    q=SimulationQ(voltage);
    u_2= SimulationU_2 (voltage);
    %---------------------
    e = voltage(:,2);
    f = voltage(:,3);
    %----------------------
    circle_num=0;
    while (true)
        JJ=YGBJZ(Yzheng,e,f,pqNum);                              %雅可比矩阵                  
        dp=PowerDifference(Yzheng,e,f,pqNum,p,q,u_2);            
        
        dfde = JJ^(-1)*dp;
        
        if (max(abs(dfde) ) < accuracy)
            break;
        end
        
        [de,df ] =Seperatefde(dfde);
        e=e+de;
        f=f+df;
        circle_num = circle_num+1;
        if (circle_num>=MAX_CIRCLE)
            totalcircle_num = 'max circle times';
            break ;
        else 
            totalcircle_num = circle_num;
        end    
        
    end
    [Yzheng voltage e f] = PointRecoverTaxis(Yzheng,voltage,e,f);
end

function y= ExchangeRows(x,i,j)               %换行
    [hang lie]= size(x);
    
    tmp = x(i,:);
    x( i , : )=x(j,:);
    x(j , :) =tmp; 
    y=x;
end

function y= ExchangeCols(x,i,j)              %换列
    [hang lie]= size(x);
    
    tmp = x(:,i);
    x( :, i )=x(: , j);
    x(: , j) =tmp;   
    y=x;
end

function  [ y  v] = PointTaxis   (Yzheng, voltage)               %排序，pq,pv,平衡节点 第一行和每一行比，最后一个不用比了
    [ hang lie ] = size(voltage);
    
    for i = 1 : hang-1
        for j = i+1 : hang
            if (voltage(i,lie) <voltage(j , lie)) 
                voltage = ExchangeRows(voltage,i,j);
               Yzheng = ExchangeRows(Yzheng,i,j);
               Yzheng = ExchangeCols(Yzheng,i,j);
            end
        end
    end
    y=Yzheng;
    v=voltage;
    
end

function  pqNum= PQNum(voltage)

    [ hang lie] =size(voltage);
    pqNum = sum(voltage(:,lie)) +1; 

end
function p=SimulationP(voltage)
    
    p = voltage(:,4)-voltage(:,6);
end

function q=SimulationQ(voltage)
    
    q = voltage(:,5) -  voltage(:,7);
end
function u_2= SimulationU_2 (voltage)
    u_2 = voltage(:,2 ).^2 + voltage(:,3).^2 ;
end
function JJ = YGBJZ(Yzheng,e,f,pqNum)
    
    [ hang0 lie0 ] = size(Yzheng);
    
    hang = (hang0-1)*2;
    lie = hang;
    
    JJ= zeros(hang ,lie);
    
    for  i= 1:hang 
        for j = 1:lie
            JJ(i,j) = YGBZ(i,j,Yzheng,e,f,pqNum);
        end
    end
end
 %求雅可比矩阵
function y=  YGBZ(i,j,Yzheng,e,f,pqNum)                  
 
    mi=round(i/2.0+0.25);                 %四舍五入取整
    mj=round(j/2.0+0.25);
    dao = real(Yzheng);
    na  = imag(Yzheng);
    
    if (mi<=pqNum)
        if ( mi ==i/2 & mj ==j/2)             %22 44 66
            y= L(mi,mj,dao ,na ,e,f);
        elseif (mi==i/2 )                     %2X 4X 6X...
            y= J(mi,mj,dao ,na ,e,f);
        elseif(mj ==j/2)                      %X2 X4 X6...
            y= N(mi,mj,dao ,na ,e,f);
        else                                  %奇数 奇数
            y= H(mi,mj,dao ,na ,e,f);
        end
    else 
        if ( mi ==i/2 & mj ==j/2)
            y= S(mi,mj,dao ,na ,e,f);
        elseif (mi==i/2 )
            y= R(mi,mj,dao ,na ,e,f);
        elseif(mj ==j/2)
            y= N(mi,mj,dao ,na ,e,f);
        else
            y= H(mi,mj,dao ,na ,e,f);
        end
    end
end

function y= H(i,j,dao,na,e,f)
    y=0;
    if (i~= j)
        y=  -na(i,j)*e(i,1) +dao(i,j)*f(i,1);
    else 
        aii=0;
        bii=0;
        [hang lie]= size(e);
        for k = 1 :hang
            aii = aii + dao(i,k)*e(k,1)-na(i,k)*f(k,1);
            bii = bii + dao(i,k)*f(k,1)+na(i,k)*e(k,1);
        end
        y= -na(i,i)*e(i,1)+dao(i,i)*f(i,1) + bii;
    end
end

function y= N(i,j,dao,na,e,f)
    y=0;
    if (i~= j)
        y=  dao(i,j)*e(i,1)+ na(i,j)*f(i,1);
    else 
        aii=0;
        bii=0;
        [hang lie]= size(e);
        for k = 1 :hang
            aii = aii + dao(i,k)*e(k,1)-na(i,k)*f(k,1);
            bii = bii + dao(i,k)*f(k,1)+na(i,k)*e(k,1);
        end
        y= dao(i,i)*e(i,1) + na(i,i)*f(i,1)+aii;
    end
end
function y= J(i,j,dao,na,e,f)
    y=0;
    if (i~= j)
        y= -na(i,j)*f(i,1)- dao(i,j)*e(i,1);
    else 
        aii=0;
        bii=0;
        [hang lie]= size(e);
        for k = 1 :hang
            aii = aii + dao(i,k)*e(k,1)-na(i,k)*f(k,1);
            bii = bii + dao(i,k)*f(k,1)+na(i,k)*e(k,1);
        end
        y= -na(i,i)* f(i,1) - dao(i,i)*e(i,1)+aii;
    end
end
function y= L(i,j,dao,na,e,f)
    y=0;
    if (i~= j)
        y= -na(i,j)*e(i,1)+ dao(i,j)*f(i,1);
    else 
        aii=0;
        bii=0;
        [hang lie]= size(e);
        for k = 1 :hang
            aii = aii + dao(i,k)*e(k,1)-na(i,k)*f(k,1);
            bii = bii + dao(i,k)*f(k,1)+na(i,k)*e(k,1);
        end
        y= -na(i,i)*e(i,1)+dao(i,i)*f(i,1)-bii;
    end
end
function y= R(i,j,dao,na,e,f)
    y=0;
    if (i~= j)
        y=0 ;
    else 
        y= 2*f(i,1);
    end
end
function y= S(i,j,dao,na,e,f)
    y=0;
    if (i~= j)
        y=0 ;
    else 
        y= 2*e(i,1);
    end
end

function  dp=PowerDifference(Yzheng,e,f,pq,p,q,u_2)

    dao  = real(Yzheng);
    na   = imag(Yzheng);
    [hang0 lie0]=size(Yzheng);
    hang = (hang0-1)*2;   
    
    dp =zeros(hang,1);
    for i = 1:hang
        dp(i,1) = DifferenceValue(i,dao,na,e,f,pq,p,q,u_2);
    end
end

    

function y= DifferenceValue(i,dao,na,e,f,pq,p,q,u_2)

    mi=round(i/2.0+0.25);
    if mi<=pq
        if (mi == i/2)
            y= Dq(mi,q,dao,na ,e,f);
        else
            y= Dp(mi,p,dao,na ,e,f);        
        
        end
    else
        if (mi == i/2)
            y= Du_2(mi,u_2,e,f);
        else
            y= Dp(mi,p,dao,na ,e,f);     
        
        end
        
    end
end
   
function y= Dp(i,p,dao,na ,e,f)
    value = 0;
    [hang lie] = size(dao);
    
    for  j= 1:hang
        value = value +e(i,1)*(  dao(i,j)*e(j,1) -na(i,j)*f(j,1) )+ f(i,1) *( dao(i,j)*f(j,1) + na(i,j)*e(j,1) );
    end
    y= p(i,1)-value;
end

function y= Dq(mi,q,dao,na ,e,f)

    i=mi;
    value =0;
    [hang lie ] = size(dao);
    
    for j = 1:hang
        value = value + f(i,1)*( dao(i,j)*e(j,1)- na(i,j)*f(j,1) ) -e(i,1)*( dao(i,j)*f(j,1) +na(i,j)*e(j,1) );
    end
    y = q(i,1)-value;
    
end

function y= Du_2(mi,u_2,e,f)
    y= u_2(mi) - ( e(mi).^2 +f(mi).^2 );
end


function [de df]=Seperatefde(dfde)

    [hang0 lie0] =size(dfde);
    hang = hang0/2+1;
    
    de = zeros(hang,1);
    df = zeros(hang,1);
    
    de(1:hang-1,1) = dfde(2:2:end,1);
    df(1:hang-1,1) = dfde(1:2:end,1);
    
end

function [y v eo  fo] = PointRecoverTaxis(Yzheng,voltage,e,f)
    [hang lie] = size(voltage);
    for i = 1 :hang -1
        for j = i +1 :hang 
            if (voltage(i,1) >voltage(j,1) )
                voltage= ExchangeRows(voltage ,i,j);
                Yzheng = ExchangeRows(Yzheng , i ,j);
                Yzheng = ExchangeCols(Yzheng , i ,j);
                e      = ExchangeRows(e,i,j);
                f      = ExchangeRows(f,i,j);
            end
        end
    end
    y=Yzheng;
    v=voltage;
    eo=e;
    fo=f;
end


        
    



    
    
    
    
    

        
        
        
    
    

    




    