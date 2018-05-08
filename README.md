# PHM
PHM:Prognostic and Health Management
_____
## 1、写在前面
    关于剩余使用寿命预测方法技术研究

## 2、语言
    MATLAB

## 3、文件列表
文件名 | 简要说明|
--------- |---------|
score_barPlot.m |SCORE值和误差分布直方图|
saxena_metrics.m |算法性能度量函数|

## 4、文件详细说明
* score_barPlot.m ：根据PHM08竞赛求预测结果评估指标SCORE值；绘制所有测试点的误差分布直方图。
* saxena_metrics.m : <br>
    求三个指标值：**Prediction Horizon、Rate of Acceptable Predictions 和 Relative accuracy**
    同时**绘制Prognostic Horizon图 和 alpha-lamda Accuracy图**。
        > 根据Abhinav Saxena于2009年论文《Evaluating algorithm performance metrics tailored for prognostics》<br>
        结合T Wang的论文《Trajectory Similarity Based Prediction for Remaining Useful Life Estimation》中的实例；<br>
        
