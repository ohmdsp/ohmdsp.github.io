---
layout: post-light-feature
title: Intuitive Derivations In DSP
description: "(DRAFT) An intuitive approach to understanding the mathematics of digital signal processing."
category: articles
tags: [engineer, scientist, signal processing, DFT, convolution, fourier transform]
image:
  feature: signals.jpg
  thumb: signals.jpg
published: true
---

The following explanation is from a series of notes I created for a digital signal processing course.

One of the most important concepts in signal processing is that a Linear-Time-Invariant (LTI) system is completely characterised in the time-domain by the output response to a unit impulse input.
\$$ \delta[n] \rightarrow \boxed{LTI} \rightarrow h[n] $$

where $$h[n]$$ is called the "impulse response" of the system. 

Let's imagine that we want to experiment with our LTI system by sending in other kinds of signals (or sequences). An arbitray discrete-time sequence can be represented as a sum of scaled, time-shifted impulses. For example, a short sequence could be
\$$ s[n] = x[1]\delta[n-1] + x[2]\delta[n-2] + x[7]\delta[n-7] $$

where the $$x[n]$$ terms are the repective amplitudes. 

More generally, any arbitraty discrete-time sequence can be expressed as a weighted superpossition of time-shifted pulses
\$$ s[n] = \sum^{\infty}_{k=-\infty}x[k]\delta[n-k] $$

We can experiment by inputting this arbitray sequence into our LTI system and determining the output. If we input a single wighted impulse we get
\$$ x[k]\delta[n-k] \rightarrow \boxed{LTI} \rightarrow x[k]h[n-k] $$

So, when we input the complete arbitray sequence we end up with

\$$ \sum^{\infty}_{k=-\infty}x[k]\delta[n-k] \rightarrow \boxed{LTI} \rightarrow \sum^{\infty}_{k=-\infty}x[k]h[n-k] $$

Let $$k = n-k$$ and rewrite as
\$$ y[n] = \sum^{\infty}_{k=-\infty}x[n-k]h[k] $$

which is the well-known convolution sum. We can now say that if we input a signal into an LTI system, the output is given by the convolution of the input with the system impulse response. 
\$$ x[n] \rightarrow \boxed{LTI} \rightarrow y[n] $$

where convolution can be written shorthand as
\$$ y[n] = x[n] * h[n] $$

This is really cool. All we have done so far is experiment with input signals made up of scaled and delayed unit impulses. What would happen if we used a complex exponential as the input?
\$$ e^{j\omega n} \rightarrow \boxed{LTI} \rightarrow ? $$

Recall again that the output of an LTI system due to an input x[n] is
\$$ x[n] \rightarrow \boxed{LTI} \rightarrow y[n] = \sum^{\infty}_{k=-\infty}x[n-k]h[k]$$

When $$x[n] = e^{j\omega n}$$ the output will be
\$$ y[n] = \sum^{\infty}_{k=-\infty}h[k]e^{j\omega(n-k)} $$

which can be written as 
\$$ y[n] = e^{i\omega n} \sum^{\infty}_{k=-\infty}h[k]e^{-j\omega(k)} $$

Let's denote the summation term as $$H(e^{j\omega})$$. Then we can express our LTI experiment by
\$$  e^{j\omega n} \rightarrow \boxed{LTI} \rightarrow H(e^{j\omega}) e^{i\omega n} $$

Notice that we input a complex exponential and we got out the same complex exponential multiplied by a complex scaling term. The scaling term is called the "frequency response" or "spectrum" and can be written as
\$$ H(e^{j\omega}) = \sum^{\infty}_{k=-\infty}h[k]e^{-j\omega k} $$

When we let k=n this becomes the equation for the Discrete Time Fourier Transform!
\$$ H(e^{j\omega}) = \sum^{\infty}_{n=-\infty}h[n]e^{-j\omega n} $$

Notice that by using a complex exponential as the input to an LTI system, we turned convolution into multiplication. Also, the complex spectrum can be computed for any input signal by
\$$ X(e^{j\omega}) = \sum^{\infty}_{n=-\infty}x[n]e^{-j\omega n} $$ 

In practice, we do not use the DTFT but instead use the DFT. If our signal sample indices are $$ 0 \leq n \leq N-1 $$
\$$ X(e^{j\omega}) = \sum^{N-1}_{n=0}x[n]e^{-j\omega n} $$

Let's uniformly sample the continuous function $$X(e^{j\omega})$$ at N equally spaced frequencys between $$0 \leq k \leq N-1$$, or $$\omega = 2\pi k/N$$ to get
\$$ X[k] = \sum^{N-1}_{n=0}x[n]e^{-j\frac{2\pi kn}{N}} $$

Note, that $$X[k]$$ is complex valued even when $$x[n]$$ is real valued.

Now, let's continue with our experiments. What would happen if we input a more general complex value into our LTI system? Let $$ x[n] = z^{n}$$ where $$z = re^{j\omega n}$$. This is a general complex exponential with a variable amplitude.
\$$  z^{n} \rightarrow \boxed{LTI} \rightarrow \sum^{\infty}_{k=-\infty}h[k]z^{n-k} $$

Notice that the right side output can be simplified to be
\$$  y[n] = z^{n} \sum^{\infty}_{k=-\infty}h[k]z^{-k} $$

Just like the experiment when we put in a complex exponential, we notice that the output again the input multiplied by a complex scale term. We can reqrite this as
 \$$  y[n] = z^{n}H(z) $$

 where $$H(z)$$ is called the "transfer function" of the system. In general, the transfer function of a signal $$x[n]$$ is computed by
 $$ X(z) = \sum^{\infty}_{n=-\infty}x[n]z^{n} $$

 This is called the z-transform! A cool fact is that the z-transform can be used to analyze unstable systems. Also, notice that the z-transform reduces to the DTFT when $$r=1$$. 

 Ok. We have arrived at a few very important DSP tools (e.g., convolution, DTFT, DFT, and z-transform) just by running experiments that look at the output of an LTI system given a few different input signal types. These tools from the foundation of much of signal processing theory. In the next post, we will dive deeper into how to use these tools, and look at the inverse transforms associated with the DTFT and z-transform. 
