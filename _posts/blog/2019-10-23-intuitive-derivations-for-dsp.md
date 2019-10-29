---
layout: post-light-feature
title: Intuitive Derivations In DSP
description: "Discovering the transforms for digital signal processing."
category: articles
tags: [engineer, scientist, signal processing, DFT, convolution, fourier transform]
image:
  feature: signals.jpg
  thumb: signals.jpg
published: true
---

One of the most important concepts in digital signal processing is that a Linear-Time-Invariant (LTI) system is completely characterized in the time-domain by the output response to a unit impulse input. This can be imagined as probing the input of an LTI system with a Kronecker delta function and then determining the resulting output. 
\$$ \delta[n] \rightarrow \boxed{LTI} \rightarrow h[n] $$

In this simple diagram, the output function $$h[n]$$ is called the "impulse response" of the system. 

Let's imagine that we want to experiment with our LTI system by sending in other kinds of discrete-time sequences (i.e. signals). For example, a short sequence could be
\$$ s[n] = x[1]\delta[n-1] + x[2]\delta[n-2] + x[7]\delta[n-7] $$

where the $$x[k]$$ terms are the amplitudes of each time-delayed unit impulse. 

More generally, any arbitrary discrete-time sequence can be expressed as a weighted superposition of time-shifted unit impulses, or
\$$ s[n] = \sum^{\infty}_{k=-\infty}x[k]\delta[n-k] $$

We can continue our experiment by sending this arbitrary sequence into our LTI system and then determining the output based on the rules we know about LTI systems. For example, if we input a single scaled and time-delayed impulse, we would get a scaled  and time-delayed unit impulse response at the output
\$$ x[k]\delta[n-k] \rightarrow \boxed{LTI} \rightarrow x[k]h[n-k] $$

Using the same rules, when we input the full arbitrary sequence, we end up with
\$$ \sum^{\infty}_{k=-\infty}x[k]\delta[n-k] \rightarrow \boxed{LTI} \rightarrow y[n] $$

where the output can be expressed by
\$$ y[n]=\sum^{\infty}_{k=-\infty}x[k]h[n-k]$$

Letting $$k = n-k$$ and rewriting this output, gives us
\$$ y[n] = \sum^{\infty}_{k=-\infty}x[n-k]h[k] $$

which is the well-known convolution sum! Our experiment has shown us that if we input any arbitrary signal into an LTI system, the output will be the convolution of the input signal with the system impulse response, or 
\$$ x[n] \rightarrow \boxed{LTI} \rightarrow y[n] = x[n] * h[n] $$

where $$ x[n] * h[n] $$ is a shorthand way of expressing the convolution operation.

This is certainly a very interesting result considering all we have done so far is experiment with input signals made up of scaled and delayed unit impulses. What would happen if we used a different input? How about using a complex exponential as the input?
\$$ x[n] = e^{j\omega n}$$

Recall again that the output of an LTI system due to an input $$x[n]$$ is just the convolution of the input and the system impulse response, or
\$$ x[n] \rightarrow \boxed{LTI} \rightarrow y[n] = \sum^{\infty}_{k=-\infty}x[n-k]h[k]$$

When $$x[n] = e^{j\omega n}$$ the output will be
\$$ y[n] = \sum^{\infty}_{k=-\infty}h[k]e^{j\omega(n-k)} $$

which can be rearranged to look like 
\$$ y[n] = e^{i\omega n} \sum^{\infty}_{k=-\infty}h[k]e^{-j\omega(k)} $$

Let's write the summation term as a function $$H(e^{j\omega})$$. Then we can rewrite the output like this
\$$  e^{j\omega n} \rightarrow \boxed{LTI} \rightarrow H(e^{j\omega}) e^{i\omega n} $$

Now, take a minute to notice that although we input a complex exponential to our LTI system, we got out the same complex exponential multiplied by a complex scaling term! The scaling term is called the "frequency response" or "spectrum" and it can be written as
\$$ H(e^{j\omega}) = \sum^{\infty}_{k=-\infty}h[k]e^{-j\omega k} $$

When we let k=n this becomes the equation for the Discrete-Time-Fourier-Transform, which is an important theoretical tool for understanding digital signal processing. We can write the DTFT as
\$$ H(e^{j\omega}) = \sum^{\infty}_{n=-\infty}h[n]e^{-j\omega n} $$

Another thing to notice is that by using a complex exponential as the input to an LTI system, we turned convolution into multiplication. The complex spectrum can be computed for any signal by
\$$ X(e^{j\omega}) = \sum^{\infty}_{n=-\infty}x[n]e^{-j\omega n} $$ 

In practical computer applications, we do not use the DTFT (which has a continuous output) but instead use the DFT (which has a discrete output). For example, if we make our signal sample indices to be $$ 0 \leq n \leq N-1 $$ and uniformly sample the continuous output $$X(e^{j\omega})$$ at N equally spaced index point (or frequencies) between $$0 \leq k \leq N-1$$, then $$\omega = 2\pi k/N$$ and to get an expression for the DFT as
\$$ X[k] = \sum^{N-1}_{n=0}x[n]e^{-j\frac{2\pi kn}{N}} $$

Keep in mind that $$X[k]$$ is complex valued even when $$x[n]$$ is real valued.

Now, let's continue with our experiments and figure out what would happen if we input a more general complex value into our LTI system? Let $$ x[n] = z^{n}$$ where $$z = re^{j\omega n}$$. This is a general complex exponential with a variable amplitude. Again, we exploit our knowledge of LTI systems and convolution to arrive at
\$$  z^{n} \rightarrow \boxed{LTI} \rightarrow \sum^{\infty}_{k=-\infty}h[k]z^{n-k} $$

Again, the right side output can be simplified to be
\$$  y[n] = z^{n} \sum^{\infty}_{k=-\infty}h[k]z^{-k} $$

Just like the previous experiment when we put in a complex exponential, we can see that the output is the input multiplied by a complex scaling term. We can express the output as
\$$  y[n] = z^{n}H(z) $$

where $$H(z)$$ is called the "transfer function" of the system. In general, the transfer function of a any signal $$x[n]$$ is computed by
\$$ X(z) = \sum^{\infty}_{n=-\infty}x[n]z^{n} $$

This is called the z-transform! A cool fact is that the z-transform can be used to analyze unstable systems. Also, notice that the z-transform reduces to the DTFT when $$r=1$$. 

Ok. We have arrived at a few very important DSP mathematical tools (e.g., convolution, DTFT, DFT, and z-transform) just by running experiments that look at the output of an LTI system given different input signal types. These powerful mathematical tools form the foundation of digital signal processing theory. In a future post, I will dive deeper into how these tools can be used, and I will introduce the inverse transforms associated with the DTFT, DFT and z-transform. 
