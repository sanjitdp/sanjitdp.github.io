---
layout: note
title: Concentration inequalities for nearest neighbors in hypercubes
date: 2023-06-26
author: Sanjit Dandapanthula
---

Here's a cool result about the concentration of $k$th nearest neighbors of points drawn uniformly randomly from the $d$-dimensional unit hypercube. First, suppose we draw $X_1, \cdots, X_n$ uniformly randomly from $[0, 1]^d$. For $1 \leq k \leq n$ and $1 \leq i \leq n$, we define $R_k(X_i)$ to be the distance from $X_i$ to its $k$th nearest neighbor.

## Concentration of nearest neighbors

If we define $R_{k, \min} = \min_{1 \leq i \leq n} R_k(X_i)$, then we'll show that there exists a constant $a > 0$ (depending only on $d$) so that:

$$
\begin{align*}
    \mathbb{P}\left( R_{k, \min} \leq a \left( \frac{k}{n} \right)^{\frac{1}{d}} \right) \leq n e^{-k/3}.
\end{align*}
$$

Similarly, if we define $R_{k, \max} = \max_{1 \leq i \leq n} R_k(X_i)$, we'll show that there exists a constant $\tilde{a} > 0$ (depending only on $d$) so that:

$$
\begin{align*}
    \mathbb{P}\left( R_{k, \max} \geq \tilde{a} \left( \frac{k}{n} \right)^{\frac{1}{d}} \right) \leq n e^{-k/3}.
\end{align*}
$$

This result is really neat - it shows that $\lbrace R_k(X_i) \rbrace_{i=1}^n$ generally grows like $\left( \frac{k}{n} \right)^{\frac{1}{d}}$ (as $n$ and $k$ are varied) with high probability. This statement looks a bit difficult to show, but we'll break it down into easier pieces.

## Binomial concentration

First, we'll show a set of concentration inequalities for binomial random variables; it will become clear why these are useful later. Namely, if $X \sim \operatorname{Ber}(n, p)$, we'll show:

$$
\begin{align*}
    \mathbb{P}(X \geq (1 + \delta) np) \leq \exp\left( -\frac{\delta^2 np}{3} \right).
\end{align*}
$$

Furthermore, we'll show that:

$$
\begin{align*}
    \mathbb{P}(X \leq (1 - \delta) np) \leq \exp\left( -\frac{\delta^2 np}{2} \right).
\end{align*}
$$

We know that for a binomial random variable $\mathbb{E}[X] = np$, but these results show that $X$ concentrates around its mean with high probability. In order to show these inequalities, we'll use the following elementary inequality of real variables (for $\delta \geq 0$):

$$
\begin{align*}
    \frac{e^\delta}{(1 + \delta)^{1 + \delta}} \leq \exp\left( -\frac{\delta^2}{2 + \delta} \right).
\end{align*}
$$

Define $X = \sum_{i=1}^n X_i$ where $X_i \sim \operatorname{Ber}(p)$ are i.i.d. so that $X \sim \operatorname{Bin}(n, p)$. Then, by independence of the $X_i$, the Chernoff bound gives:

$$
\begin{align*}
    \mathbb{P}(X \geq t)
    \leq \inf_{\lambda \geq 0} \left\{ e^{-\lambda t} \mathbb{E}[e^{\lambda X}] \right\}
    = \inf_{\lambda \geq 0} \left\{ e^{-\lambda t} \mathbb{E}\left[ \exp\left( \lambda \sum_{i=1}^n X_i \right)  \right] \right\}
    = \inf_{\lambda \geq 0} \left\{ e^{-\lambda t} \prod_{i=1}^n \mathbb{E}[e^{\lambda X_i}] \right\}.
\end{align*}
$$

However, because $1 + x \leq e^x$ using the Taylor series of $e^x$, we have:

$$
\begin{align*}
    \mathbb{E}[e^{\lambda X_i}]
    = p e^\lambda + (1 - p)
    = 1 + p (e^\lambda - 1)
    \leq e^{p (e^\lambda - 1)}.
\end{align*}
$$

Therefore, we have the bound:

$$
\begin{align*}
    \inf_{\lambda \geq 0} \left\{ e^{-\lambda t} \prod_{i=1}^n \mathbb{E}[e^{\lambda X_i}] \right\}
    \leq \inf_{\lambda \geq 0} \left\{ e^{-\lambda t} \prod_{i=1}^n e^{p (e^\lambda - 1)} \right\}
    = \inf_{\lambda \geq 0} \left\{ e^{-\lambda t + np (e^\lambda - 1)} \right\}.
