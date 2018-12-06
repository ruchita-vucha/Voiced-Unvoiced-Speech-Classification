clear, clc, close all

    [S,fs] = audioread('arctic_a0001.wav');%change the name of the file before running(FROM CMU ARCTIC DATABASE)
    S=resample(S,8000,fs);
    s=S(:,1);
    fs=8000;
    N=length(s);
   %  N-1th difference is replicated as Nth difference  
   
    x=diff(s);
    x(end+1)=x(end);
    


    %applying zero frequency filtering to the speech sample
    b=1;
    a=[1,-2,1];
    y1=filter(b,a,x);
    y2=filter(b,a,y1);
    
   
    %taking mean window
    M=5*fs/1000;
    
    %subtracting out the mean to extract the characteristics of
    %discontinuities i.e removing trend
    y3=y2;
    for k=1:3
        tt=filter(ones(M,1),1,y3)/M;
        y3=y3-tt;
        y3=y3/5;
    end
    %%%%%%%%%%%%%% SECOND METHOD BASED ON HILBERT ENVELOPE OF LP RESIDUAL       
    
    %     getting lp residual and taking hilbert transform of that
    lpc_1=lpc(s,10);
    residual=filter(lpc_1,1,s);
    s_a=hilbert(residual);
    s_he=abs(s_a);
    
    %applying zff to Hilbert Envelope
    y1_he=filter(b,a,s_he);
    y2_he=filter(b,a,y1_he);

    
    
    %subtracting out the mean to extract the characteristics of
    %discontinuities i.e removing trend from HE
    y3_he=y2_he;
    for k=1:4
        tt=filter(ones(M,1),1,y3_he)/M;
        y3_he=y3_he-tt;
    end
    
    %figure;
    t1=(0:N-1)/fs;
    subplot(4,1,1)
    plot(t1,s)
    title('speech signal')
   %figure;
    subplot(4,1,2)
    plot(t1,y3)
    title('zero frequency filtered signal after trend removal')
    % figure;
    subplot(4,1,4)
    plot(t1,y3_he)
    title('ZFF of Hilbert Envelope')
    
   
   %figure;
    subplot(4,1,3)
    plot(t1,s_he)
    title('Hilbert envelope of lp residual')
