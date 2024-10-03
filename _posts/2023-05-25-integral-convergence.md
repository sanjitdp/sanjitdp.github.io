---
layout: note
title: Convergence of indefinite integrals
date: 2023-05-25
author: Sanjit Dandapanthula
---

- TOC
{:toc}

Here are a few examples where I figure out when an indefinite integral converges. There are only really a few tricks that get used over and over again (Abel's criterion, contour integration, repeated application of l'Hôpital's rule, etc.), so I figured it would be nice to collect some of these tricks in this post. These examples are both integrals I worked with last year when I was learning real analysis from Rudin.

## Example #1

We will show that $\int_0^\infty \frac{\sin(x)}{\sqrt{x}}\ dx$ is convergent but not absolutely convergent.

### Convergence analysis

First, we know that $x \mapsto \frac{\sin(x)}{\sqrt{x}}$ is continuous on $(0, \infty)$ and is therefore integrable on the interval $(0, 1)$. Furthermore, we know that:

$$
\begin{align*}
    \int_0^\infty \frac{\sin(x)}{\sqrt{x}}\ dx = \int_0^1 \frac{\sin(x)}{\sqrt{x}}\ dx + \int_1^\infty \frac{\sin(x)}{\sqrt{x}}\ dx.
\end{align*}
$$

The first integral is just a constant (since it's a definite integral), so we'll focus on the second integral. Notice that $x \mapsto \frac{1}{\sqrt{x}}$ is decreasing on $[1, \infty)$ because its derivative $-\frac{1}{2x^{3/2}}$ is negative on this interval by the power rule. Furthermore, we know that $\left\lvert \int_1^M \sin(x)\ dx \right\rvert = \lvert -\cos(M) + \cos(1) \rvert \leq 2$ is bounded so the integral $\int_1^\infty \frac{\sin(x)}{\sqrt{x}}\ dx$ converges by Abel's criterion. This means that the integral $\int_0^\infty \frac{\sin(x)}{\sqrt{x}}\ dx$ is convergent.

Next, we'll show that $\int_0^\infty \frac{\sin(x)}{\sqrt{x}}\ dx$ is not absolutely convergent. We split the integral into easier parts as follows:

$$
\begin{align*}
    \int_0^\infty \frac{\lvert \sin(x) \rvert}{\sqrt{x}}\ dx
    = \sum_{n=0}^\infty \int_{2\pi n}^{2\pi (n+1)} \frac{\lvert \sin(x) \rvert}{\sqrt{x}}\ dx
\end{align*}
$$

Because we know that $\sqrt{x} \leq \sqrt{2\pi (n+1)}$ on $[2\pi n, 2\pi (n+1)]$, we find:

$$
\begin{align*}
    \sum_{n=0}^\infty \int_{2\pi n}^{2\pi (n+1)} \frac{\lvert \sin(x) \rvert}{\sqrt{x}}\ dx
     & \geq \sum_{n=0}^\infty \frac{1}{\sqrt{2\pi (n+1)}} \int_{2\pi n}^{2\pi (n+1)} \lvert \sin(x) \rvert\ dx \\
     & = \sum_{n=0}^\infty \frac{1}{\sqrt{2\pi (n+1)}} \left( \int_{2\pi n}^{2\pi n + \pi} \sin(x) \ dx
    - \int_{2\pi n + \pi}^{2\pi (n+1)} \sin(x) \ dx \right)                                                    \\
     & = \frac{4}{\sqrt{2\pi}} \sum_{n=0}^\infty \frac{1}{\sqrt{n+1}}                                          \\
     & = \frac{4}{\sqrt{2\pi}} \sum_{n=1}^\infty \frac{1}{\sqrt{n}}.
\end{align*}
$$

However, this sum is divergent by the $p$-series test (or by comparison to the harmonic series), so we deduce that the original integral $\int_0^\infty \frac{\lvert \sin(x) \rvert}{\sqrt{x}}\ dx$ is divergent. Hence $\int_0^\infty \frac{\sin(x)}{\sqrt{x}}\ dx$ is convergent but not absolutely convergent, which is what we wanted to show.

### Explicit computation

In fact, now that we know it converges, let's compute $\int_0^\infty \frac{\sin(x)}{\sqrt{x}}$ using contour integration (I guess this will be good review for me). In particular, we're going to integrate $f(z) = \frac{e^{iz}}{\sqrt{z}}$ around the quarter-circle of radius $R$ in the first quadrant of $\mathbb{C}$. To be explicit, the curve we're integrating around is the composition of the following three curves:

$$
\begin{cases}
    \gamma_1(t) = t & \quad t \in [0, R], \\
    \gamma_2(t) = R e^{it} & \quad t \in \left[ 0, \frac{\pi}{2} \right], \\
    \gamma_3(t) = (R - t) i & \quad t \in [0, R].
\end{cases}
$$

By Cauchy's residue theorem (since $f$ is holomorphic on the interior of the curve):

$$
\int_0^R \frac{e^{it}}{\sqrt{t}}\ dt + \int_0^{\frac{\pi}{2}} \frac{e^{i Re^{it}}}{\sqrt{R e^{it}}} \cdot i R e^{it}\ dt + \int_0^R \frac{-i e^{t - R}}{\sqrt{(R - t) i}}\ dt
= 0.
$$

The first integral is the one we want to understand. The second integral goes to zero as $R \to \infty$, since $\sin(x) \geq \frac{2x}{\pi}$:

$$
\begin{align*}
    \left\lvert \int_0^{\frac{\pi}{2}} \frac{e^{i Re^{it}}}{\sqrt{R e^{it}}} \cdot i R e^{it}\ dt \right\rvert
    & \leq \int_0^{\frac{\pi}{2}} \left\lvert \frac{e^{i Re^{it}}}{\sqrt{R e^{it}}} \cdot i R e^{it} \right\rvert\ dt \\
    & = \sqrt{R} \int_0^{\frac{\pi}{2}} e^{-R \sin(t)}\ dt \\
    & \leq \sqrt{R} \int_0^{\frac{\pi}{2}} e^{-\frac{2R t}{\pi}}\ dt \\
    & = \frac{\pi - \pi e^{-R}}{2 \sqrt{R}}.
\end{align*}
$$

This clearly goes to zero as $R \to \infty$. On the other hand, we simplify (substituting $u = t - R$):

$$
\begin{align*}
    \int_0^R \frac{-i e^{t - R}}{\sqrt{(R - t) i}}\ dt
    = \int_0^R \frac{-i e^u}{\sqrt{-iu}}\ du
    = -\frac{1}{\sqrt{i}} \int_0^R \frac{e^u}{\sqrt{u}}\ du
    = -\sqrt{i} \int_0^R \frac{e^u}{\sqrt{u}}\ du
    = -\sqrt{i} \int_0^R \frac{e^u}{\sqrt{u}}\ du.
\end{align*}
$$

Taking $R \to \infty$, we find that:

$$
\int_0^\infty \frac{e^{it}}{\sqrt{t}}\ dt = \sqrt{i} \int_0^\infty \frac{e^u}{\sqrt{u}}\ du = \left( \frac{1 + i}{\sqrt{2}} \right) \cdot \Gamma\left( \frac{1}{2} \right).
$$

It's well known that $\Gamma\left( \frac{1}{2} \right) = \sqrt{\pi}$ by substituting $t = u^2$ and evaluating the resulting Gaussian integral.

> The [Gaussian integral](https://en.wikipedia.org/wiki/Gaussian_integral) $\int_{-\infty}^\infty e^{-u^2}\ du$ can be evaluated using either polar coordinates or by [Feynman's trick](https://web.williams.edu/Mathematics/lg5/Feynman.pdf) (differentiating under the integral sign).

Therefore, we have:

$$
\int_0^\infty \frac{e^{it}}{\sqrt{t}}\ dt = (1 + i) \sqrt{\frac{\pi}{2}}.
$$

Equating the imaginary parts, we've solved our integral:

$$
\int_0^\infty \frac{\sin(t)}{\sqrt{t}}\ dt = \sqrt{\frac{\pi}{2}}.
$$

Contour integrals are cool.

## Example #2

Let's analyze the convergence of $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ for different values of $a \in \mathbb{R}$ and $b \in \mathbb{R}$.

First, we will show that $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ converges whenever $a > 1$. Notice that if $b \geq 0$ then the result is clear because $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx \leq \int_2^\infty \frac{1}{x^a}\ dx$ which converges. Therefore, suppose $b < 0$. Integrating by parts using $u = \frac{1}{\ln(x)^b}$ and $dv = \frac{1}{x^a}$, we find:

$$
\begin{align*}
    \int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx
    = \left[ \frac{1}{1-a} \cdot \frac{1}{x^{a-1} \ln(x)^b} \right]_{x=2}^{x \to \infty} + \frac{b}{1-a} \int_2^\infty \frac{1}{x^a \ln(x)^{b+1}}\ dx.
\end{align*}
$$

We know that evaluating the left-hand term at $x = 2$ will yield a finite value and we also have that if $b \geq 0$ then because $a > 0$ we would have $\lim_{x \to \infty} \frac{1}{x^{a-1} \ln(x)^b} = 0$. On the other hand, if $b < 0$ we have by l'Hôpital's rule that:

$$
\begin{align*}
    \lim_{x \to \infty} \frac{\ln(x)^{-b}}{x^{a-1}}
    = -\frac{b}{a-1} \lim_{x \to \infty} \frac{1}{x^{a-1} \ln(x)^{1+b}}.
\end{align*}
$$

We can repeatedly apply l'Hôpital's rule to the denominator until the exponent of $\ln(x)$ is positive and we still find that $\lim_{x \to \infty} \frac{1}{x^{a-1} \ln(x)^b} = 0$. Therefore, the original integral $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ converges if $\int_2^\infty \frac{1}{x^a \ln(x)^{b+1}}\ dx$ converges. We can repeat this process until the exponent on $\ln(x)$ in the denominator is positive and we find that $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ still converges.

Next, we will show that $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ diverges whenever $a < 1$. Notice that if $b \leq 0$ then the result is clear because $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx \geq \int_2^\infty \frac{1}{x^a}\ dx$ which diverges to $+\infty$. Therefore, suppose $b > 0$. We know that, substituting $u = \ln(x) \implies du = \frac{dx}{x}$:

$$
\begin{align*}
    \int \frac{1}{u^b}\ du = \frac{u^{1-b}}{1-b} = \frac{\ln(x)^{1-b}}{1-b}.
\end{align*}
$$

Integrating by parts using $u = \frac{1}{x^{a-1}}$ and $dv = \frac{1}{x \ln(x)^b}$, we find:

$$
\begin{align*}
    \int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx
    = \left[ \frac{1}{1-b} \cdot \frac{1}{x^{a-1} \ln(x)^{b-1}} \right]_{x=2}^{x \to \infty} - \frac{1-a}{1-b} \int_2^\infty \frac{1}{x^a \ln(x)^{b-1}}\ dx.
\end{align*}
$$

We know that evaluating the left-hand term at $x = 2$ will yield a finite value and we also have that if $b \leq 1$ then because $a < 0$ we would have $\lim_{x \to \infty} \frac{1}{x^{a-1} \ln(x)^{b-1}}$ diverges to $+\infty$. On the other hand, if $b > 1$ we have by l'Hôpital's rule that:

$$
\begin{align*}
    \lim_{x \to \infty} \frac{x^{1-a}}{\ln(x)^{b-1}}
    = \frac{1-a}{b-1} \lim_{x \to \infty} \frac{x^{1-a}}{\ln(x)^{b-2}}.
\end{align*}
$$

We can repeatedly apply l'Hôpital's rule to the denominator until the exponent of $\ln(x)$ is less than 1 and we still find that $\lim_{x \to \infty} \frac{1}{x^{a-1} \ln(x)^{b-1}} = 0$. Therefore, the original integral $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ diverges if $\int_2^\infty \frac{1}{x^a \ln(x)^{b-1}}\ dx$ converges. We can repeat this process until the exponent on $\ln(x)$ in the denominator is negative and we find that $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ still diverges.

Finally, we'll show that if $a = 1$ then $\int_2^\infty \frac{1}{x^a \ln(x)^b}\ dx$ converges if and only if $b > 1$. If we substitute $u = \ln(x) \implies du = \frac{dx}{x}$ we have:

$$
\begin{align*}
    \int_2^\infty \frac{1}{x \ln(x)^b}\ dx = \int_{\ln(2)}^\infty \frac{1}{u^b}\ du.
\end{align*}
$$

However, this integral converges if and only if $b > 1$.
