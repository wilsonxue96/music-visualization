%全局句柄
global bar_handler;
global music;

global js;

maxx=0;
global box;
box=zeros(44100*2,1);
%Fs为每秒采样点数44100
[data, Fs] = audioread('D:\Download\g.m4a');
% 音频长度
total_frame = size(data,1);
% 更新音乐播放器
music = audioplayer(data, Fs);
%初始化句柄
bar_handler = bar(0, 0);
%set(gca,'xscale','log');
% 限制Y轴显示范围
ylim([0, 1]);
% 创建一个定时器。
t = timer('Period', 0.1, 'TimerFcn', {@timer_callback,data,Fs,total_frame},'ExecutionMode','fixedSpacing');
% 启动定时器，每隔0.1秒调用一帧动画
start(t);
% 进行播放
play(music);






%定时器回调函数
function timer_callback(obj, eventdata,data,Fs,total_frame)% 前两个参数不能省略，必填，其中第一个参数代表定时器本身。
%function timer_callback(data,Fs,total_frame)% 前两个参数不能省略，必填，其中第一个参数代表定时器本身。v
    global music;
    global bar_handler;
    
 
    global box;
    Current = music.CurrentSample;
   % display(Current);
    %确定取样范围
    half_space = floor((0.1)*Fs/2);
    left = Current - half_space;
    if left<1
       left = 1;
    end
    right = Current + half_space;
    if right>total_frame
       right = total_frame;
    end
    X = data(left:right,:);
    % 将音频左右声道合并
    data = sum(X, 2);
    L = length(data);
    % 快速傅里叶fft
    %Y = fft(X);
    a=floor(0.01*length(data));
blo = fir1(a-1,0.007,gausswin(a),'stop');
datafir=filter(blo,1,data);
datafir=smooth(datafir);
datafir=abs(hilbert(datafir));
%datafir=datafir/max(datafir);
datafir=smoothdata(datafir,'gaussian',500);
databox(datafir);
datafir=datafir/max(box);
    
  %  更新句柄属性
  if max(datafir)>=0.65
    set(bar_handler, 'XData',1 , 'YData',max(datafir));
  end
  if max(datafir)<0.65
      set(bar_handler, 'XData',1 , 'YData',0.3);
  end
end
    
function databox(data)
    global box;
    box(1:length(box)-length(data))=box(length(data)+1:length(box));
    box(length(box)-length(data)+1:length(box))=data;
end


