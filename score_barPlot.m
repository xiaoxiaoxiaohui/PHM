function [table_final,score] = score_barPlot(y_real,y_estimation)
% 统计分数score
% 绘制误差分布直方图
% Para:
%    输入均为列向量；

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  绘制误差分布直方图  %%%%%%%%%%%%%%%%%%%%%%%%%%%
error = y_estimation - y_real;
table_final = table(y_real,y_estimation,error,100*error./y_real,...
     'VariableNames',{'real','estimation','error','relative_error'});
figure;
[errorNum,xaxis] = hist(error,[-60:10:60]); 
bar(xaxis,errorNum)
for i = 1:length(xaxis)
    text(xaxis(i),errorNum(i),num2str(errorNum(i),'%g'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
xlabel('误差值');
ylabel('数量');
title('RUL误差分布直方图');
grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% PHM08竞赛 SCORE统计  %%%%%%%%%%%%%%%%%%%%%%%%%%%
score=0;
for i=1:length(error)
    if (error(i)<0)
        score = score + exp(-error(i)/13)-1;
    else
        score = score + exp(error(i)/10)-1;
    end
end
disp('最终得分')
score 

end

