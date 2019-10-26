---
layout: post-light-feature
title: Time-Frequency Analysis of Non-Stationary Signals
#description: "How to compute a time-frequency representation of a non-stationary signal for analysis."
category: articles
tags: [signal processing, DSP, FFT, signal analysis, machine learning, Fourier Transform ]
image:
  feature: bat_tf.png
  thumb: bat_tf.png
published: true
---

Check out the [Matlab demo code](https://github.com/ohmdsp/TF-Bat-Signal-Analysis) to explore time-frequency analysis using a Bat signal...not the super-hero one ;)
<br>
Often, the examples provided in our signal processing textbooks assume that the signal we are working with is wide-sense-stationary. This means that the first and second order statistics (mean and correlation) do not change with shifts in time. Akthough, all of our statistical signal processing techniques depend upon this statistical behavior in order to produce meaningful characterizations when analyzing a random signal, many real-world signals don't have nonstationary characteristics. A bat echo-location signal is just one example. 
<br><br>
How can we use statistical signal processing techniques to analyze time-changing statistical behavior? We must first determine what is the longest time interval $$N$$ over which we can assume that the data is approximately stationary, and then step through the random signal (with or without data overlap) using small analysis intervals never exceeding $$N$$. This is done to accurately capture the quasi-stationary statistical characteristics for each analysis interval. The changing statistical behavior may then be tracked by creating a stacked plot of the statistics estimated each analysis interval. This plot is called a time-vs-frequency spectrogram (Note: other types of time-vs-feature grams are also possible, but not discussed here).

### Frequency-Domain Analysis
If the autocorrelation sequence (ACS) for a signal is stationary, then the Fourier transform of the ACS (the power spectral density, or PSD) is also stationary. A way to visualize this is to look at the shape of the plotted PSD or the ACS. If the signal is stationary, these plotted shapes should not change over time. If time varying content is observed, then the random signal has nonstationary statistical behavior. We could experimentally vary the analysis interval duration $$N$$ until differences in successive PSD estimates are observed, indicating the threshold between quasi-stationary and nonstationary statistical behavior. 
<br><br>
Using bat echo-location data, an experimental determination was made that $$ N = 38 $$ samples was the threshold between quasi-stationary and stationary statistical behavior. The time-vs-frequency gram created by using a sample spectrum (magnitude of FFT) for each analysis intervals of 38 samples, with 37 sample overlap (i.e., only one sample shift), is shown in the figure below. Notice the four separate signal components being generated simultaneously by the bat during echo-location.

<figure>
	<img src="/images/bat_TFR.png">
	<figcaption>TF analysis of a bat echo-location signal.</figcaption>
</figure>

The bat data has an approximately linear time-vs-frequency trajectory in the TF analysis gram that makes it possible to calulate an approximation for the longest time interval in which the bat signal can be considered to be quasi-stationary. The Fourier transform of a windowed data segment of duration $$ NT $$ seconds (where $$ N $$ is the number of data points and $$ T $$ is the sampling interval) produces a frequency domain spectrum mainlobe response which is roughly $$ 1/NT $$ Hz in 3dB bandwidth. Therfore, a criterion for having a roughly stationary statistical behavior is that any change in frequency content be less than $$ 1/NT $$ Hz over an analysis interval, as this is not resolvable. If this can be made true, the signal is considered to be quasi-stationary over the analysis interval of $$ N $$ samples. From examining the bat spectrogram, we can see there is an approximately linear change of frequency vs time from 50 KHz at 0.65ms to 32 KHz at 1.8 ms. The slope in this region is $$ s=(50-32)/(1.8-0.65)=15.65 $$ KHz/ms. Thus, if $$ NT $$ is expressed in ms, the change in frequency is $$ sNT $$ KHz. We want this to be less than the mainlobe response bandwidth. So, the threshold between quasi-stationary and nonstationary conditions is approximately $$ sNT = 1/NT $$. Since the bat data was sampled at $$ T = 7 $$ microseconds, solving for $$ N^2=1/sT^2 $$ yields $$ N = 36.1 $$ samples, which compares well with our experimentally determined value of $$ N=38 $$.

Try some of these parameter changes to explore what happens:
 * Change the FTT size (example - 64 samples, or 2048 samples)
 * Change the analysis interval duration (example - 8 samples or 256 samples)
 * Change the overlap sample size (example -  make same as analysis inteval duration, try $$1/2$$ that size)
 * Make notes on what changes while you experiment
<br>
### Resources
* Don't forget to download the code and bat signal data so you can try for yourself - [Code & Bat Data](https://github.com/ohmdsp/TF-Bat-Signal-Analysis)


*Thanks to Dr. Larry Marple Jr. for the introduction to time-frequency analysis back when I was in graduate school. You should check out his book on [Spectral Analysis](https://www.amazon.com/Digital-Spectral-Analysis-Electrical-Engineering/dp/048678052X)*
