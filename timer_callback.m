%定时器回调函数
function timer_callback(obj, eventdata,data,Fs,total_frame)% 前两个参数不能省略，必填，其中第一个参数代表定时器本身。
%function timer_callback(data,Fs,total_frame)% 前两个参数不能省略，必填，其中第一个参数代表定时器本身。v
    global music;
    global bar_handler;
    Current = music.CurrentSample;
   % display(Current);
    %确定取样范围
    half_space = floor(0.1*Fs/2);
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
    Y = fft(X);
    P1 = abs(Y/L);
    % 合并，乘以2。
    P2 = 2*P1(1:floor(L/2)+1);
    freq2 = Fs*(0:floor(L/2))/L;
    P2 = P2(freq2>20&freq2<2000);
    freq2 = freq2(freq2>20&freq2<2000);
    % 分为32份
    nbins = 32;
    % 每一份的宽度
    window = floor(length(freq2)/nbins);
    % 平滑数据
    P3 = smooth(P2, window);   
    P4 = P3(1:window:end);
    freq3 = freq2(1:window:end);
    %更新句柄属性
    set(bar_handler, 'XData',freq3 , 'YData',P4);
end








