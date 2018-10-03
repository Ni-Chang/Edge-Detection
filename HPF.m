clear;
clc;
%��ȡͼ�񣬲�ת��Ϊ�Ҷ�ͼ��
RGB = imread('lenna.jpg');
GRAY = rgb2gray(RGB); 
subplot(3,3,1),imshow(GRAY);
title('Original Image');

%���Ҷ�ͼ����и���Ҷ�任 �任����Ƶ�ʳɷ��Ƶ�Ƶ�׵����� ��ȡͼƬ���ĵ�
fourier=fftshift(fft2(GRAY));
subplot(3,3,2),imshow(log(1+abs(fourier)),[]);
title('FFT2');
[M,N]=size(fourier);
m=floor(M/2);
n=floor(N/2);

%IHPF�˲�
D0=20;
filter_ideal = ones(M, N);
for i=1:M
    for j=1:N
        d = sqrt((i-m)^2+(j-n)^2);
        if d<=D0
            filter_ideal(i,j) = 0;
        end     
    end
end
subplot(3,3,4),imshow(filter_ideal, []);
title('IHPF filter');
fourier_Iremoved=fourier.*filter_ideal;
subplot(3,3,5),imshow(log(1+abs(fourier_Iremoved)),[]);
title('IHPF result');  

%��ͼƬ���ж�ά����ɢ��Fourier�任
iff_I=ifftshift(fourier_Iremoved);
iff_I=uint8(real(ifft2(iff_I)));  
subplot(3,3,6),imshow(iff_I);
title(['BHPF Edge D0=',num2str(D0)]);

%BHPF �˲�
filter_Butterworth = zeros(M, N);
for i=1:M
    for j=1:N
        d=sqrt((i-m)^2+(j-n)^2);
        if(d==0)
            filter_Butterworth(i, j) = 0;
        else
            filter_Butterworth(i, j) = 1/(1+(D0/d));
        end
    end
end
subplot(3,3,7),imshow(filter_Butterworth,[]);
title('BHPF filter');
fourier_Bremoved=fourier.*filter_Butterworth;
subplot(3,3,8),imshow(log(1+abs(fourier_Bremoved)),[]);
title('BHPF result'); 

%��ͼƬ���ж�ά����ɢ��Fourier�任
iff_B=ifftshift(fourier_Bremoved);
iff_B=uint8(real(ifft2(iff_B)));  
subplot(3,3,9),imshow(iff_B);
title(['BHPF Edge D0=',num2str(D0)]);
