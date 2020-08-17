---
layout: post-light-feature
title: Deep Learning with Radio Frequency Signals Part I
description: "Some examples of basic techniques for using deep learning to explore Radio Frequency (RF) signals."
category: articles
tags: [RF, deep learning, neural networks, signal processing, inference, machine learning]
image:
  feature: rfml_banner.png
  thumb: rfml.png
published: true
---

__Signal Classification Using Spectrograms and Deep Learning__<br>
In this post, I will introduce some basic methods for utilizing a Convolutional Neural Network (CNN) to process spectrograms created from Radio Frequency (RF) data. The information in the post was taken from tutorial my colleagues and I provided to NVidia Corporation in early 2015 that has been used in their enterprise training series for several years. This post links you to a git project that removes the dependency on Nvidia's DIGITS platform and uses only Keras and Tensorflow.
[Project Code & Data](https://github.com/ohmdsp/mldsd)
<br>

__Introduction to signal detection__<br>
When monitoring radio frequency (RF) signals, or similar signals from sensors such as biomedical, temperature, etc., we are often interested in detecting certain signal “markers” or features. This can become a challenging problem when the signal-of-interest is degraded by noise. Traditional signal detection methods use a range of techniques such as energy detection, matched filtering, or other correlation-based processing techniques. 
<figure>
	<img src="/images/dsd_conf.png" style="width:420px;height:420px;">
	<figcaption>Figure 1. Signal classification confusion matrix.</figcaption>
</figure>
Short-duration radio frequency (RF) events can be especially challenging to detect, since the useful data length is limited and long integration times are not possible. Weak signals that are short in duration are some of the most difficult to reliably detect (or even find). I will walk you through a simple approach using a Convolutional Neural Network (CNN) to tackle the traditional signal processing problem of detecting RF signals in noise.
<br>

__A little background information__<br>
Signal detection theory often assumes that a signal is corupted with additive white Gaussian noise (AWGN). This type of noise is common in the real world and the assumption makes mathematical analysis tractable. The detection of a signal in noise depends on the signal duration, amplitude, and the corresponding noise process. This becomes more difficult if correlated noise, or interfering signals, are also in the same band as the signal you wish to detect.

In this tutorial, we will assume no a-priori information about the parameters for the signal-of-interest. As input to the Convolutional Neural Network, we will utilize spectrograms computed from simulated Radio Frequency (RF) data using a common Fast Fourier Transform (FFT) based method. Taking the input data into the frequency domain as time-frequency grams, which are 2D representations just like images, allows us to visualize the energy of a signal over some pre-determined time duration and frequency bandwidth.

<figure>
	<img src="/images/dsd_2.png" style="width:320px;height:320px;">
	<figcaption>Figure 2. Multiple signals and noise (x-axis is time, y-axis is frequency).</figcaption>
</figure>


__The difficulty with real-world signals__<br>
For a single sinusoid in AWGN, finding the frequency bin with the maximum amplitude is a method for estimating signal frequency in a spectrogram. But real-world signals are often more complex, with frequency components that change with time, and creating a generalized signal detection algorithm becomes difficult. In this tutorial, we will look at one of these types of signals - Linear Frequency-Modulated (LFM) signals. In a follow-on tutorial we will explore Frequency-Hopped (FH) signals and multi-signal detection scenarios.
<br>

__Linear Frequency-Modulated Signals__<br>
A linear frequency-modulated (LFM), or chirp, signal is a signal that ramps up or down in frequency over some time frame. Its frequency changes with time based on its chirp rate. Chirps are used in many different systems for frequency response measurements and timing. RADAR systems use chirp signals due to the inherent large time-bandwith product available with coherent processing. Another common use is for automatic room equalization in home theater receivers, since chirps can excite a large frequency swath quickly. Chirps can also be used as “pilot” signals to denote the start of an incoming transmission, and more. Figure 3 shows a high-SNR chirp as seen in a grayscale spectrogram (the format we will be using). Since the spectrogram consists of real numbers all > 0, we can map it to an image file by scaling the values appropriately. So we only need a single grayscale image channel. In this plot, the x axis is time and the y axis is frequency. Brightness is proportional to signal power.

<figure>
	<img src="/images/dsd_1.png" style="width:320px;height:320px;" > 
	<figcaption>Figure 3. High-SNR chip spectrogram (grayscale).</figcaption>
</figure>


<figure>
	<img src="/images/dsd_3.png" style="width:320px;height:320px;">
	<figcaption>Figure 4. Weak chirp embedded in noise with other signals (x-axis is time, y-axis is frequency).</figcaption>
</figure>


__Give it a try__<br>
You can try using deep learning yourself by following the link to my git page at the top of this post. There you will find a jupiter notebook. Modify the paths to point to the images of your time-frequency grams or reach out to me on LinkedIn and I will send you a dataset to use. When you are done you should have a trained model for classifying/detecting "chirps", "CW", and "Hopped" signal types. You can see a sample of my output results in Figure 5 below. Have fun!

<figure>
	<img src="/images/dsd_4.png" style="width:420px;">
	<figcaption>Figure 5. Example results from signal classifier.</figcaption>
</figure>


