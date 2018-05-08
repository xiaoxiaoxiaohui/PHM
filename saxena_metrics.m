function [PH,AP,RA,CG] = saxena_metrics(x_real,y_real,...
                            x_estimation,y_estimation,...
                            EoL,tp,delta,alpha,lamda,beta)
% ��������
%��2010-Metrics for Offline Evaluation of Prognostic Performance��
%��2010ID7-Trajectory Similarity Based Prediction for Remaining Useful Life Estimation ��
% Prognosisָ�꣺PH��alpha-lamda��RA
%����˵��
% Input:
%       x_real,y_real,x_estimation,y_estimation��Ϊ������
%       alpha,beta,lamda ����[0,1]��ı���
%       EoL����Ԫ����ʧЧʱ��
%       tp��Ԥ�⿪ʼʱ��
%       delta:�趨��Ԥ���֮���ʱ����
%
% Output:
%       PH: Prediction Horizon
%       AP: Rate of Acceptable Predictions
%       RA��Relative accuracy
%       CG: Convergence
%ʹ��˵����
%       ʹ��ǰ��Ҫ�������������ļ��е�para

%% �ж������Ƿ�淶
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
%% �����ֶ�����
% ����EoL-EoUP =10;delta = 10;���y_real��Ҫ��2
para =1;
%% ����PHֵ
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
legend(['RULʵ��ֵ'],['RUL����ֵ'])
plot(x_real,y_real+alpha*EoL,'b--',x_real,y_real-alpha*EoL,'b--')
title('Prognostic Horizon')
xlabel('cycle');
ylabel('RUL');
grid on
% ����PH���ڵ���
ylim1 = get(gca,'Ylim'); %��ȡ��ǰͼ������᷶Χ
plot([tH,tH],ylim1,'k--','LineWidth',2)
hold off   
%% ����AP��ֵ [tH EoUP]
AP_NUM = 0;
for i = tH_index:length(x_estimation)
    if y_estimation(i)<=y_real(i+para)*(1+alpha) && y_estimation(i)>=y_real(i+para)*(1-alpha)
        AP_NUM = AP_NUM + 1;
    end
end
AP = AP_NUM/(length(x_estimation)-tH_index+1);
%% Plot: alpha-lamda Accuracy
t_landa = tp + delta * (round(lamda*length(x_estimation))-1);   % ���Ե�Ϊ����ʱ����Ҫ��һ
figure;
plot(x_real,y_real,'k-','LineWidth',2)
hold on
plot(x_estimation,y_estimation,'ro','LineWidth',1)
legend(['RULʵ��ֵ'],['RUL����ֵ'])
plot(x_real,y_real*(1+alpha),'b--',x_real,y_real*(1-alpha),'b--')   %��Ϊt_lamda��RULֵ
title('alpha-lamda Accuracy')
xlabel('cycle');
ylabel('RUL');
grid on
% ����t_lamda���ڵ���
ylim1 = get(gca,'Ylim'); %��ȡ��ǰͼ������᷶Χ
plot([t_landa,t_landa],ylim1,'k--','LineWidth',2)
hold off   
%% ����RAֵ [tH EoUP]
temp1 = y_estimation(tH_index:length(x_estimation));
temp2 = y_real(tH_index+para:length(x_estimation)+para);
RA = 1 - mean(abs((temp1-temp2)./temp2));
% temp1 = y_estimation;
% temp2 = y_real(1+para:length(x_estimation)+para);
% RA = 1 - mean(abs((temp1-temp2)./temp2));

%% plot����ͼ ��ÿ�������Ծ���ΪRAΪ������
% figure;
% hold on
% temp3 = (y_estimation-y_real(1+para:end-para))./y_real(1+para:end-para);
% plot(x_estimation,abs(temp3),'k-')
% hold off

end