\end{align*}
$$

Choose $t = (1 + \delta) np$ so that:

$$
\begin{align*}
    \mathbb{P}\left( X \geq (1 + \delta) np \right)
    \leq \inf_{\lambda \geq 0} \left\{ e^{-\lambda (1 + \delta) np + np (e^\lambda - 1)} \right\}.
\end{align*}
$$

We optimize this bound over $\lambda$ by taking the derivative and setting it equal to zero:

$$
\begin{align*}
    \left( -(1 + \delta) np + np e^\lambda \right) \left( e^{-\lambda (1 + \delta) np + np (e^\lambda - 1)} \right) = 0
    \implies -(1 + \delta) np + np e^\lambda = 0
    \implies \lambda = \log(1 + \delta).
\end{align*}
$$

Now, recall the given inequality for $\delta \geq 0$:

$$
\begin{align*}
    \frac{e^\delta}{(1 + \delta)^{1 + \delta}} \leq \exp\left( -\frac{\delta^2}{2 + \delta} \right).
\end{align*}
$$

Substituting this value of $\lambda$ and using the above inequality, we see that:

$$
\begin{align*}
    \inf_{\lambda \geq 0} \left\{ e^{-\lambda (1 + \delta) np + np (e^\lambda - 1)} \right\}
    \leq \frac{e^{\delta np}}{(1 + \delta)^{(1 + \delta) np}}
    \leq \exp\left( -\frac{\delta^2 np}{2 + \delta} \right)
    \leq \exp\left( -\frac{\delta^2 np}{3} \right).
\end{align*}
$$

This gives the first bound. Similarly, by independence of the $X_i$, the Chernoff bound gives:

$$
\begin{align*}
    \mathbb{P}(X \leq t)
     & = \mathbb{P}(-X \geq -t)                                                                                                      \\
     & \leq \inf_{\lambda \geq 0} \left\{ e^{\lambda t} \mathbb{E}[e^{-\lambda X}] \right\}                                          \\
     & = \inf_{\lambda \geq 0} \left\{ e^{\lambda t} \mathbb{E}\left[ \exp\left( -\lambda \sum_{i=1}^n X_i \right)  \right] \right\} \\
     & = \inf_{\lambda \geq 0} \left\{ e^{\lambda t} \prod_{i=1}^n \mathbb{E}[e^{-\lambda X_i}] \right\}.
\end{align*}
$$

However, because $1 + x \leq e^x$ using the Taylor series of $e^x$, we have:

$$
\begin{align*}
    \mathbb{E}[e^{-\lambda X_i}]
    = p e^{-\lambda} + (1 - p)
    = 1 + p (e^{-\lambda} - 1)
    \leq e^{p (e^{-\lambda} - 1)}.
\end{align*}
$$

Therefore, we have the bound:

$$
\begin{align*}
    \inf_{\lambda \geq 0} \left\{ e^{\lambda t} \prod_{i=1}^n \mathbb{E}[e^{-\lambda X_i}] \right\}
    \leq \inf_{\lambda \geq 0} \left\{ e^{\lambda t} \prod_{i=1}^n e^{p (e^{-\lambda} - 1)} \right\}
    = \inf_{\lambda \geq 0} \left\{ e^{\lambda t + np (e^{-\lambda} - 1)} \right\}.
\end{align*}
$$

Choose $t = (1 - \delta) np$ so that:

$$
\begin{align*}
    \mathbb{P}\left( X \leq (1 - \delta) np \right)
    \leq \inf_{\lambda \geq 0} \left\{ e^{\lambda (1 - \delta) np + np (e^{-\lambda} - 1)} \right\}.
\end{align*}
$$

We optimize this bound over $\lambda$ by taking the derivative and setting it equal to zero:

$$
\begin{align*}
    \left( (1 - \delta) np + np e^{-\lambda} \right) \left( e^{\lambda (1 - \delta) np + np (e^{-\lambda} - 1)} \right) = 0
    \implies (1 - \delta) np + np e^{-\lambda} = 0
    \implies \lambda = -\log(1 - \delta).
\end{align*}
$$

Now, recall the given inequality for $\delta \geq 0$:

$$
\begin{align*}
    \frac{e^\delta}{(1 + \delta)^{1 + \delta}} \leq \exp\left( -\frac{\delta^2}{2 + \delta} \right).
\end{align*}
$$

Substituting this value of $\lambda$ and using the above inequality, we see that:

