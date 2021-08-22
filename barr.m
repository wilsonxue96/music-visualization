%全局句柄
global bar_handler;
global music;
global maxx;
global js;
js=0;
maxx=0;
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
ylim([0, 0.8]);
% 创建一个定时器。
t = timer('Period', 0.05, 'TimerFcn', {@timer_callback,data,Fs,total_frame},'ExecutionMode','fixedSpacing');
% 启动定时器，每隔0.1秒调用一帧动画
start(t);
% 进行播放
play(music);






%定时器回调函数
function timer_callback(obj, eventdata,data,Fs,total_frame)% 前两个参数不能省略，必填，其中第一个参数代表定时器本身。
%function timer_callback(data,Fs,total_frame)% 前两个参数不能省略，必填，其中第一个参数代表定时器本身。v
    global music;
    global bar_handler;
    global maxx;
    global js;
    Current = music.CurrentSample;
   % display(Current);
    %确定取样范围
    half_space = floor((0.05)*Fs/2);
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
    X = sum(X, 2);
    L = length(X);
    % 快速傅里叶fft
    %Y = fft(X);
    P1 = pinpuguji(X,L,Fs);
    % 合并，乘以2。
    P2 = 2*P1(1:floor(L/2)+1);
    freq2 = Fs*(0:floor(L/2))/L;
    P2 =ajiquan(P2,freq2);
    P2 = P2(freq2>20&freq2<2000);
    freq2 = freq2(freq2>20&freq2<2000);
% P2=shuzhouyingshe(P2,L);
% freq2=shuzhouyingshe(freq2,length(freq2));
    %分为32份
    nbins =32;
    % 每一份的宽度
    window = floor(length(freq2)/nbins);
   % freq2=log2(freq2);
    % 平滑数据
    P3 = smooth(P2, window);   
    P4 = P3(1:window:end);
    maxgengxin(max(P4));
    display(js);
    P4=P4/maxx;
    freq3 = freq2(1:window:end);
  %  更新句柄属性
    set(bar_handler, 'XData',freq3 , 'YData',P4);
end





function Y=pinpuguji(X,nfft,Fs)
cxn=xcorr(X,'unbiased'); %计算序列的自相关函数
CXk=fft(cxn,nfft);
psd2=abs(CXk);
psd2 = psd2 / max(psd2);
%Y=-0.025*log10(psd2+0.000001);
Y=psd2/max(psd2);

end





function sc=shuzhouyingshe(Y,L)
js1=0;
js2=1;
sc=zeros(1,1);
while(2^js2<=L)
    cs=Y(2^js1:2^js2);
    meann=mean(cs);
    sc(js2,1)=meann;
    js1=js1+1;
    js2=js2+1;
    
end   
js1=js1-1;
js2=js2-1;
sc(js2,1)=mean(Y(2^js1:L));

end


function A=ajiquan(Y,freq2)

SampleRate=length(Y);
A= zeros(1,SampleRate);
for i=1:SampleRate;
    f=freq2(i)^2;
    A(i)=Y(i)*((1.2588966*(148693636*f^2)/((f+424.3600)*((f+1.1599e+04)*(f+5.4450e+05))^(1/2)*(f+148693636))));
end
end


function maxgengxin(ma)
    global js;
    global maxx;
    if ma>maxx
        maxx=ma;
    end
    js=js+1;
    
    if js==40    
     
        js=0;
        maxx=0;
    end
end
    
