%ȫ�־��
global bar_handler;
global music;

global js;

maxx=0;
global box;
box=zeros(44100*2,1);
%FsΪÿ���������44100
[data, Fs] = audioread('D:\Download\g.m4a');
% ��Ƶ����
total_frame = size(data,1);
% �������ֲ�����
music = audioplayer(data, Fs);
%��ʼ�����
bar_handler = bar(0, 0);
%set(gca,'xscale','log');
% ����Y����ʾ��Χ
ylim([0, 1]);
% ����һ����ʱ����
t = timer('Period', 0.1, 'TimerFcn', {@timer_callback,data,Fs,total_frame},'ExecutionMode','fixedSpacing');
% ������ʱ����ÿ��0.1�����һ֡����
start(t);
% ���в���
play(music);






%��ʱ���ص�����
function timer_callback(obj, eventdata,data,Fs,total_frame)% ǰ������������ʡ�ԣ�������е�һ����������ʱ������
%function timer_callback(data,Fs,total_frame)% ǰ������������ʡ�ԣ�������е�һ����������ʱ������v
    global music;
    global bar_handler;
    
 
    global box;
    Current = music.CurrentSample;
   % display(Current);
    %ȷ��ȡ����Χ
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
    % ����Ƶ���������ϲ�
    data = sum(X, 2);
    L = length(data);
    % ���ٸ���Ҷfft
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
    
  %  ���¾������
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


