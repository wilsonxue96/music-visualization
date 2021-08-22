%全局句柄
global bar_handler;
global music;
%Fs为每秒采样点数44100
[data, Fs] = audioread('D:\Download\a.m4a');
% 音频长度
total_frame = size(data,1);
% 更新音乐播放器
music = audioplayer(data, Fs);
%初始化句柄
bar_handler = bar(0, 0);
% 限制Y轴显示范围
ylim([0, 0.5]);
% 创建一个定时器。
t = timer('Period', 0.1, 'TimerFcn', {@timer_callback,data,Fs,total_frame},'ExecutionMode','fixedSpacing');
% 启动定时器，每隔0.1秒调用一帧动画
start(t);
% 进行播放
play(music);






