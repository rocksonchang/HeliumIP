function [FitRes,FitResErr] = IP_FIT2DGauss(x_data, y_data, z_data, startPoint,const)
%CREATEFIT(x_data,y_data,TEST)
%  Create a fit for a 2D Gaussian:
%  'C1+(a1*exp(-(x-x0)^2/(2*sigmax^2)-(y-y0)^2/(2*sigmay^2)))'
%   
%
%
%  Data for 'untitled fit 1' fit:
%      X Input : x_data
%      Y Input : y_data
%      Z Output: test
%       Fit start points: 
%         C1: Background
%         A1
%         sigmax = Width in x
%         sigmay = Width in y
%         x0 = x center
%         y0 = y center
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 16-Sep-2013 10:28:22


%% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( x_data, y_data, z_data );

% Set up fittype and options.
ft = fittype( 'C1+(a1*exp(-(x-x0)^2/(2*sigmax^2)-(y-y0)^2/(2*sigmay^2)))', 'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 0 -Inf -Inf];
% opts.StartPoint = [C1_start A1_start sigmax_start sigmay_start x0_start y0_start];
% C1_start, A1_start, sigmax_start, sigmay_start,x0_start,y0_start
opts.StartPoint=startPoint;
opts.Upper = [Inf Inf Inf Inf Inf Inf];

%% exclude
if const(3)>0
    xc=const(1); yc=const(2); dc=const(3);
    % outliers=~excludedata(xData,yData,'box',[115 132 115 132]);
    outliers=~excludedata(xData,yData,'box',[xc-dc xc+dc yc-dc yc+dc]);
    opts.Exclude = outliers;
end;


% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
[FitRes] = coeffvalues(fitresult);

% goodness of fit
%[FitDet] = coeffvalues(gof);
FitResConf=confint(fitresult);
FitResErr=FitResConf(2,:)-FitResConf(1,:);

% Plot fit with data.
% figure( 'Name', 'Fit' );
% h = plot( fitresult, [xData, yData], zData);
%            
% legend( h, 'Fit', 'data vs. x_data, y_data', 'Location', 'NorthEast' );
% % Label axes
% xlabel( 'x_data' );
% ylabel( 'y_data' );
% zlabel( 'test' );
% grid on
% view( -20, 20 );


