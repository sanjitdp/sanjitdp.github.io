---
layout: note
title: Asymptotic statistics of arithmetic functions
date: 2023-07-18
author: Sanjit Dandapanthula
---

- TOC
{:toc}

These are my solutions to some [problems](https://terrytao.wordpress.com/2014/11/23/254a-notes-1-elementary-multiplicative-number-theory/) written by [Terence Tao](https://terrytao.wordpress.com/) for Math 254A (grad. analytic number theory) at UCLA. I actually enrolled in this class in Fall 2022 without any of the nine relevant prerequisite courses, but around the fourth week of the class, Prof. Tao began using some more advanced Fourier-analytic techniques (Fourier transforms on finite groups, representation theory, etc.). Eventually, the problems began to require more intuition from Fourier analysis and representation theory (which I lacked) so I ended up dropping this class after four weeks because I was spending too much time on the homeworks.

In retrospect, I shouldn't have rushed to take this class without taking the requisite graduate coursework, but the experience strangely built my confidence and allowed me to get my hands dirty solving a wide variety of analysis problems. The problems here are interesting because my solutions to them apply lots of tricks from real analysis, including using big-$O$ notation to clean up some of the bounds and cleverly applying several versions of the quantitative integral test.

Learning from Prof. Tao in class and during his office hours helped me develop an intuition for controlling the rates at which different mathematical objects grow, which is very useful for an analyst or applied mathematician. Also, I think it's pretty cool to say I had the opportunity to be taught by (arguably) the greatest mathematician of all time. 🙂

# Existence of the logarithmic density

Let $f : \mathbb{N} \to \mathbb{C}$ be an arithmetic function and suppose that the [natural density](https://en.wikipedia.org/wiki/Natural_density) $\lim_{x \to \infty} \frac{1}{x} \sum_{n \leq x} f(n)$ of $f$ exists and is equal to $\alpha \in \mathbb{C}$. Then, we want to show that the logarithmic density $\lim_{x \to \infty} \frac{1}{\log(x)} \sum_{n \leq x} \frac{f(n)}{n}$ also exists and is equal to $\alpha$. First, we will show the following identity:

$$
\begin{align*}
    \sum_{n \leq x} \frac{f(n)}{n}
    = \frac{1}{x} \sum_{n \leq x} f(n) + \int_1^x \frac{1}{t^2} \sum_{n \leq t} f(n)\ dt.
\end{align*}
$$

We'll begin by examining the integral on the right-hand side:

$$
\begin{align*}
    \int_1^x \frac{1}{t^2} \sum_{n \leq t} f(n)\ dt
    = \int_1^x \frac{1}{t^2} \sum_{n \leq x} \mathbf{1}_{n \leq t} f(n)\ dt
    = \sum_{n \leq x} \int_n^x \frac{f(n)}{t^2} \ dt
    = \sum_{n \leq x} \left( \frac{f(n)}{n} - \frac{f(n)}{x} \right).
\end{align*}
$$

Rearranging, this establishes our desired identity. Now, we divide both sides of the identity by $\log(x)$ and take the limit as $x \to \infty$ on both sides to find that:

$$
\begin{align*}
    \lim_{x \to \infty} \frac{1}{\log(x)} \sum_{n \leq x} \frac{f(n)}{n}
    = \lim_{x \to \infty} \frac{1}{x \log(x)} \sum_{n \leq x} f(n) + \lim_{x \to \infty} \frac{1}{\log(x)} \int_1^x \frac{1}{t} \sum_{n \leq t} f(n)\ \frac{dt}{t}.
\end{align*}
$$

However, notice that because the natural density exists, we deduce that $\lim_{x \to \infty} \frac{1}{x \log(x)} \sum_{n \leq x} f(n) = 0$. Fix $\epsilon > 0$. Now, because the natural density of $f$ is $\alpha$, we can choose $N_\epsilon \in \mathbb{Z}^+$ such that $\frac{1}{t} \sum_{n \leq t} f(n) = \alpha + O(\epsilon)$ for all $t \geq N_\epsilon$. Now, we compute:

$$
\begin{align*}
    \lim_{x \to \infty} \frac{1}{\log(x)} \int_1^x \frac{1}{t} \sum_{n \leq t} f(n)\ \frac{dt}{t}
    = \lim_{x \to \infty} \frac{1}{\log(x)} \int_1^{N_\epsilon} \frac{1}{t} \sum_{n \leq t} f(n)\ \frac{dt}{t} + \lim_{x \to \infty} \frac{1}{\log(x)} \int_{N_\epsilon}^x \frac{1}{t} \sum_{n \leq t} f(n)\ \frac{dt}{t}.
\end{align*}
$$

Since the lower half of the integral is a constant, the first limit evaluates to zero. Then, we have by construction:

$$
\begin{align*}
    \lim_{x \to \infty} \frac{1}{\log(x)} \int_{N_\epsilon}^x \frac{1}{t} \sum_{n \leq t} f(n)\ \frac{dt}{t}
     & = \lim_{x \to \infty} \frac{1}{\log(x)} \int_{N_\epsilon}^x (\alpha + O(\epsilon))\ \frac{dt}{t}                    \\
     & = \lim_{x \to \infty} \left[ \alpha + O(\epsilon) - \frac{\log(N_\epsilon)}{\log(x)} (\alpha + O(\epsilon)) \right] \\
     & = \alpha + O(\epsilon).
\end{align*}
$$

Since $\epsilon$ was arbitrary, we find that the logarithmic density $\lim_{x \to \infty} \frac{1}{\log(x)} \sum_{n \leq x} \frac{f(n)}{n}$ exists and is equal to $\alpha$ as desired.

# Convergence result for Dirichlet series

This result builds on the previous problem to show a result about the [Dirichlet series](https://en.wikipedia.org/wiki/Dirichlet_series), which commonly appears in analytic number theory. Let $f : \mathbb{N} \to \mathbb{C}$ be an arithmetic function and suppose that the logarithmic density $\lim_{x \to \infty} \frac{1}{\log(x)} \sum_{n \leq x} \frac{f(n)}{n}$ of $f$ exists and is equal to $\alpha \in \mathbb{C}$. Furthermore, suppose that $f = O(n^{o(1)})$. Then, if $\mathcal{D} f(s) = \sum_{n=1}^\infty \frac{f(n)}{n^s}$, we would like to show that $\lim_{s \to 1^+} (s - 1) \cdot \mathcal{D} f(s) = \alpha$. Well, we know that:

$$
\begin{align*}
    \mathcal{D} f(s)
    = \sum_{n=1}^\infty \frac{f(n)}{n^s}.
\end{align*}
$$

However, note that $\frac{1}{n^s} = \frac{1}{n} \int_n^\infty \frac{s-1}{x^s}\ dx$ by the fundamental theorem of calculus (since $s-1 > 0$). Therefore, we have:

$$
\begin{align*}
    \sum_{n=1}^\infty \frac{f(n)}{n^s}
    = \sum_{n=1}^\infty \frac{f(n)}{n} \int_n^\infty \frac{s-1}{x^s}\ dx
    = \sum_{n=1}^\infty \frac{f(n)}{n} \int_1^\infty \mathbf{1}_{x \geq n} \frac{s-1}{x^s}\ dx.
\end{align*}
$$

Note that the sum-integral is absolutely convergent by the bound $f = O(n^{o(1)})$. Therefore, using Fubini's theorem, we interchange the sum and the integral:

$$
\begin{align*}
    \sum_{n=1}^\infty \frac{f(n)}{n} \int_1^\infty \mathbf{1}_{x \geq n} \frac{s-1}{x^s}\ dx
    = \int_1^\infty \sum_{n=1}^\infty \frac{f(n)}{n} \mathbf{1}_{x \geq n} \frac{s-1}{x^s}\ dx
    = \int_1^\infty \left( \sum_{n \leq x} \frac{f(n)}{n} \right) \frac{s-1}{x^s}\ dx.
\end{align*}
$$

Fix $\epsilon > 0$ and choose $N_\epsilon$ such that $\sum_{n \leq x} \frac{f(n)}{n} = \alpha \log(x) + O(\epsilon \log(x))$ for $x \geq N_\epsilon$. Now, we have:

$$
\begin{align*}
    \int_1^\infty \left( \sum_{n \leq x} \frac{f(n)}{n} \right) \frac{s-1}{x^s}\ dx
    = (s-1) \int_1^{N_\epsilon} \left( \sum_{n \leq x} \frac{f(n)}{n} \right) \frac{1}{x^s}\ dx + \int_{N_\epsilon}^\infty \left( \sum_{n \leq x} \frac{f(n)}{n} \right) \frac{s-1}{x^s}\ dx.
\end{align*}
$$

The first term is clearly $o\left( \frac{1}{s-1} \right)$, so it suffices to show that the second term is $\frac{\alpha + O(\epsilon)}{s-1} + o\left( \frac{1}{s-1} \right)$. However, we know that:

$$
\begin{align*}
    \int_{N_\epsilon}^\infty \left( \sum_{n \leq x} \frac{f(n)}{n} \right) \frac{s-1}{x^s}\ dx
     & = \int_{N_\epsilon}^\infty \left( \alpha\log(x) + O(\epsilon \log(x)) \right) \frac{s-1}{x^s}\ dx               \\
     & = (\alpha + O(\epsilon)) \left[ \frac{x^{1-s} ((s-1) \log(x) + 1)}{s - 1} \right]_{x=N_\epsilon}^{x \to \infty} \\
     & = (\alpha + O(\epsilon)) \left( \frac{N_\epsilon^{1-s} ((s-1) \log(N_\epsilon) + 1)}{s - 1} \right).
\end{align*}
$$

Therefore, we find that:

$$
\begin{align*}
    \lim_{s \to 1^+} (s-1) \cdot \mathcal{D} f(s)
    = \lim_{s \to 1^+} (\alpha + O(\epsilon)) \left( N_\epsilon^{1-s} (s-1) \log(N_\epsilon) + N_\epsilon^{1-s} \right)
    = \alpha + O(\epsilon).
\end{align*}
$$

Since $\epsilon$ was arbitrary, we find that $\lim_{s \to 1^+} (s-1) \cdot \mathcal{D} f(s) = \alpha$ and the result is shown.

# A neat quantitative integral test

In this problem, we'll show the following quantitative integral test for functions $f \in C^1(\mathbb{R})$:

$$
\begin{align*}
    \sum_{n \in \mathbb{Z}:\ y \leq n \leq x} f(n) = \int_y^x f(t)\ dt + O\left( \int_y^x \lvert f^\prime(t) \ dt + \lvert f(y) \rvert \right).
\end{align*}
$$

First, since $f$ is continuously differentiable, we find by Taylor's theorem with integral remainder that:

$$
\begin{align*}
    \int_n^{n+1} f(t)\ dt
    = \int_n^{n+1} \left( f(n) + \int_n^t (t-w) f^\prime(w)\ dw \right)\ dt
    = f(n) + \int_n^{n+1} \int_n^t (t-w) f^\prime(w)\ dw\ dt.
\end{align*}
$$

Then, we know that:

$$
\begin{align*}
    \left\lvert \int_n^{n+1} \int_n^t (t-w) f^\prime(w)\ dw\ dt \right\rvert
     & \leq \int_n^{n+1} \int_n^t \lvert (t-w) f^\prime(w) \rvert\ dw\ dt \\
     & \leq \int_n^{n+1} \int_n^t \lvert f^\prime(w) \rvert\ dw\ dt       \\
     & \leq \int_n^{n+1} \int_y^x \lvert f^\prime(w) \rvert\ dw\ dt       \\
     & = O\left( \int_y^x \lvert f^\prime(w) \rvert\ dw \right).
\end{align*}
$$

Therefore, we find:

$$
\begin{align*}
    f(n) = \int_n^{n+1} f(t)\ dt + O\left( \int_y^x \lvert f^\prime(w) \rvert\ dw \right).
\end{align*}
$$

In fact, iterating this argument, we have the bound:

$$
\begin{align*}
    \sum_{\lceil y \rceil \leq n \leq \lfloor x \rfloor} f(n) = \int_{\lceil y \rceil}^{\lfloor x \rfloor} f(t)\ dt + O\left( \int_y^x \lvert f^\prime(w) \rvert\ dw \right).
\end{align*}
$$

Now, by Taylor's theorem with integral remainder we also have the bound:

$$
\begin{align*}
    \left\lvert \int_y^{\lceil y \rceil} f(t)\ dt \right\rvert
     & = \left\lvert \int_y^{\lceil y \rceil} \left( f(y) + \int_y^t (t-w) f^\prime(w)\ dw \right)\ dt \right\rvert \\
     & \leq \lvert f(y) \rvert + \int_y^{y+1} \int_y^t \lvert (t-w) f^\prime(w) \rvert\ dw \ dt                     \\
     & \leq \lvert f(y) \rvert + \int_y^x \lvert f^\prime(w) \rvert\ dw.
\end{align*}
$$

This means that:

$$
\begin{align*}
    \int_y^{\lceil y \rceil} f(t)\ dt = O\left( \lvert f(y) \rvert + \int_y^x \lvert f^\prime(w) \rvert\ dw \right).
\end{align*}
$$

By an identical argument, we find:

$$
\begin{align*}
    \int_{\lfloor x \rfloor}^{x} f(t)\ dt = O\left( \lvert f(x) \rvert + \int_y^x \lvert f^\prime(w) \rvert\ dw \right).
\end{align*}
$$

However, we know that:

$$
\begin{align*}
    \lvert f(x) \rvert
    = \left\lvert f(y) + \int_y^x f^\prime(t)\ dt \right\rvert
    \leq \lvert f(y) \rvert + \int_y^x \lvert f^\prime(w) \rvert\ dw.
\end{align*}
$$

Hence we see that $\lvert f(x) \rvert = O\left( \lvert f(y) \rvert + \int_y^x \lvert f^\prime(w) \rvert\ dw \right)$. Summing the bounds we have for all three parts of the integral, we obtain the desired result.

# Non-existence of the natural density

As an application of the above problem, we'll show that the converse to the first statement we proved is not true; namely, if $t \in \mathbb{R} \setminus \lbrace 0 \rbrace$ then $n \mapsto n^{it}$ has logarithmic density zero but does not have a natural density. Letting $f(n) = n^{it}$, we compute the logarithmic density using the above quantitative integral test:

$$
\begin{align*}
    \lim_{x \to \infty} \frac{1}{\log(x)} \sum_{n \leq x} \frac{f(n)}{n}
    = \lim_{x \to \infty} \frac{1}{\log(x)} \sum_{n \leq x} n^{it-1}
    = \lim_{x \to \infty} \frac{1}{\log(x)} \left( \int_1^x n^{it-1}\ dn + O\left( \lvert f(1) \rvert + \int_1^x \lvert f^\prime(n) \rvert\ dn \right) \right).
\end{align*}
$$

First, notice that $\lvert f(1) \rvert = O(1)$. Now, since $f^\prime(n) = (it-1) n^{it-2}$, we have:

$$
\begin{align*}
    \int_1^x \lvert f^\prime(n) \rvert\ dn
    = \lvert it-1 \rvert \int_1^x \frac{\lvert n^{it} \rvert}{n^2}\ dn
    \leq \lvert it-1 \rvert \int_1^\infty \frac{1}{n^2}\ dn
    = O(1).
\end{align*}
$$

We can also compute:

$$
\begin{align*}
    \int_1^x n^{it-1}\ dn
    = \left[ \frac{n^{it}}{it} \right]_{n=1}^{n=x}
    = \frac{x^{it}-1}{it}.
\end{align*}
$$

However, we know that we have:

$$
\begin{align*}
    \left\lvert \frac{x^{it}-1}{it} \right\rvert
    \leq \left\lvert \frac{x^{it}}{it} \right\rvert + \left\lvert \frac{1}{it} \right\rvert
    = \left\lvert \frac{2}{it} \right\rvert
    = O(1).
\end{align*}
$$

Hence, we have, because $\lim_{x \to \infty} \frac{O(1)}{\log(x)} = 0$:

$$
\begin{align*}
    \lim_{x \to \infty} \frac{1}{\log(x)} \sum_{n \leq x} n^{it-1}
    = \lim_{x \to \infty} \frac{1}{\log(x)} \left( \int_1^x n^{it-1}\ dn + O\left( \lvert f(1) \rvert + \int_1^x \lvert f^\prime(n) \rvert\ dn \right) \right)
    = 0.
\end{align*}
$$

Thus we deduce that the logarithmic density of $n^{it}$ exists and is equal to zero. On the other hand, suppose that the natural density of $n^{it}$ existed. We have the following bound by our new quantitative integral test:

$$
\begin{align*}
    \sum_{x \leq n \leq (1+\epsilon) x} n^{it}
    = \int_x^{(1+\epsilon) x} n^{it}\ dn + O\left( \lvert f(x) \rvert + \int_x^{(1+\epsilon) x} \lvert f^\prime(n) \rvert\ dn \right).
\end{align*}
$$

First, it's clear that $\lvert f(x) \rvert = \lvert x^{it} \rvert = O(1)$. Furthermore, we know that:

$$
\begin{align*}
    \int_x^{(1+\epsilon) x} n^{it}\ dn
    = \left[ \frac{n^{it+1}}{it+1} \right]_{n=x}^{n=(1+\epsilon)x}
    = \frac{((1+\epsilon)^{it+1} - 1) x^{it+1}}{it+1}.
\end{align*}
$$

Finally, we compute:

$$
\begin{align*}
    \int_x^{(1+\epsilon) x} \lvert f^\prime(n) \rvert\ dn
    = \int_x^{(1+\epsilon) x} \left\lvert it n^{it} \right\rvert\ dn
    = (1 + \epsilon) \lvert it \rvert.
\end{align*}
$$

Hence, we have (by the reverse triangle inequality):

$$
\begin{align*}
    \left\lvert \frac{1}{(1+\epsilon) x} \sum_{x \leq n \leq (1+\epsilon) x} n^{it} \right\rvert
     & = \left\lvert \frac{(1+\epsilon)^{it} x^{it}}{it+1} - \frac{x^{it}}{(1+\epsilon)(it+1)} + \frac{\lvert it \rvert}{x} \right\rvert                          \\
     & \geq \left\lvert \left\lvert \frac{(1+\epsilon)^{it} x^{it}}{it+1} \right\rvert - \left\lvert \frac{x^{it}}{(1+\epsilon)(it+1)} \right\rvert \right\rvert \\
     & = \left\lvert \frac{(1+\epsilon)^{it+1} - 1}{(1+\epsilon)(it+1)} \right\rvert.
\end{align*}
$$

However, the above quantity is strictly positive because $\lvert (1+\epsilon)^{it+1} \rvert = 1+\epsilon$. Hence, all terms of the form $\frac{1}{(1+\epsilon) x} \sum_{x \leq n \leq (1+\epsilon) x} n^{it}$ are (uniformly in $x$) bounded away from zero. This means that $\frac{1}{x} \sum_{n \leq x} f(n)$ is not Cauchy in $x$ and hence the natural density does not exist; this is what we needed to show.

# Derivatives of the Riemann zeta function

Recall that $\zeta(s) = \sum_{n=1}^\infty \frac{1}{n^s}$ is the [Riemann zeta function](https://en.wikipedia.org/wiki/Riemann_zeta_function), which famously has a number of applications to prime number theory. In this problem, we would like to rigorously show that the derivatives of $\zeta$ are given by:

$$
\begin{align*}
    \zeta^{(k)}(s) = (-1)^k \sum_{n=1}^\infty \frac{\log^k(n)}{n^s} = (-1)^k \frac{k!}{(s-1)^{k+1}} + O_k(1).
\end{align*}
$$

We'll show the result by induction on $k$. The base case is shown, since we have the bound $\zeta(s) = \frac{1}{s-1} + O(1)$. Now, suppose that we have the result for some $k \geq 0$:

$$
\begin{align*}
    \zeta^{(k)}(s) = (-1)^k \sum_{n=1}^\infty \frac{\log^k(n)}{n^s} := \sum_{n=1}^\infty f_n^{(k)}(s).
\end{align*}
$$

Suppose we could differentiate $\zeta^{(k)}(s)$ term-by-term for all $k \geq 0$ (we will show this later). Then, we find the desired result:

$$
\begin{align*}
    \zeta^{(k+1)}(s) = (-1)^k \sum_{n=1}^\infty \frac{\log^{k+1}(n)}{n^s} = \sum_{n=1}^\infty f_n^{(k+1)}(s).
\end{align*}
$$

Now, we will show that we can differentiate term-by-term. First, we will show that the sum $\sum_p f_n^{(k+1)}(s)$ converges uniformly and absolutely for $s$ in subsets of the form $(1 + \epsilon, \infty)$ for any $\epsilon > 0$ using the dominated convergence theorem (note that every $s > 1$ is contained in the interior of a set of this form). Since $\log^{(k+1)}(n) > 0$ for all $n$, $n \geq 1$ and $s > 1$, we know that $\frac{\log^{k+1}(n)}{n^s}$ is a strictly decreasing function in $s$. Hence, we conclude that when $s \in (1 + \epsilon, \infty)$, we have $\frac{\log^{k+1}(n)}{n^s} < \frac{\log^{k+1}(n)}{n^{1+\epsilon}}$ for all $n$. Because $\log^{k+1}(n) < n^{\epsilon/2}$ for large $n$, we find:

$$
\begin{align*}
    \sum_{n \geq N} \frac{\log^{k+1}(n)}{n^{1+\epsilon}} \leq \sum_{n \geq N} \frac{1}{n^{1+\epsilon/2}}.
\end{align*}
$$

Therefore, this sum dominates our original sum term-by-term and clearly converges by the $p$-series test. By the dominated convergence theorem, we conclude that $\sum_{n=1}^\infty f_n^{(k+1)}(s)$ is uniformly and absolutely convergent on subsets of the form $s > 1 + \epsilon$. If we fix $s > 1$, then $\sum_{n=1}^\infty f_n^{(k+1)}(s)$ is therefore uniformly convergent on an open set containing $s$. Furthermore, we know inductively that the sum $\sum_{n=1}^\infty f_n^{(k)}(s)$ converges point-wise (by hypothesis), we can differentiate term-by-term as desired and the result follows. Now, we use the quantitative integral test proven above (sending the upper bound of the sum to infinity) to find:

$$
\begin{align*}
    (-1)^k \sum_{n=1}^\infty \frac{\log^k(n)}{n^s}
    = (-1)^k \int_1^\infty \frac{\log^k(n)}{n^s}\ dn + O\left( \int_1^\infty \left\lvert \frac{\log^{k-1}(n) (k - s \log(n))}{n^{s+1}} \right\rvert\ dn \right)
\end{align*}
$$

Then, integrating by parts with $u = \frac{1}{n^{s-1}}$ and $dv = \frac{\log^k(n)}{n}$, we compute:

$$
\begin{align*}
    & \int_1^\infty \frac{\log^k(n)}{n^s}\ dn
    = \left[ \frac{\log^{k+1}(n)}{(k+1) n^{s-1}} \right]_{n=1}^{n \to \infty} + \frac{s-1}{k+1} \cdot \int_1^\infty \frac{\log^{k+1}}{n^s}\ dn \\
    & \qquad \implies \int_1^\infty \frac{\log^{k+1}}{n^s}\ dn = \frac{k+1}{s-1} \cdot \int_1^\infty \frac{\log^k(n)}{n^s}\ dn.
\end{align*}
$$

By this recursive formula, along with the fact that $\int_1^\infty \frac{1}{n^s}\ dn = \frac{1}{s-1}$, we find that:

$$
\begin{align*}
    \int_1^\infty \frac{\log^k(n)}{n^s}\ dn = \frac{k!}{(s-1)^{k+1}}.
\end{align*}
$$

Hence, it remains to show that the remaining terms are $O_k(1)$. However, we find by the triangle inequality that:

$$
\begin{align*}
    \int_1^\infty \left\lvert \frac{\log^{k-1}(n) (k - s \log(n))}{n^{s+1}} \right\rvert\ dn
    \leq \int_1^\infty \frac{k \log^{k-1}(n)}{n^{s+1}}\ dn + \int_1^\infty \frac{s \log^k(n)}{n^{s+1}}\ dn.
\end{align*}
$$

Then, since $s > 1$, we have:

$$
\begin{align*}
    \int_1^\infty \frac{k \log^{k-1}(n)}{n^{s+1}}\ dn
    \leq \int_1^\infty \frac{k \log^{k-1}(n)}{n^2}\ dn.
\end{align*}
$$

This integral clearly converges and only depends on $k$ so this integral is $O_k(1)$. On the other hand, we use integration by parts on our second integral with $u = \log^k(n)$ and $dv = \frac{s}{n^{s+1}}$ to find:

$$
\begin{align*}
    \int_1^\infty \frac{s \log^k(n)}{n^{s+1}}\ dn
    = \left[ -\frac{\log^k(n)}{n^s} \right]_{n=1}^{n \to \infty} + \int_1^\infty \frac{k \log^{k-1}(n)}{n^{s+1}}\ dn
    = \int_1^\infty \frac{k \log^{k-1}(n)}{n^{s+1}}\ dn.
\end{align*}
$$

However, since $s > 1$, we have:

$$
\begin{align*}
    \int_1^\infty \frac{k \log^{k-1}(n)}{n^{s+1}}\ dn
    \leq \int_1^\infty \frac{k \log^{k-1}(n)}{n^2}\ dn.
\end{align*}
$$

Since this integral clearly converges and only depends on $k$, we find that the second integral is also $O_k(1)$. Combining these bounds, we have:

$$
\begin{align*}
    (-1)^k \sum_{n=1}^\infty \frac{\log^k(n)}{n^s}
    = (-1)^k \frac{k!}{(s-1)^{k+1}} + O_k(1).
\end{align*}
$$

This was the desired result, so we are done.

# Logarithmic derivative of the Riemann zeta

Finally, in this problem, we will rigorously show that the logarithmic derivative of the Riemann zeta function $\zeta(s)$ is given by:

$$
\begin{align*}
    -\log(\zeta(s)) = \sum_p \log\left( 1 - \frac{1}{p^s} \right).
\end{align*}
$$

Here, the sum is taken over all primes $p$. First, we know that:

$$
\begin{align*}
    \zeta(s) = \prod_p \left( 1 - \frac{1}{p^s} \right)^{-1}.
\end{align*}
$$

Therefore, we find that:

$$
\begin{align*}
    -\log(\zeta(s)) = \sum_p \log\left( 1 - \frac{1}{p^s} \right) = \sum_p f_p(s).
\end{align*}
$$

Supposing we could differentiate the above sum term-by-term (we will justify this in a bit) we would have the desired result:

$$
\begin{align*}
    -\frac{\zeta^\prime(s)}{\zeta(s)} = \sum_p \frac{\log(p)}{p^s - 1} = \sum_p f_p^\prime(s).
\end{align*}
$$

Now, we will show that we can differentiate term-by-term. First, we will show that the sum $\sum_p f_p^\prime(s)$ converges uniformly on subsets of the form $(1 + \epsilon, \infty)$ for any $\epsilon > 0$ using the dominated convergence theorem (note that every $s > 1$ is contained in the interior of a set of this form). Because $p \geq 2$ and $s > 1$, we know that $p^s - 1$ is a strictly increasing function in $s$. Further, we know that $\log(p) > 0$. Therefore, we know that if $s \in (1 + \epsilon, \infty)$, then $\frac{\log(p)}{p^s - 1} < \frac{\log(p)}{p^{1+\epsilon} - 1}$. However, we know that the following sum converges by comparison because $\log(n) \leq n^{\epsilon/2}$ for large $n$:

$$
\begin{align*}
    \sum_p \frac{\log(p)}{p^{1+\epsilon} - 1}
    \leq \sum_{n \geq N} \frac{\log(n)}{n^{1+\epsilon} - 1}
    \leq \sum_{n \geq N} \frac{n^{\epsilon/2}}{n^{1+\epsilon} - 1}
    = \sum_{n \geq N} \frac{1}{n^{1+\epsilon/2} - n^{-\epsilon/2}}.
\end{align*}
$$

Then, by limit comparison to $\sum \frac{1}{n^{1+\epsilon/2}}$, we find that the above series converges:

$$
\begin{align*}
    \lim_{n \to \infty} \frac{n^{1+\epsilon/2} - n^{-\epsilon/2}}{n^{1+\epsilon/2}} = 1.
\end{align*}
$$

Hence, we know that our original sum is dominated term-wise by the convergent sum $\sum_p \frac{\log(p)}{p^{1+\epsilon} - 1}$. By the dominated convergence theorem, we conclude that $\sum_p f_p^\prime(s)$ is uniformly convergent on subsets of the form $s > 1 + \epsilon > 1$ For any $s > 1$, this sum is therefore uniformly convergent on an open set containing $s$. Furthermore, because we know that the sum $\sum_p f_p(s)$ converges point-wise to $-\log(\zeta(s))$, we can differentiate term-by-term as desired and the result follows.
