---
layout: post-light-feature
title: Complex Envelope
description: "Mathematically Describing Narrowband Signals"
category: articles
tags: [engineer, signal processing, signals, fourier transform, dsp]
image:
  feature: envelope.jpg
  thumb: envelope.jpg
published: true
---

There are two common methods in the literature for mathematically describing
narrowband signals. Both of these methods will be encountered in the popular signal processing, digital communications,
and radar signal processing books. <br>
 
__First approach:__ <br>  

Let's start with a simple real-valued sinusoidal signal with a time-dependent amplitude and phase. This can be expressed by 

\$$ x_{c}(t) = a(t)cos(2\pi f_{0} t + \theta(t) ) .$$ 

We can rewrite this expression using Eulers Formula to be

\$$ 
\begin{equation}
\begin{aligned}
x_{c}(t) &= \Re \left\{ a(t) \exp(j [2\pi f_{0} t + \theta(t)])  \right\} \\
& = \Re \left\{ a(t) \exp(j 2\pi f_{0} t) \exp(j \theta(t))  \right\}  .
\end{aligned}
\end{equation}
$$

Let's simplify this a little by splitting out the amplitude and phase components and assigning it to

\$$ 
\begin{equation}
\begin{aligned}
\tilde{x}_{c}(t) &= a(t) \exp(j \theta(t)) .
\end{aligned}
\end{equation}
$$

Then, we can rewrite our expression for $$ x_{c}(t) $$ as

\$$ 
\begin{equation}
\begin{aligned}
x_{c}(t) &= \Re \left\{ \tilde{x}_{c}(t) \exp(j 2\pi f_{0} t)  \right\} .
\end{aligned}
\end{equation}
$$

Note that $$\tilde{x}_{c}(t)$$ contains both the amplitude and phase information for $$x_{c}(t)$$, and is
referred to as the "complex envelope" of $$x_{c}(t)$$. <br>

__Second approach:__ <br>

The second appraoch for describing our signal start with expanding our original expression using a trigonametric identity. This give us

\$$ 
\begin{equation}
\begin{aligned}
x_{c}(t) &= a(t)cos(2\pi f_{0}t + \theta(t) ) \\
& =  a(t)cos(2\pi f_{0}t)cos(\theta(t)) - a(t)sin(2\pi f_{0}t)sin(\theta(t)) .
\end{aligned}
\end{equation}
$$

Again, we will simplify using some assignments for the amplitude and phase components. 

\$$ 
\begin{equation}
\begin{aligned}
x_{ci}(t) &= a(t)cos(\theta(t))\\
x_{cq}(t) &= a(t)sin(\theta(t)) .
\end{aligned}
\end{equation}
$$

These are called the "in-phase" and "qaudrature" components of the signal, respectively. A final expression for our signal is then found to be

\$$ 
\begin{equation}
\begin{aligned}
x_{c}(t) &=  x_{ci}(t)cos(2\pi f_{0}t) - x_{cq}(t)sin(2\pi f_{0}t).
\end{aligned}
\end{equation}
$$

__Summary:__ <br>

Clearly, the represenations from the first and second approaches are related by 

\$$ 
\begin{equation}
\begin{aligned}
\tilde{x}_{c}(t) &= x_{ci}(t) + j x_{cq}(t)
\end{aligned}
\end{equation}
$$

The in-phase and quadrature components are, respectfully, the real and imaginary parts of the complex envelope $$\tilde{x}_{c}(t)$$.

