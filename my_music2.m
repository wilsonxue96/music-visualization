%ȫ�־��
global bar_handler;
global music;
%FsΪÿ���������44100
[data, Fs] = audioread('D:\Download\a.m4a');
% ��Ƶ����
total_frame = size(data,1);
% �������ֲ�����
music = audioplayer(data, Fs);
%��ʼ�����
bar_handler = bar(0, 0);
% ����Y����ʾ��Χ
ylim([0, 0.5]);
% ����һ����ʱ����
t = timer('Period', 0.1, 'TimerFcn', {@timer_callback,data,Fs,total_frame},'ExecutionMode','fixedSpacing');
% ������ʱ����ÿ��0.1�����һ֡����
start(t);
% ���в���
play(music);






