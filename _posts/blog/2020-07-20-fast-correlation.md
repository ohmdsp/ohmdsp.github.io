---
layout: post-light-feature
title: Fast Correlation
description: "An efficient way to implement correlation for very long input data sequences."
category: articles
tags: [engineer, correlation, signal processing, FFT, convolution, fourier transform]
image:
  feature: signals.jpg
  thumb: fast_corr_thumb.jpg
published: true
---
There are two methods for computing the correlation of complex-valued signals.  The first one is a time-domain method, and for a stationary process can be computed using the following formula

$$
r_{xh}(k) =
\begin{cases}
  \frac{1}{N} \sum^{N-k-1}_{n=0} x(n+k)h^{*}(n) & 0 \leq k \leq N-1 \\
  r^{*}_{xh}(-k) & -(N-1) \leq k \lt 0\\
  0 & elsewhere\\
\end{cases} 
$$ 

where N is the input data record length, x(n) is the input data and h(n) is the kernel, or reference data.  The computational time to compute a correlation using this method is directly proportional to the number of samples in the kernel. Therefore, the longer the kernel data record the more time it takes to compute a correlation.

The second method for computing a correlation is a frequency domain method called “fast correlation”. Fast correlation uses the Fast Fourier Transform (FFT) to transform the input signal and the kernel signal into the frequency domain and then exploits the following mathematical relationship
\$$ x(n) \circledast h(n) = ifft \{X(k)*conj(Y(k))\} $$

It is well known that when dealing with kernel lengths that are greater than about 60 samples it is faster, or more efficient, to use the fast correlation method.  To the fact that the time it takes to compute the fast correlation is proportional to the logarithm of the number of samples, and therefore, changes slowly as the kernel length increases.  Figure 1 shows a computation time comparison between the time-domain and fast correlation methods versus kernel length, or “impulse response length”.

<figure>
	<img src="/images/fastcorr_eff.png">
	<figcaption>Figuer 1. Execution times for fast correlation compared to time-domain correlation [Steven W. Smith,DSP Guide].</figcaption>
</figure>

It is often useful to look at a pictorial representation of an algorithm.  A block diagram showing the processing steps involved in computing the fast correlation is shown in Figure 2. It is worth mentioning that fast correlation is also called “pulse compression” in the radar community.  Therefore, it should be no surprise to learn that many commercially available technologies, both hardware and software, are available to implement it.  

<figure>
	<img src="/images/fastcorr_block.png">
	<figcaption>Figuer 2. Block diagram showing the processing steps for computing frequency-domain correlation.</figcaption>
</figure>

The most efficient way to implement fast correlation for very long input data sequences is to use the overlap “scrap” (OVS) algorithm, also known as the overlap-save algorithm. The overlap-save algorithm can be easily understood by looking at the sample sequences x and h in Figure 3. First, the input data sequence is broken up into arbitrary segments of length N. Then, each segment is processed using the fast correlation method discussed in the last section. However, special segment overlapping and data discarding rules must be by followed in order to avoid wrap-around pollution in the output sequence. We will not go into an analysis of wrap-around pollution in this report since most DSP textbooks cover it in detail. The OVS algorithm can be implemented by following these steps:

1. Zero pad the kernel out to the FFT length (N) to avoid wrap-around pollution
2. Add M-1 zeros to the beginning of the input data and N-1 zeros to the end
3. Break input signal into successive segments of N samples, each segment overlapping the previous segment by M-1 samples
4. Compute the FFT of the kernel and complex conjugate (save for reuse)
5. Buffer a segment of input signal and compute the FFT
6. Multiply (element- wise) outputs from steps 4 and 5
7. Compute the inverse FFT (IFFT) from output of multiply
8. Last M-1 samples of each IFFT output are discarded, (front M-1 samples discarded from first output block)
9. The remaining samples are used as output
10. Steps 5-9 are repeated until all input segments used


<figure>
	<img src="/images/corr_example.png">
	<figcaption>Simple Overlap "Scrap" algorithm example.</figcaption>
</figure>

<figure>
	<img src="/images/corr_matlab_plot.png">
	<figcaption>Plots from simple example.</figcaption>
</figure>

It is important to note that the last M-1 samples of each IFFT output should be discarded instead of the front M-1 samples. This will help in the implementation by avoiding double buffering at the output of the IFFT. Matlab code for simulating the OVS correlation algorithm is included below.

Usually we would consider the following factors when deciding the overlap amount for the OVS algorithm.
1. FFT Accuracy – the numerical accuracy of fast correlation is dependent on the error introduced by the FFT and IFFT process. For floating point implementations this is usually negligible, but for fixed point processing, significant dynamic range can be lost when using larger transforms.
2. Latency – the fast correlation process extends the group delay by at least N samples. So, the longer the FFT, the longer the latency.
In the absence of a benchmark, an overlap factor of 4 to 8 is a good rule of thumb. Since we do not have a lot of flexibility when choosing a kernel size, we will need to choose the length of the FFT to give optimal performance.


Matlab Code

% Filename: overlap_scrap_corr.m <br>
% Author: drohm <br>
% <br>
% y = output sequence <br>
% x = input sequence <br>
% h = kernel sequence <br>
% N = segment length & fft length <br>
% Implements overlap-scrap (OVS) "overlap-save" correlation. <br>
%========================================================================== %========================================================================== 
clear all;close all <br>
x1 = [zeros(1,128)+j*zeros(1,128)];   %Input Data <br>
h1 = [ 1 0 1 1 0 1];                  %Kernel<br>
Lenx = length(x1); M = length(h1); <br>
x1(25:25+M-1)=h1;                     %Embed Kernel into nput data<br>

xp = [x1 zeros(1,length(h1)-1)];      %Zero Padded input sequence and Kernel<br>
hp = [h1 zeros(1,length(x1)-1)];<br>

N=8; % Segment Size and FFT Size for OVS <br>
M1 = M-1; L = N-M1;<br>
h = [h1 zeros(1,N-M)];<br>
Leny = Lenx + M -1; %Length of final correlation output <br>

x = [zeros(1,M-1), x1, zeros(1,N-1)];
K = floor((Lenx+M1-1)/(L)); % # of segment sent to correlator<br>
Y = zeros(K+1,N); % Allocate output 2D array of zeros<br>

%%%%% Correlator %%%%%<br>
% These steps perform the correlation using the FFT<br>
for k=0:K <br>
  xk = x(k*(N-(M-1))+1:k*(N-(M-1))+N); % Input segments<br>
  Y(k+1,:) = ifft( (fft(xk,N).*conj(fft(h,N))),N ); % FFT Correlation<br>
end<br>
Y = Y(:,1:N-(M-1))'; %discard the last (M-1) samples<br>
y = (Y(:))'; % assemble output into 1D array<br>
y = (real(y(M-1:Leny))); %remove extra zeros at end<br>

%%%%% Plotting %%%%%<br>
figure(1)<br>
subplot(4,1,1)<br>
stem(x1);title('Input Data');ylim([0,2])<br>
subplot(4,1,2)<br>
stem(h1);title('Kernel Data');ylim([0,2])<br>
subplot(4,1,3)<br>
stem(y);title('Output (OVS)');ylim([0,5])<br>