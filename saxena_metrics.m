function [PH,AP,RA,CG] = saxena_metrics(x_real,y_real,...
                            x_estimation,y_estimation,...
                            EoL,tp,delta,alpha,lamda,beta)
% 根据论文
%【2010-Metrics for Offline Evaluation of Prognostic Performance】
%【2010ID7-Trajectory Similarity Based Prediction for Remaining Useful Life Estimation 】
% Prognosis指标：PH、alpha-lamda、RA
%参数说明
% Input:
%       x_real,y_real,x_estimation,y_estimation均为列向量
%       alpha,beta,lamda 属于[0,1]间的标量
%       EoL：单元最终失效时间
%       tp：预测开始时间
%       delta:设定的预测点之间的时间间隔
%
% Output:
%       PH: Prediction Horizon
%       AP: Rate of Acceptable Predictions
%       RA：Relative accuracy
%       CG: Convergence
%使用说明：
%       使用前需要调整参数即本文件中的para

%% 判断输入是否规范
if numel(x_real)~=numel(y_real)
    error('x_real and y_real are in different sizes.');
end
if numel(x_estimation)~=numel(y_estimation)
    error('x_estimation and y_estimation are in different sizes.');
end
if nargin<8
    alpha = 0.2;
    beta = 0.8;
    lamda = 0.5;
end
if nargin<9
    beta = 0.8;
    lamda = 0.5;
end
if nargin<10
    beta = 0.8;
end
%% 参数手动设置
% 例如EoL-EoUP =10;delta = 10;因此y_real需要加2
para =1;
%% 计算PH值
tH = tp;
tH_index =1;
PH = EoL - tp;
for i = 1:length(x_estimation)   
    if y_estimation(i)>y_real(i+para )+alpha*EoL || y_estimation(i)<y_real(i+para )-alpha*EoL
        PH = EoL - tp - delta*(i-1);
        tH = tp + delta*(i-1+1);
        tH_index = i+1;
    end
end
%% Plot:Prognostic Horizon
figure;
plot(x_real,y_real,'b-','LineWidth',2)
ylim([0 EoL+alpha*EoL])
hold on
plot(x_estimation,y_estimation,'ro','LineWidth',1)
legend(['RUL实际值'],['RUL估计值'])
plot(x_real,y_real+alpha*EoL,'b--',x_real,y_real-alpha*EoL,'b--')
title('Prognostic Horizon')
xlabel('cycle');
ylabel('RUL');
grid on
% 绘制PH所在的线
ylim1 = get(gca,'Ylim'); %获取当前图像的纵轴范围
plot([tH,tH],ylim1,'k--','LineWidth',2)
hold off   
%% 计算AP的值 [tH EoUP]
AP_NUM = 0;
for i = tH_index:length(x_estimation)
    if y_estimation(i)<=y_real(i+para)*(1+alpha) && y_estimation(i)>=y_real(i+para)*(1-alpha)
        AP_NUM = AP_NUM + 1;
    end
end
AP = AP_NUM/(length(x_estimation)-tH_index+1);
%% Plot: alpha-lamda Accuracy
t_landa = tp + delta * (round(lamda*length(x_estimation))-1);   % 测试点为基数时，需要减一
figure;
plot(x_real,y_real,'k-','LineWidth',2)
hold on
plot(x_estimation,y_estimation,'ro','LineWidth',1)
legend(['RUL实际值'],['RUL估计值'])
plot(x_real,y_real*(1+alpha),'b--',x_real,y_real*(1-alpha),'b--')   %改为t_lamda的RUL值
title('alpha-lamda Accuracy')
xlabel('cycle');
ylabel('RUL');
grid on
% 绘制t_lamda所在的线
ylim1 = get(gca,'Ylim'); %获取当前图像的纵轴范围
plot([t_landa,t_landa],ylim1,'k--','LineWidth',2)
hold off   
%% 计算RA值 [tH EoUP]
temp1 = y_estimation(tH_index:length(x_estimation));
temp2 = y_real(tH_index+para:length(x_estimation)+para);
RA = 1 - mean(abs((temp1-temp2)./temp2));
% temp1 = y_estimation;
% temp2 = y_real(1+para:length(x_estimation)+para);
% RA = 1 - mean(abs((temp1-temp2)./temp2));

%% plot收敛图 以每个点的相对精度为RA为纵坐标
% figure;
% hold on
% temp3 = (y_estimation-y_real(1+para:end-para))./y_real(1+para:end-para);
% plot(x_estimation,abs(temp3),'k-')
% hold off

end

