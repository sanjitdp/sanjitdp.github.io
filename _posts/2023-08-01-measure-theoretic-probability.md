---
layout: note
title: Selected proofs from measure-theoretic probability
date: 2023-08-01
author: Sanjit Dandapanthula
---

- TOC
{:toc}

This post will contain some problems I solved as part of Math 275A (grad. probability theory) at UCLA, taught by [Tim Austin](https://www.math.ucla.edu/~tim/) last fall. Many of these problems ended up not being submitted due to the [UC-UAW TA strike](https://www.universityofcalifornia.edu/UAW), but I still learned a lot from writing up these solutions.

I'll include results in this post that I've later found useful, as well as problems that demonstrate some of the techniques I learned in the class; these include the [Borel-Cantelli lemmas](https://en.wikipedia.org/wiki/Borel–Cantelli_lemma), the [laws of large numbers](https://en.wikipedia.org/wiki/Law_of_large_numbers), the [Kolmogorov 0-1 law](https://en.wikipedia.org/wiki/Kolmogorov%27s_zero–one_law), and the [central limit theorem](https://en.wikipedia.org/wiki/Central_limit_theorem).

## Inverse transform sampling

In this problem, we'll show that if $X$ is a continuous random variable with cumulative distribution function $F$, then $F(X) \sim \operatorname{Unif}(0, 1)$.

> This result gets used often when we only have access to a uniform random variable (think Python's `rand()` function) but we want to sample according to a given distribution; statisticians call this [inverse transform sampling](https://en.wikipedia.org/wiki/Inverse_transform_sampling).

First, extend $F$ by defining $F(-\infty) = 0$ and $F(\infty) = 1$. Now, define a function $F^{-1} : [0, 1] \to \mathbb{R}^\ast$ by $F^{-1}(x) := \sup \lbrace x_0 \in \mathbb{R}^\ast : F(x_0) \leq x \rbrace$. Note that $F : \mathbb{R}^\ast \to [0, 1]$ is surjective by the intermediate value theorem since $F$ is continuous, $\lim_{x \to -\infty} F(x) = 0$, and $\lim_{x \to \infty} F(x) = 1$. Furthermore, we know that every subset of $\mathbb{R}^*$ has a supremum, so $F^{-1}$ is well-defined.

Then, by continuity of $F$, it's clear that $F(F^{-1}(y)) = y$ for all $y \in [0, 1]$. If $F(F^{-1}(y)) > y$, by continuity we would have some point such that $y < F(x_0) < F(F^{-1}(y))$ and since $F^{-1}(y)$ is the least upper bound we would have a contradiction. On the other hand, by surjectivity we can't have $F(F^{-1}(y)) < y$ since there exists a point such that $F(x_0) = y$ and $F^{-1}$ is defined to be an upper bound.

Now, by definition of the supremum and monotonicity of $F$, notice that $F(X) \leq y$ if and only if $X \leq \sup\lbrace x_0 \in \mathbb{R} : F(x_0) \leq y \rbrace = F^{-1}(y)$.
Now, we compute:

$$
\begin{align*}
    \mathbb{P}(Y \leq y) = \mathbb{P}(F(X) \leq y) = \mathbb{P}(X \leq F^{-1}(y)) = F(F^{-1}(y)) = y.
\end{align*}
$$

Hence we deduce that $Y = F(X)$ has a uniform distribution on $(0, 1)$ as desired, and we are done.

## Non-existent lower bounds

This is Problem 1.6.5 in Rick Durrett's *Probability: Theory and Examples*. Both parts of this problem are about constructing examples explicitly and controlling probability mass.

### The first bound

First, we'll show that if $\epsilon > 0$, then $\inf \lbrace \mathbb{P}(\lvert X \rvert > \epsilon) : \mathbb{E}[X] = 0, \operatorname{Var}(X) = 1 \rbrace = 0$. Suppose $\Omega = \lbrace 1, 2, \cdots, n \rbrace$ and $\mathbb{P}$ the probability measure characterized by $\mathbb{P}(\lbrace k \rbrace) = \frac{1}{n}$ for $1 \leq k \leq n$. Let $X_n : \Omega \to \mathbb{R}$ be a random variable defined by:

$$
\begin{align*}
    X_n(\omega)
    = \begin{cases}
          \sqrt{\frac{n}{2}} \qquad  & \omega = 1            \\
          -\sqrt{\frac{n}{2}} \qquad & \omega = 2            \\
          0 \qquad                   & 3 \leq \omega \leq n.
      \end{cases}
\end{align*}
$$

Then, we know that:

$$
\begin{align*}
    \mathbb{E}[X_n]
    = \frac{1}{n} \sum_{\omega \in \Omega} X_n(\omega)
    = \frac{1}{n} \left( \sqrt{\frac{n}{2}} - \sqrt{\frac{n}{2}} \right)
    = 0.
\end{align*}
$$

Similarly, we compute:

$$
\begin{align*}
    \operatorname{Var}(X_n)
    = \mathbb{E}[X_n^2] - \mathbb{E}[X_n]^2
    = \mathbb{E}[X_n^2]
    = \frac{1}{n} \sum_{\omega \in \Omega} X_n^2(\omega)
    = \frac{1}{n} \left( \frac{n}{2} + \frac{n}{2} \right)
    = 1.
\end{align*}
$$

However, we know that for all $\epsilon > 0$ we have $0 \leq \mathbb{P}(\vert X_n \rvert > \epsilon) \leq \mathbb{P}(\vert X_n \rvert > 0) = \frac{2}{n}$ by monotonicity and nonnegativity of the probability measure. Hence, as $n$ can be chosen arbitrarily large, we deduce that:

$$
\begin{align*}
    \inf\lbrace \mathbb{P}(\lvert X \rvert > \epsilon) : \mathbb{E}[X] = 0,\ \operatorname{Var}(X) = 1 \rbrace = 0.
\end{align*}
$$

This is the desired result, so we are done.

### The second bound

Next, we will show that if $y \geq 1$ and $\sigma^2 > 0$, then $\inf \lbrace \mathbb{P}(\lvert X \rvert > y) : \mathbb{E}[X] = 1, \operatorname{Var}(X) = \sigma^2 \rbrace = 0$. Suppose $\Omega = \lbrace 1, 2, \cdots, n \rbrace$ and $\mathbb{P}$ the probability measure characterized by $\mathbb{P}(\lbrace k \rbrace) = \frac{1}{n}$ for $1 \leq k \leq n$. Let $X_n : \Omega \to \mathbb{R}$ be a random variable defined by:

$$
\begin{align*}
    X_n(\omega)
    = \begin{cases}
          1 + \sqrt{\frac{n \sigma^2}{2}} \qquad & \omega = 1            \\
          1 - \sqrt{\frac{n \sigma^2}{2}} \qquad & \omega = 2            \\
          1 \qquad                               & 3 \leq \omega \leq n.
      \end{cases}
\end{align*}
$$

Then, we know that:

$$
\begin{align*}
    \mathbb{E}[X_n]
    = \frac{1}{n} \sum_{\omega \in \Omega} X_n(\omega)
    = \frac{1}{n} \left( (n-2) + \left( 1 + \sqrt{\frac{n \sigma^2}{2}} \right) + \left( 1 - \sqrt{\frac{n \sigma^2}{2}} \right) \right)
    = 1.
\end{align*}
$$

Similarly, we compute:

$$
\begin{align*}
    \operatorname{Var}(X_n)
    = \mathbb{E}\left[ (X_n - \mathbb{E}[X_n])^2 \right]
    = \frac{1}{n} \sum_{\omega \in \Omega} (X_n(\omega) - 1)^2
    = \frac{1}{n} \left( \frac{n \sigma^2}{2} + \frac{n \sigma^2}{2} \right)
    = \sigma^2.
\end{align*}
$$

However, we know that for all $y \geq 1$ we have $0 \leq \mathbb{P}(\vert X_n \rvert > y) \leq \mathbb{P}(\vert X_n \rvert > 1) = \frac{2}{n}$ by monotonicity and nonnegativity of the probability measure. Hence, as $n$ can be chosen arbitrarily large, we deduce that:

$$
\begin{align*}
    \inf\lbrace \mathbb{P}(\lvert X \rvert > \epsilon) : \mathbb{E}[X] = 1,\ \operatorname{Var}(X) = \sigma^2 \rbrace = 0.
\end{align*}
$$

This is the desired result, so we are done.

## Generalization of the $L^2$ weak law

This is Problem 2.2.2 in Rick Durrett's *Probability: Theory and Examples*. This is a generalization of the $L^2$ weak law of large numbers to sequences that are decreasingly dependent, and the proof is analogous to that of the weak law of large numbers. If $\mathbb{E}[X_n] = 0$ and $\mathbb{E}[X_n X_m] = r(n - m)$ for $m \leq n$ with $r(k) \to 0$ as $k \to \infty$, then we want to show that $\frac{X_1 + \cdots + X_n}{n} \to 0$ converges in probability.

Fix $\epsilon > 0$ and define $S_n = X_1 + \cdots + X_n$; by linearity of expectation we have $\mathbb{E}[S_n] = 0$. By Markov's inequality, we know that:

$$
\begin{align*}
    \mathbb{P}\left( \frac{\lvert S_n \rvert}{n} \geq \epsilon \right)
    \leq \frac{\mathbb{E}\left[ (S_n/n)^2 \right]}{\epsilon^2}
    = \frac{\mathbb{E}[S_n^2]}{n^2 \epsilon^2}
\end{align*}
$$

Now, we compute:

$$
\begin{align*}
    \mathbb{E}[S_n^2]
    = \mathbb{E}\left[ (X_1 + \cdots + X_n)^2 \right]
    = \sum_{j=1}^n \sum_{k=1}^n \mathbb{E}[X_j X_k]
    = \sum_{m=1}^n \mathbb{E}[X_m^2] + 2 \cdot \sum_{j=1}^n \sum_{k=j+1}^n \mathbb{E}[X_j X_k].
\end{align*}
$$

We know the uniform bound $\mathbb{E}[X_m^2] \leq r(0)$, so we see that:

$$
\begin{align*}
    \sum_{m=1}^n \mathbb{E}[X_m^2] \leq \sum_{m=1}^n r(0) = n \cdot r(0).
\end{align*}
$$

On the other hand, fix $\epsilon_0 > 0$; we can choose $N \in \mathbb{N}$ such that for all $m \geq N$ we have $r(m) \leq \epsilon_0$. Then, let $M = \max_{1 \leq i \leq N} r(i)$. Therefore, we know that:

$$
\begin{align*}
    \sum_{j=1}^n \left( \sum_{k=j+1}^{j+N} \mathbb{E}[X_j X_k] + \sum_{k=j+N+1}^n \mathbb{E}[X_j X_k] \right)
    \leq \sum_{j=1}^n \left( N \cdot M + n \cdot \epsilon_0 \right)
    \leq n \cdot NM + n^2 \cdot \epsilon_0.
\end{align*}
$$

Using these bounds, we find:

$$
\begin{align*}
    \frac{\mathbb{E}[S_n^2]}{n^2 \epsilon^2}
    \leq \frac{1}{n^2 \epsilon^2} \left( n \cdot r(0) + 2 \cdot \left( n \cdot NM + n^2 \cdot \epsilon_0 \right) \right)
    = \frac{r(0)}{n \epsilon^2} + \frac{2NM}{n \epsilon^2} + \frac{\epsilon_0}{\epsilon^2}.
\end{align*}
$$

Taking the limit as $n \to \infty$, we find by nonnegativity of the measure that:

$$
\begin{align*}
    0
    \leq \lim_{n \to \infty} \mathbb{P}\left( \frac{\lvert S_n \rvert}{n} \geq \epsilon \right)
    \leq \frac{\epsilon_0}{\epsilon^2}.
\end{align*}
$$

However, since $\epsilon_0$ was arbitrary, we deduce that $\mathbb{P}\left( \frac{\lvert S_n \rvert}{n} \geq \epsilon \right) \to 0$ as $n \to \infty$; namely, $\frac{S_n}{n} \to 0$ in probability as desired.

## Monte Carlo integration

This is Problem 2.2.3 in Rick Durrett's *Probability: Theory and Examples*. This problem demonstrates how the weak law of large numbers is typically used. Suppose $f$ is a measurable function on $[0, 1]$ with $\int_0^1 \lvert f(x) \rvert\ dx < +\infty$ and $U_1, U_2, \cdots$ are independent and uniformly distributed on $[0, 1]$. Then, if we let $I_n = n^{-1} (f(U_1) + \cdots + f(U_n))$, we'll show that $I_n \to I = \int_0^1 f(x)\ dx$ in probability; namely, we have a good estimate for the integral of $f$.

First, notice that since $U_1$ has density function $\mathbf{1}_{[0, 1]}$ we have:

$$
\begin{align*}
    \mathbb{E}[f(U_1)]
    = \int \mathbf{1}_{[0, 1]} \cdot f(x)\ dx
    = \int_0^1 f(x)\ dx.
\end{align*}
$$

On the other hand, we know that $\mathbb{E}[\lvert f(U_1) \rvert] = \int_0^1 \lvert f(x) \rvert\ dx < \infty$. Hence, we deduce that $f \in L^1$ and the $L^1$ weak law of large numbers applies; namely, we have $I_n = n^{-1} (f(U_1) + \cdots + f(U_n)) \to \mathbb{E}[f(U_1)] = \int_0^1 f(x)\ dx$ in probability.

Now, suppose $\int_0^1 f(x)^2\ dx < +\infty$; we want an explicit bound on the deviation of $I_n$ from $I$. We choose $A = \left\lbrace x : \lvert x \rvert > \frac{a}{\sqrt{n}} \right\rbrace$ so that $\inf\lbrace x^2 : x \in A \rbrace = \frac{a^2}{n}$. Then, we know by Chebyshev's inequality that:

$$
\begin{align*}
    \mathbb{P}\left( \lvert I_n - I \rvert > \frac{a}{\sqrt{n}} \right)
    = \mathbb{P}((I_n - I) \in A)
    \leq \frac{n}{a^2} \mathbb{E}\left[ (I_n - I)^2 \right].
\end{align*}
$$

Then, because $\int_0^1 f(x)^2\ dx < \infty$ and the $U_n$ are i.i.d., we compute:

$$
\begin{align*}
    \frac{n}{a^2} \mathbb{E}\left[ (I_n - I)^2 \right]
     & = \frac{n}{a^2} \operatorname{Var}\left[ \frac{f(U_1) + \cdots + f(U_n)}{n} \right]      \\
     & = \frac{1}{a^2} \operatorname{Var}[f(U_1)]                                               \\
     & = \frac{1}{a^2} \left( \mathbb{E}[f(U_1)^2] - \mathbb{E}[f(U_1)]^2 \right)               \\
     & = \frac{1}{a^2} \left( \int_0^1 f(x)^2\ dx - \left( \int_0^1 f(x)\ dx \right)^2 \right).
\end{align*}
$$

Hence, we have obtained a bound on $\mathbb{P}\left( \lvert I_n - I \rvert > \frac{a}{\sqrt{n}} \right)$ using Chebyshev's inequality, and the result follows.

## Independence + infinite occurrence

This is Problem 2.3.8 in Rick Durrett's *Probability: Theory and Examples*, and showcases an application of the second Borel-Cantelli lemma. If $(A_n)$ is a sequence of independent events with $\mathbb{P}(A_n) < 1$ for all $n \geq 1$ but $\mathbb{P}\left( \bigcup_{n=1}^\infty A_n \right) = 1$, then $\mathbb{P}(A_n\ \text{i.o.}) = 1$. Here, we use $\lbrace A_n\ \text{i.o.} \rbrace$ to denote the event that infinitely many of the $A_n$ occur.

The goal is to use the second Borel-Cantelli lemma, so we need a way to transition between sums of probabilities (given to us by the lemma) and products of probabilities (given to us by independence). Of course, this means we need to use the exponential function.

First, suppose for a contradiction that $\sum_n \mathbb{P}(A_n) < \infty$. We know that there exists $N \in \mathbb{N}$ such that for all $n \geq N$ we have $\mathbb{P}(A_n) < \frac{1}{2}$. Furthermore, suppose $x \in \left[ 0, \frac{1}{2} \right]$ and recall that $e^x \geq 1 + x$ so $e^{-x} \leq \frac{1}{1+x}$. Hence, we find $e^{-2x} \leq \frac{1}{1+2x}$, but since $(1+2x) (1-x) \geq 1$ for $x \in \left[ 0, \frac{1}{2} \right]$, we find $1 - x \geq e^{-2x}$ for $x \in \left[ 0, \frac{1}{2} \right]$. Now, we find:

$$
\begin{align*}
    \prod_{n=N}^\infty (1 - \mathbb{P}(A_n))
    \geq \prod_{n=N}^\infty \exp(-2 \cdot \mathbb{P}(A_n))
    = \exp\left( -2 \cdot \sum_{n=N}^\infty \mathbb{P}(A_n) \right).
\end{align*}
$$

Now, the sum converges by assumption so we find that $\prod_{n=N}^\infty (1 - \mathbb{P}(A_n)) > 0$. Because $\mathbb{P}(A_n) \neq 1$ for any $n \in \mathbb{N}$, we find:

$$
\begin{align*}
    \prod_n (1 - \mathbb{P}(A_n))
    = \left( \prod_{n < N} (1 - \mathbb{P}(A_n)) \right) \cdot \left( \prod_{n \geq N} (1 - \mathbb{P}(A_n)) \right)
    > 0.
\end{align*}
$$

However, we know by de Morgan's law that because $\mathbb{P}\left( \bigcup_n A_n \right) = 1$, we have $\mathbb{P}\left( \bigcap_n A_n^c \right) = 0$. However, because the sets $A_n^c$ are independent, we find:

$$
\begin{align*}
    \mathbb{P}\left( \bigcap_n A_n^c \right)
    = \prod_n \mathbb{P}(A_n^c)
    = \prod_n (1 - \mathbb{P}(A_n))
    = 0.
\end{align*}
$$

Hence, using the above result, $\sum_n \mathbb{P}(A_n)$ must diverge. Finally, by the second Borel-Cantelli lemma and independence of the events $A_n$ we conclude that $\mathbb{P}(A_n\ \text{i.o.}) = 1$ as desired.

## Bernoulli convergence to zero

This is Problem 2.3.11 in Rick Durrett's *Probability: Theory and Examples*, and showcases an application of the first Borel-Cantelli lemma. First, we will show that if $X_n \sim \operatorname{Ber}(p_n)$ are independent, then $X_n \to 0$ in probability if and only if $p_n \to 0$. Well, we know that for $\epsilon > 0$:

$$
\begin{align*}
    \mathbb{P}(\lvert X_n \rvert > \epsilon)
    = \begin{cases}
          0 \quad                         & \epsilon \geq 1  \\
          \mathbb{P}(X_n = 1) = p_n \quad & 0 < \epsilon < 1
      \end{cases}
\end{align*}
$$

Therefore, it's clear that $\mathbb{P}(\lvert X_n \rvert > \epsilon) \to 0$ as $n \to \infty$ if and only if $p_n \to 0$, which is what we needed to show.

Next, we'll show that $X_n \to 0$ almost surely if and only if $\sum_n p_n < +\infty$. Suppose $\sum_n p_n < +\infty$ and define $A_n = \lbrace X_n = 1 \rbrace$. Then, we know that $\mathbb{P}(A_n) = p_n$ so $\sum_n \mathbb{P}(A_n) = \sum_n p_n < +\infty$. Therefore, we have the equality $\mathbb{P}(A_n\ \text{i.o.}) = \mathbb{P}(\lbrace X_n = 1 \rbrace\ \text{i.o.}) = 0$ by the first Borel-Cantelli lemma. Hence, we deduce that $X_n \to 0$ almost surely, which gives the desired result.

## Uniformly random points in balls

This is Problem 2.3.11 in Rick Durrett's *Probability: Theory and Examples*. This problem demonstrates how the strong law of large numbers can make light work of a seemingly difficult problem. Let $X_0 = (1, 0)$ and define $X_{n+1} \in \mathbb{R}^2$ to be chosen at random from the ball of radius $\lVert X_n \rVert _2$ centered at the origin. We want to show that there exists a constant $c$ such that $n^{-1} \log(\lVert X_n \rVert _2) \to c$ almost surely, and compute $c$.

First, we define $Y_n = \frac{X_{n+1}}{\lVert X_n \rVert _2}$ so that $Y_n$ is uniformly distributed on the ball of radius 1 and is independent of $X_1, \cdots, X_n$ (by construction). Now, we compute using polar coordinates:

$$
\begin{align*}
    \mathbb{E}[\log(\lVert Y_0 \rVert _2)]
    = \frac{1}{\pi} \int_0^1 \int_0^{2\pi} r \log(r)\ d\theta\ dr
    = \int_0^1 2r \log(r)\ dr
    = \left[ r^2 \log(r) - \frac{r^2}{2} \right]_{r \to 0^+}^{r=1}
    = -\frac{1}{2}.
\end{align*}
$$

Then, notice that the following sum telescopes:

$$
\begin{align*}
    S_n
    := \sum_{k=0}^{n-1} \log(\lVert Y_k \rVert _2)
    = \sum_{k=0}^{n-1} \left[ \log(\lVert X_{k+1} \rVert _2) - \log(\lVert X_k \rVert _2) \right]
    = \log(\lVert X_n \rVert _2).
\end{align*}
$$

Now, because the $Y_n$ are i.i.d., we deduce by the strong law of large numbers that $n^{-1} S_n = n^{-1} \log(\lVert X_n \rVert _2) \to \mathbb{E}[\log(\lVert Y_0 \rVert _2)] = -\frac{1}{2}$ almost surely. This is what we wanted to show.

## Tightness and uniform convergence

This is Problem 3.3.13 in Rick Durrett's *Probability: Theory and Examples*. This problem mirrors the proof of the Arzelà-Ascoli theorem to show that if $\lbrace \mu_i \rbrace_{i \in I}$ is a tight family of measures and $\mu_n \Rightarrow \mu$ converges weakly, then their characteristic functions converge uniformly on compact sets. Fix $\epsilon > 0$; by tightness, we can choose $M > 0$ such that $\sup_n \mu_n([-M, M]^c) < \epsilon$. Furthermore, by compactness we can choose $\delta > 0$ such that $\left\lvert \mathbb{E}[e^{ihX}] - 1 \right\rvert < \epsilon$ for all $\lvert h \rvert < \delta$ and $x \in [-M, M]$. Then, we know that for any $n \in \mathbb{N}$ and $\lvert h \rvert < \delta$:

$$
\begin{align*}
    \lvert \varphi_n(t + h) - \varphi_n(t) \rvert
     & = \left\lvert \mathbb{E}[e^{itX_n + ihX_n} - e^{itX_n}] \right\rvert                                          \\
     & \leq \mathbb{E}[\lvert e^{ihX_n} - 1 \rvert]                                                                  \\
     & = \int_{[-M, M]} \lvert e^{ihx} - 1 \rvert\ d\mu_n(x) + \int_{[-M, M]^c} \lvert e^{ihx} - 1 \rvert\ d\mu_n(x) \\
     & \leq \epsilon \mu_n([-M, M]) + 2\epsilon                                                                      \\
     & \leq 3\epsilon.
\end{align*}
$$

Since $\epsilon$ was arbitrary, we deduce that the characteristic functions $\varphi_n$ are equicontinuous. Note that this step did not actually require weak convergence of the sequence of measures.

Because $\mu_n \Rightarrow \mu$, we already know that $\varphi_n(t) \to \varphi(t)$ converges pointwise. Fix $\epsilon > 0$ and by equicontinuity of the $\varphi_n$ we can choose $\delta > 0$ such that $\lvert x - x_0 \rvert < \delta$ implies that $\lvert \varphi_n(x) - \varphi_n(x_0) \rvert < \epsilon$ and $\lvert \varphi(x) - \varphi(x_0) \rvert < \epsilon$ for all $n \in \mathbb{N}$. Then, we choose $T \in \mathbb{Z}^+$ such that $\frac{1}{T} < \delta$. Then, by pointwise convergence we choose $N \in \mathbb{N}$ such that $\left\lvert \varphi_n\left( \frac{k}{T} \right) - \varphi\left( \frac{k}{T} \right) \right\rvert < \epsilon$ for all $k \in [-MT, MT] \cap \mathbb{Z}$ and $n \geq N$. Therefore, we find that for all $x \in [-M, M]$ and for all $n \geq N$ there is some $k \in \mathbb{Z}$ such that:

$$
\begin{align*}
    \lvert \varphi(x) - \varphi_n(x) \rvert
    \leq \left\lvert \varphi(x) - \varphi\left( \frac{k}{T} \right) \right\rvert + \left\lvert \varphi\left( \frac{k}{T} \right) - \varphi_n\left( \frac{k}{T} \right) \right\rvert + \left\lvert \varphi_n\left( \frac{k}{T} \right) - \varphi_n(x) \right\rvert
    < 3 \epsilon.
\end{align*}
$$

Since $\epsilon$ was arbitrary, we deduce that the characteristic functions $\varphi_n \to \varphi$ converge uniformly on compact sets as desired.

## Sums grow faster than $\sqrt{n}$

This is Problem 3.4.2 in Rick Durrett's *Probability: Theory and Examples*, and is a nice application of the central limit theorem and Kolmogorov's 0-1 law. Suppose $X_1, \cdots, X_n$ are i.i.d. with $\mathbb{E}[X_i] = 0$ and $0 < \operatorname{Var}(X_i) < +\infty$ and let $S_n = X_1 + \cdots + X_n$ denote the partial sums. Now, we will show that $\limsup_{n \to \infty} \frac{S_n}{\sqrt{n}} = +\infty$ almost surely.

First, we know by the central limit theorem that if $\operatorname{Var}(X_1) = \sigma^2$, then $\frac{S_n}{\sigma \sqrt{n}} \Rightarrow \chi \sim \mathcal{N}(0, 1)$. Therefore, for any $M > 0$, we find:

$$
\begin{align*}
    \mathbb{P}\left( \frac{S_n}{\sqrt{n}} > M\ \text{i.o.} \right)
    \geq \limsup_{n \to \infty} \mathbb{P}\left( \frac{S_n}{\sqrt{n}} > M \right)
    = \limsup_{n \to \infty} \mathbb{P}\left( \frac{S_n}{\sigma \sqrt{n}} > \frac{M}{\sigma} \right)
    = \mathbb{P}\left( \chi > \frac{M}{\sigma} \right) > 0.
\end{align*}
$$

Then, it's clear that the event $A := \left\lbrace \limsup_{n \to \infty} \frac{S_n}{\sqrt{n}} > M \right\rbrace$ is in the tail $\sigma$-algebra $\mathcal{T}$, since it does not depend on $X_1, \cdots, X_N$ for any $N \in \mathbb{N}$. Furthermore, we know that $\left\lbrace \frac{S_n}{\sqrt{n}} > M\ \text{i.o.} \right\rbrace \subseteq A$ so by the Kolmogorov 0-1 law we deduce that $\mathbb{P}(A) = 1$. Since $M$ was arbitrary, we deduce that $\limsup_{n \to \infty} \frac{S_n}{\sqrt{n}} = \infty$ almost surely, so the result follows.

## Self-normalized sums

This is Problem 3.4.2 in Rick Durrett's *Probability: Theory and Examples*. This problem constitutes another application of the central limit theorem and the weak law of large numbers, as well as some manipulation of various modes of convergence. Let $\chi \sim \mathcal{N}(0, 1)$. If $X_1, \cdots, X_n$ are i.i.d. with $\mathbb{E}[X_i] = 0$ and $\mathbb{E}[X_i^2] = \sigma^2 \in (0, +\infty)$, then:

$$
\begin{align*}
    \frac{\sum_{m=1}^n X_m}{\sqrt{\sum_{m=1}^n X_m^2}} \Rightarrow \chi.
\end{align*}
$$

We know by the central limit theorem that:

$$
\begin{align*}
    Y_n := \frac{1}{\sigma \sqrt{n}} \sum_{m=1}^n X_m \Rightarrow \mathcal{N}(0, 1).
\end{align*}
$$

Furthermore, by the weak law of large numbers we know that the following sequence converges in probability:

$$
\begin{align*}
    \frac{\sum_{m=1}^n X_m^2}{n \sigma^2} \to 1.
\end{align*}
$$

Then, taking a continuous map, we deduce that the following sum converges in probability as well:

$$
\begin{align*}
    Z_n := \frac{\sqrt{\sum_{m=1}^n X_m^2}}{\sigma \sqrt{n}} \to 1.
\end{align*}
$$

Therefore, we know that $Y_n Z_n \to \mathcal{N}(0, 1)$ by Skorokhod's representation theorem and the result follows.

## An alternate central limit theorem

This is Problem 3.4.11 in Rick Durrett's *Probability: Theory and Examples*. In this problem, we'll show that if the moments of $X_i$ are uniformly bounded, then we don't need independence. Suppose $\mathbb{E}[X_i] = 0$, $\mathbb{E}[X_i^2] = 1$, and $\mathbb{E}[\lvert X_i \rvert^{2+\delta}] \leq C$ for some $\delta > 0$ and $C < +\infty$. Then, if $S_n = X_1 + \cdots + X_n$ and $\chi \sim \mathcal{N}(0, 1)$, we have $\frac{S_n}{\sqrt{n}} \Rightarrow \chi$.

First, let $X_{n, m} = \frac{X_m}{\sqrt{n}}$. We know that:

$$
\begin{align*}
    \sum_{m=1}^n \mathbb{E}[X_{n, m}^2]
    = \sum_{m=1}^n \frac{1}{n}
    = 1 > 0.
\end{align*}
$$

Furthermore, for any $\epsilon > 0$ we have:

$$
\begin{align*}
    \lim_{n \to \infty} \sum_{m=1}^n \mathbb{E}[\lvert X_{n, m} \rvert^2 ; \lvert X_{n, m} \rvert > \epsilon]
     & = \lim_{n \to \infty} \sum_{m=1}^n \int_{\lvert X_{n, m} \rvert > \epsilon} \lvert X_{n, m} \rvert^2\ d\mathbb{P}                                                           \\
     & = \lim_{n \to \infty} \sum_{m=1}^n \int_{\lvert X_m \rvert > \epsilon \sqrt{n}} \frac{\lvert X_m \rvert^2}{n}\ d\mathbb{P}                                                  \\
     & \leq \lim_{n \to \infty} \frac{1}{\epsilon^\delta n^{1 + \delta / 2}} \sum_{m=1}^n \int_{\lvert X_m \rvert > \epsilon \sqrt{n}} \lvert X_m \rvert^{2 + \delta}\ d\mathbb{P} \\
     & \leq \lim_{n \to \infty} \frac{1}{\epsilon^\delta n^{1 + \delta / 2}} \sum_{m=1}^n \mathbb{E}[\lvert X_m \rvert^{2 + \delta}]                                               \\
     & \leq \lim_{n \to \infty} \frac{C}{\epsilon^\delta n^{\delta / 2}}                                                                                                           \\
     & = 0.
\end{align*}
$$

Therefore, we find that $\frac{S_n}{\sqrt{n}} \Rightarrow \chi$, which is what we needed to show.
