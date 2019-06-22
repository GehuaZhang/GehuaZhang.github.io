function [ implied_vol ] = imVol( P,T_days,S0,K,r,type)
%IMVOL Caculate Implied Volatility
%By Gehua Zhang @ Huaxi Securities
%Using Newton Methods for optimization,better than dichotomy
%If stock price is calculated by Dynamics instead of its market price,
%requires more updates(Later).

% P -> Current Price of Options
% T_days -> Days to Maturity
% S0 -> Underlying Asset Price
% K -> Strike Price
% r -> Interest Rate
% type -> "call" or "put"

%% BS model
    function BSPrice = CalculateBS(T_temp,S_temp,K_temp,r_temp,type_temp,sigma_temp)
        d1 = (log(S_temp/K_temp)+(r_temp+0.5*sigma_temp^2)*T_temp)/(sigma_temp*sqrt(T_temp));
        d2 = d1-sigma_temp*sqrt(T_temp);
        if type_temp == "call"
            BSPrice = S_temp*normcdf(d1)-K_temp*normcdf(d2)*exp(-r_temp*T_temp);

        elseif type_temp == "put"
            BSPrice = K_temp*normcdf(-d2)*exp(-r_temp*T_temp)-S_temp*normcdf(-d1);          
        else
            disp("Wrong Type. Please Indicate Call or Put.");
        end
    end
%% BS derivatives
    function bs_market = BSminusMarket(P_temp,T_temp,S0_temp,K_temp,r_temp,type_temp,sigma_temp)
        bs_market = CalculateBS(T_temp,S0_temp,K_temp,r_temp,type_temp,sigma_temp)-P_temp;   
    end
    
    function vega = vegaValue(T_temp,SO_temp,K_temp,r_temp,sigma_temp)
        d1 = (log(SO_temp/K_temp)+(r_temp+0.5*sigma_temp^2)*T_temp)/(sigma_temp*sqrt(T_temp));
        vega = SO_temp * normpdf(d1) * sqrt(T_temp);
    end
%% Newton Method 
    function NewtonValue = NewtonMethod(func, dfunc, x0, tol, nMax)
        n = 1;
        T = T_days/365;
        while n <= nMax
            if dfunc(T,S0,K,r,x0) == 0
                NewtonValue=false;
                return;
            end
            x1 = x0 - func(P,T,S0,K,r,type,x0)/dfunc(T,S0,K,r,x0);
            n=n+1;
            if abs(x0-x1) < tol
                NewtonValue = x1;
                return;
            else
                x0 = x1;
            end
        end
        NewtonValue = false;
        return;
    end
%% Instance to call functions
    func_BSminusMarket = @BSminusMarket;
    func_vegaValue = @vegaValue;
    implied_vol = NewtonMethod(func_BSminusMarket,func_vegaValue,1,0.01,100);
end

