%��ʱ���ص�����
function timer_callback(obj, eventdata,data,Fs,total_frame)% ǰ������������ʡ�ԣ�������е�һ����������ʱ������
%function timer_callback(data,Fs,total_frame)% ǰ������������ʡ�ԣ�������е�һ����������ʱ������v
    global music;
    global bar_handler;
    Current = music.CurrentSample;
   % display(Current);
    %ȷ��ȡ����Χ
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
    % ����Ƶ���������ϲ�
    X = sum(X, 2);
    L = length(X);
    % ���ٸ���Ҷfft
    Y = fft(X);
    P1 = abs(Y/L);
    % �ϲ�������2��
    P2 = 2*P1(1:floor(L/2)+1);
    freq2 = Fs*(0:floor(L/2))/L;
    P2 = P2(freq2>20&freq2<2000);
    freq2 = freq2(freq2>20&freq2<2000);
    % ��Ϊ32��
    nbins = 32;
    % ÿһ�ݵĿ��
    window = floor(length(freq2)/nbins);
    % ƽ������
    P3 = smooth(P2, window);   
    P4 = P3(1:window:end);
    freq3 = freq2(1:window:end);
    %���¾������
    set(bar_handler, 'XData',freq3 , 'YData',P4);
end