$$
\begin{align*}
    \inf_{\lambda \geq 0} \left\{ e^{\lambda (1 + \delta) np + np (e^{-\lambda} - 1)} \right\}
    \leq \frac{e^{-\delta np}}{(1 - \delta)^{(1 - \delta) np}}
    \leq \exp\left( -\frac{\delta^2 np}{2 - \delta} \right)
    \leq \exp\left( -\frac{\delta^2 np}{2} \right).
\end{align*}
$$

These are the two bounds we wanted to show, so we are done; in fact, the proof shows that these bounds hold for all $\delta > 0$. Phew - that was step one. Now, back to the original problem.

## Proof of concentration inequality

First, notice that $\mathbb{P}(R_{k, \min} \leq t)$ is the probability of at least one of $R_k(X_i)$ being less than $t$ for $1 \leq i \leq n$. Therefore, the union bound gives:

$$
\begin{align*}
    \mathbb{P}(R_{k, \min} \leq t)
    = \mathbb{P}\left( \bigcup_{i=1}^n\ \{ R_k(X_i) \leq t \} \right)
    \leq \sum_{i=1}^n \mathbb{P}(R_k(X_i) \leq t).
\end{align*}
$$

In particular, it will suffice to show that there exists $a > 0$ depending only on $d$ such that for any $1 \leq i \leq n$:

$$
\begin{align*}
    \mathbb{P}\left( R_k(X_i) \leq a \left( \frac{k}{n} \right)^{\frac{1}{d}} \right) \leq e^{-k/3}.
\end{align*}
$$

