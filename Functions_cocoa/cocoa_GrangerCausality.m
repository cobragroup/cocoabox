function [G] = cocoa_GrangerCausality(X)
%cocoa_GrangerCausality - Granger causality matrix of given data.
% Syntax:
%   [G] = cocoa_GrangerCausality(X);
%
% Example: 
%   timeSeries = rand(1000,10);
%   [G] = cocoa_GrangerCausality(X);
%
% Inputs:
%   X: time series, size(X)=[n,T] n=dimension T=sample
% 
% Outputs:
%   G: Granger causality
%
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
% MAT-files required: 

[n,time]=size(X);
                 for i=1:1:time-1 %lagged temp matrix
                   Xtmp1(:,i)=X(:,i+1);
                   Xtmp2(:,i)=X(:,i);
                 end
              

                               XX=Xtmp2; 
                               %First modelfit
                for j=1:1:n %fit Xt=aXt-1+bYt-1+c+eps2
                    for k=1:1:n
                        XX=Xtmp2; 
                        XX(k,:)=ones(1,time-1);
                        abc1=[transpose(XX)] \ transpose(Xtmp1(j,:));
                    
                
                     for i=1:1:time-1
                        eps1(j,k,i)=Xtmp1(j,i);
                        
                        for o=1:1:n
                              eps1(j,k,i)=  eps1(j,k,i)- abc1(o)*XX(o,i);
                            
                        end
                        
                 
                     end
                    vareps1(j,k)=var(eps1(j,k,:));
                 end
                 
                end
                
                %second modelfit
                for j=1:1:n %fit Xt=aXt-1+bYt-1+c+eps2
                    
                        abc2=[transpose(Xtmp2),ones(time-1,1)] \ transpose(Xtmp1(j,:));
                    
                
                     for i=1:1:time-1
                        eps2(j,i)=Xtmp1(j,i);
                        
                        for o=1:1:n
                              eps2(j,i)=  eps2(j,i)- abc2(o)*Xtmp2(o,i);
                            
                        end
                        eps2(j,i)=eps2(j,i)-abc2(n+1);
                 
                     end
                    vareps2(j)=var(eps2(j,:));
                 end
                 
                 
                 
                 %Granger causality coefficient
                for j=1:1:n
                        for k=1:1:n
                 G(j,k)=log(vareps1(j,k)/vareps2(j));
                        end
                end
            
                
end