But for any $1 \leq i \leq n$, we know that $\mathbb{P}(R_k(X_i) \leq t)$ is the probability of at least $k - 1$ of the remaining $n - 1$ points landing in $S = B_t(X_i) \cap [0, 1]^d$. However, the probability of any given point landing in $S$ is equal to the volume of $S$ (integrating against the uniform density), since $\mu([0, 1]^d) = 1$. We know that $\mu(S) \geq \frac{1}{2^d} \cdot \mu(B_t(X_i))$; recall the [volume](https://en.wikipedia.org/wiki/Volume_of_an_n-ball) of the $d$-ball:

$$
\begin{align*}
    \mu(B_t(X_i)) = \frac{\pi^d}{\Gamma\left( \frac{d}{2} + 1 \right)} \cdot t^d.
\end{align*}
$$

In particular, $\frac{1}{2^d} \cdot \mu(B_t(X_i)) = C_d t^d \leq \mu(S)$ for some positive constant $C_d$ depending only on the dimension $d$. Then, if $Y \sim \operatorname{Bin}(n - 1,\ C_d t^d)$:

$$
\begin{align*}
    \mathbb{P}(R_k(X_i) \leq t)
    \leq \mathbb{P}(Y \geq k - 1).
\end{align*}
$$

Then, note that, assuming $a$ is chosen so that $\delta \in (0, 1)$:

$$
\begin{align*}
    (1 + \delta) (n - 1) C_d t^d = k
    \iff \delta = \frac{k - 1}{(n - 1) C_d t^d} - 1
    \iff \delta = \frac{(k - 1) n}{k (n - 1) C_d a^d} - 1.
\end{align*}
$$

Recall that $\frac{x}{x - 1} \in [1, 2]$ for all $x \geq 2$. Then, we we can use the bound on binomial variables derived above to find that (substituting $t = a \left( \frac{k}{n} \right)^{\frac{1}{d}}$ and assuming that $a$ is chosen such that $\frac{1}{C_d a^d} \geq 1$):

$$
\begin{align*}
    \mathbb{P}(Y \geq k - 1)
     & \leq \exp\left( -\frac{1}{3} \left( \frac{\frac{n}{n - 1}}{\frac{k}{k - 1} C_d a^d} - 1 \right)^2 (n - 1) C_d t^d \right) \\
     & \leq \exp\left( -\frac{1}{3} \left( \frac{(1 - C_d a^d)}{2 C_d a^d} \right)^2 (n - 1) C_d t^d \right)                     \\
     & \leq \exp\left( -\frac{1}{3} \left( \frac{(1 - C_d a^d)}{2 C_d a^d} \right)^2 C_d a^d \frac{k}{2} \right).
\end{align*}
$$

Finally, choosing $a$ such that $\left( \frac{(1 - C_d a^d)}{2 C_d a^d} \right)^2 \cdot \frac{C_d a^d}{2} \geq 1$ gives the result:

$$
\begin{align*}
    \left( \frac{(1 - C_d a^d)}{2 C_d a^d} \right)^2 \cdot \frac{C_d a^d}{2}
    = \frac{1 - 2 C_d a^d + C_d^2 (a_d)^2}{8 C_d a^d}
    \geq 1
    \iff 1 - 10 C_d a^d + 2 C_d^2 (a^d)^2 \geq 0
\end{align*}
$$

But now we compute the roots of this quadratic:

$$
\begin{align*}
    1 - 10 C_d a^d + C_d^2 (a^d)^2 = 0
    \iff a^d
    = \frac{10 C_d \pm \sqrt{100 C_d^2 - 4 C_d^2}}{2}
    = \left( 5 \pm 2 \sqrt{6} \right) C_d.
\end{align*}
$$

Therefore, it suffices to choose $a = (\epsilon_d C_d)^{1/d}$ with $\epsilon_d$ chosen so that:

$$
\begin{align*}
    \epsilon_d < \min\left\{ 5 - 2 \sqrt{6},\ \frac{1}{2 C_d^2} \right\}.
\end{align*}
$$

This choice of $a$ satisfies $a^d < \left( 5 - 2 \sqrt{6} \right) C_d$ so that the quadratic $1 - 10 C_d a^d + 2 C_d^2 (a^d)^2 \geq 0$. Furthermore, $a$ satisfies $\frac{1}{C_d a^d} \geq \frac{1}{5 - 2 \sqrt{6}} \geq 1$. Notice that this value of $a$ also has:

$$
\begin{align*}
    \delta
    = \frac{(k - 1) n}{k (n - 1) \epsilon_d C_d^2} - 1
    \geq \frac{1}{2 \epsilon_d C_d^2} - 1
    > 0.
\end{align*}
$$

This proves the desired concentration inequality for $R_{k, \min}$; namely, for this value of $a$ we have:

$$
\begin{align*}
    \mathbb{P}\left( R_{k, \min} \leq a \left( \frac{k}{n} \right)^{\frac{1}{d}} \right)
    \leq \sum_{i=1}^n \mathbb{P}\left( R_k(X_i) \leq a \left( \frac{k}{n} \right)^{\frac{1}{d}} \right)
    \leq n e^{-k/3}.
\end{align*}
$$

Similarly, we obtain a bound on $R_{k, \max}$. First, notice that $\mathbb{P}(R_{k, \max} \geq t)$ is the probability of at least one of $R_k(X_i)$ being larger than $t$ for $1 \leq i \leq n$. Therefore, the union bound gives:

$$
\begin{align*}
    \mathbb{P}(R_{k, \max} \geq t)
    = \mathbb{P}\left( \bigcup_{i=1}^n\ \{ R_k(X_i) \geq t \} \right)
    \leq \sum_{i=1}^n \mathbb{P}(R_k(X_i) \geq t).
\end{align*}
$$

In particular, it will suffice to show that there exists $\tilde{a} > 0$ depending only on $d$ such that for any $1 \leq i \leq n$:

$$
\begin{align*}
    \mathbb{P}\left( R_k(X_i) \geq \tilde{a} \left( \frac{k}{n} \right)^{\frac{1}{d}} \right) \leq e^{-k/3}.
\end{align*}
$$

But for any $1 \leq i \leq n$, we know that $\mathbb{P}(R_k(X_i) \geq t)$ is the probability of at most $k - 2$ of the remaining $n - 1$ points landing in $S = B_t(X_i) \cap [0, 1]^d$. However, the probability of any given point landing in $S$ is equal to the volume of $S$ (integrating against the uniform density), since $\mu([0, 1]^d) = 1$. We know that $\mu(S) \leq \mu(B_t(X_i))$; recall the [volume](https://en.wikipedia.org/wiki/Volume_of_an_n-ball) of the $d$-ball:

$$
\begin{align*}
    \mu(B_t(X_i)) = \frac{\pi^d}{\Gamma\left( \frac{d}{2} + 1 \right)} \cdot t^d.
\end{align*}
$$

In particular, $\mu(S) \leq \mu(B_t(X_i)) = \tilde{C}_d t^d$ for some positive constant $\tilde{C}_d$ depending only on the dimension $d$. Then, if $Y \sim \operatorname{Bin}(n - 1,\ \tilde{C}_d t^d)$:

$$
\begin{align*}
    \mathbb{P}(R_k(X_i) \geq t)
    \leq \mathbb{P}(Y \leq k - 2)
    \leq \mathbb{P}(Y \leq k).
\end{align*}
$$

Then, substituting $t = \tilde{a} \left( \frac{k}{n} \right)^{\frac{1}{d}}$, note that if $\tilde{a}$ is chosen so that $\delta > 0$:

$$
\begin{align*}
    (1 - \delta) (n - 1) \tilde{C}_d t^d = k
    \iff \delta = 1 - \frac{k}{(n - 1) \tilde{C}_d t^d}
    \iff \delta = 1 - \frac{n}{(n - 1) \tilde{C}_d \tilde{a}^d}
\end{align*}
$$

Then, we we can use the bound derived above to find that (substituting $t = \tilde{a} \left( \frac{k}{n} \right)^{\frac{1}{d}}$ and assuming that $a$ is chosen such that $\frac{1}{\tilde{C}_d a^d} \geq 1$):

$$
\begin{align*}
    \mathbb{P}(Y \leq k)
     & \leq \exp\left( -\frac{1}{2} \left( \frac{n}{(n - 1) \tilde{C}_d \tilde{a}^d} - 1 \right)^2 (n - 1) \tilde{C}_d t^d \right)                                              \\
     & \leq \exp\left( -\frac{1}{2} \left( \frac{1 - \tilde{C}_d \tilde{a}^d}{\tilde{C}_d \tilde{a}^d} \right)^2 (n - 1) \tilde{C}_d t^d \right)                                \\
     & \leq \exp\left( -\frac{1}{3} \cdot \frac{3}{2} \left( \frac{1 - \tilde{C}_d \tilde{a}^d}{\tilde{C}_d \tilde{a}^d} \right)^2 \tilde{C}_d \tilde{a}^d \frac{k}{2} \right).
\end{align*}
$$

Finally, choosing $a$ such that $3 \left( \frac{1 - \tilde{C}_d \tilde{a}^d}{\tilde{C}_d \tilde{a}^d} \right)^2 \cdot \frac{\tilde{C}_d \tilde{a}^d}{4} \geq 1$ gives the result:

$$
\begin{align*}
    3 \left( \frac{1 - \tilde{C}_d \tilde{a}^d}{\tilde{C}_d \tilde{a}^d} \right)^2 \cdot \frac{\tilde{C}_d \tilde{a}^d}{4} \geq 1
    \iff \frac{(1 - \tilde{C}_d \tilde{a}^d)^2}{\tilde{C}_d \tilde{a}^d} \geq \frac{4}{3}
    \iff 1 - \frac{10}{3} \tilde{C}_d \tilde{a}^d + \tilde{C}_d^2 (\tilde{a}^d)^2 \geq 0.
\end{align*}
$$

But now we compute the roots of this quadratic:

$$
\begin{align*}
    1 - \frac{10}{3} \tilde{C}_d \tilde{a}^d + \tilde{C}_d^2 (\tilde{a}^d)^2 = 0
    \iff \tilde{a}^d
    = \frac{\frac{10}{3} \tilde{C}_d \pm \sqrt{\frac{100}{9} \tilde{C}_d^2 - 4 \tilde{C}_d^2}}{2}
    = \left( \frac{5}{3} \pm \frac{4}{3} \right) \tilde{C}_d.
\end{align*}
$$

Therefore, it suffices to choose $\tilde{a} = (\tilde{\epsilon}_d \tilde{C}_d)^{1/d}$ with $\tilde{\epsilon}_d$ chosen so that:

$$
\begin{align*}
    \tilde{\epsilon}_d < \min\left\{ \frac{1}{3},\ \frac{1}{2 \tilde{C}_d^2} \right\}.
\end{align*}
$$

This choice of $\tilde{a}$ satisfies $\tilde{a}^d < \frac{1}{3} \tilde{C}_d$ so that the quadratic $1 - \frac{10}{3} \tilde{C}_d \tilde{a}^d + \tilde{C}_d^2 (\tilde{a}^d)^2 \geq 0$. Furthermore, $a$ satisfies $\frac{1}{\tilde{C}_d a^d} \geq \frac{1}{5 - 2 \sqrt{6}} \geq 1$. Notice that this value of $a$ also has:

$$
\begin{align*}
    \delta
    = 1 - \frac{n}{(n - 1) \tilde{\epsilon}^d \tilde{C}_d^2}
    > 0.
\end{align*}
$$

This proves the desired concentration inequality for $R_{k, \max}$; namely, for this value of $\tilde{a}$ we have:

$$
\begin{align*}
    \mathbb{P}\left( R_{k, \max} \geq \tilde{a} \left( \frac{k}{n} \right)^{\frac{1}{d}} \right)
    \leq \sum_{i=1}^n \mathbb{P}\left( R_k(X_i) \geq \tilde{a} \left( \frac{k}{n} \right)^{\frac{1}{d}} \right)
    \leq n e^{-k/3}.
\end{align*}
$$

Finally, this shows the desired result.
