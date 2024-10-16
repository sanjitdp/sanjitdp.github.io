---
layout: note
title: Assorted hitting times of Brownian motion
date: 2023-06-27
author: Sanjit Dandapanthula
---

- TOC
{:toc}

This post will contain some calculations I've done for hitting times of Brownian motion. The purpose of writing out this post is to remind myself of some common tricks used for computations with Brownian motion, including the reflection principle and optional stopping theorem.

# Hitting time of a line

First, let $B(t)$ be a standard Brownian motion started at zero. If $\tau$ is the hitting time associated with $B(t)$ of a line $a + bt$ with $a > 0$ and $b > 0$, we'll calculate the moment generating function $\mathbb{E}[e^{-\lambda \tau}]$.

Fix $\lambda > 0$. We know that $M(t) = \exp\left( \alpha B(t) - \frac{\alpha^2 t}{2} \right)$ is the exponential martingale for any $\alpha \in \mathbb{R}$; in particular $M(t)$ is a martingale if $\alpha = b + \sqrt{b^2 + 2 \lambda} > 2b$. Furthermore, we know that for all $t \geq 0$ we have $B(t \wedge \tau) \leq a + b (t \wedge \tau)$ since $a > 0$ and $b > 0$ with:

$$
\begin{align*}
    \tau = \inf\{ t \geq 0 : B(t) = a + bt \}.
\end{align*}
$$

Therefore, we find that for all $t \geq 0$:

$$
\begin{align*}
    \lvert M(t \wedge \tau) \rvert
     & = \exp\left( \alpha B(t \wedge \tau) - \frac{\alpha^2 (t \wedge \tau)}{2} \right)                          \\
     & \leq \exp\left( \alpha (a + b (t \wedge \tau)) - \frac{\alpha^2 (t \wedge \tau)}{2} \right)                \\
     & = \exp\left( \alpha a + \alpha \left( b (t \wedge \tau) - \frac{\alpha (t \wedge \tau)}{2} \right) \right) \\
     & \leq \exp(\alpha a).
\end{align*}
$$

In particular, the $M(t \wedge \tau)$ are uniformly integrable and the optional stopping theorem gives:

$$
\begin{align*}
     & \mathbb{E}\left[ \exp\left( \alpha (a + b \tau) - \frac{\alpha^2 \tau}{2} \right) \right]
    = \mathbb{E}\left[ \exp\left( \alpha B(0) \right) \right]
    = 1                                                                                                             \\
     & \quad \implies \mathbb{E}\left[ \exp\left( \left( \alpha b - \frac{\alpha^2}{2} \right) \tau \right) \right]
    = e^{-\alpha a}.
\end{align*}
$$

Then, we substitute for $\alpha$ to find that for all $\lambda > 0$:

$$
\begin{align*}
    \mathbb{E}\left[ e^{-\lambda \tau} \right]
    = \exp\left( -a \left( b + \sqrt{b^2 + 2 \lambda} \right) \right).
\end{align*}
$$

This completes the desired calculation. Further, note that on the event $\lbrace \tau = +\infty \rbrace$, we have $e^{-\lambda \tau} = 0$. Therefore, we have for $\lambda > 0$:

$$
\begin{align*}
    \mathbb{E}[e^{-\lambda \tau}]
    = \mathbb{E}\left[ e^{-\lambda \tau};\ \tau < +\infty \right] + \mathbb{E}\left[ e^{-\lambda \tau};\ \tau = +\infty \right]
    = \mathbb{E}\left[ e^{-\lambda \tau};\ \tau < +\infty \right]
    = \exp\left( -a \left( b + \sqrt{b^2 + 2 \lambda} \right) \right).
\end{align*}
$$

But now notice that $0 < e^{-\lambda \tau} \leq 1$ is bounded uniformly for $\lambda > 0$ since $\tau \geq 0$. Therefore, we can use the dominated convergence theorem and the above calculation to take the limit as $\lambda \downarrow 0$ and compute using the law of total expectation:

$$
\begin{align*}
    \lim_{\lambda \downarrow 0} \mathbb{E}[e^{-\lambda \tau}]
     & = \mathbb{E}\left[ \lim_{\lambda \downarrow 0} e^{-\lambda \tau} \right]                      \\
     & = 1 \cdot \mathbb{P}(\tau < +\infty) + 0 \cdot \mathbb{P}(\tau = +\infty)                     \\
     & = \mathbb{P}(\tau < +\infty)                                                                  \\
     & = \lim_{\lambda \downarrow 0} \exp\left( -a \left( b + \sqrt{b^2 + 2 \lambda} \right) \right) \\
     & = \exp(-2 ab).
\end{align*}
$$

Hence, we have also calculated $\mathbb{P}(\tau < +\infty)$; namely, the probability that a standard Brownian motion ever hits the line $a + bt$. Pretty cool.

# Hitting time of the origin (delayed)

Let $X(t)$ denote a standard Brownian motion started at $x$ and let $\tau_1 = \inf\lbrace t > 0 : X(t) = 0 \rbrace$ and $\tau_2 = \inf\lbrace t > 1 : X(t) = 0 \rbrace$ (the delayed hitting time of the origin). We're going to write down an explicit formula for the density of $\tau_2$ using the reflection principle. First, notice that $$\mathbf{1}_{\lbrace \tau_2 \leq t \rbrace} = \mathbf{1}_{\lbrace \tau_1 \leq t - 1 \rbrace} \circ \theta_1$$, where $\theta_1$ denotes the shift operator. Therefore, using the law of total expectation and the Markov property for $Y = \mathbf{1}_{\lbrace \tau_1 \leq t - 1 \rbrace}$, we get:

$$
\begin{align*}
    P^x(\tau_2 \leq t)
     & = \mathbb{E}^x \left[ \mathbf{1}_{\{ \tau_2 \leq t \}} \right]                                                                    \\
     & = \mathbb{E}^x \left[ \mathbf{1}_{\{ \tau_1 \leq t - 1 \}} \circ \theta_1 \right]                                                 \\
     & = \mathbb{E}^x \left[ \mathbb{E}^x \left[ \mathbf{1}_{\{ \tau_1 \leq t - 1 \}} \circ \theta_1 \vert \mathcal{F}_1 \right] \right] \\
     & = \mathbb{E}^x \left[ \mathbb{E}^{X(1)} \left[ \mathbf{1}_{\{ \tau_1 \leq t - 1 \}} \right] \right]                               \\
     & = \mathbb{E}^x \left[ P^{X(1)}(\tau_1 \leq t - 1) \right]                                                                         \\
     & = \int_{-\infty}^\infty p_1(x, y) \cdot P^y(\tau_1 \leq t - 1)\ dy.
\end{align*}
$$

Therefore, we know that relative to $\mathbb{P}^0$, $\tau_2$ has density:

$$
\begin{align*}
    f(t)
    = \frac{d}{dt} \mathbb{P}^0(\tau_2 \leq t)
    = \frac{d}{dt} \int_{-\infty}^\infty p_1(0, y) \cdot \mathbb{P}^y(\tau_1 \leq t - 1)\ dy.
\end{align*}
$$

However, we also know by the reflection principle that:

$$
\begin{align*}
    \mathbb{P}^y(\tau_1 \leq t - 1)
    = \int_0^{t-1} \frac{\lvert y \rvert}{\sqrt{2 \pi z^3}} \exp\left( -\frac{y^3}{2z} \right)\ dz.
\end{align*}
$$

Furthermore, since for Brownian motion $B(1)$ is distributed like $\mathcal{N}(0, 1)$, we can write down a formula for the density $p_1(0, y)$:

$$
\begin{align*}
    p_1(0, y)
    = \frac{1}{\sqrt{2 \pi}} \exp\left( -\frac{y^2}{2} \right).
\end{align*}
$$

Putting all the pieces together, we obtain the integral:

$$
\begin{align*}
    f(t)
     & = \frac{d}{dt} \int_{-\infty}^\infty p_1(0, y) \cdot \mathbb{P}^y(\tau_1 \leq t - 1)\ dy                                                                                                                       \\
     & = \frac{d}{dt} \int_{-\infty}^\infty \frac{1}{\sqrt{2 \pi}} \exp\left( -\frac{y^2}{2} \right) \cdot \int_0^{t-1} \frac{\lvert y \rvert}{\sqrt{2 \pi z^3}} \exp\left( -\frac{y^3}{2z} \right)\ dz\ dy.
\end{align*}
$$

This becomes an explicit integral that can be evaluated using standard techniques; we could compute this integral when $t > 1$ and we would obtain the following density for $\tau_2$ relative to $P^0$:

$$
\begin{align*}
    f(t)
    = \frac{1}{\pi t \sqrt{t - 1}}.
\end{align*}
$$

# Hitting time of the origin (left drift)

Now, suppose we have a Feller process $X(t)$ with generator $\mathcal{L} f = \frac{1}{2} f^{\prime\prime} - f^\prime$ and associated domain $\mathcal{D}(\mathcal{L}) = C_c^2(\mathbb{R})$ (we'll show later that this is the generator of Brownian motion with drift to the left). Our goal is to compute the expected hitting time for $X(t)$ of the origin, but for now, let $\tau$ be the hitting time of $\lbrace a, b \rbrace$ with $a < X(0) < b$. Define a function $f \in C_c^\infty(\mathbb{R}) \supseteq C_c^2(\mathbb{R})$ which has $f(y) = y$ on $[a - 1, b + 1]$, decays to 0 smoothly in $[a - 2, a - 1]$ and $[b + 1, b + 2]$, and has $f(y) = 0$ outside of $[a - 2, b + 2]$. Then, we know that $f \in C_c^2(\mathbb{R}) = \mathcal{D}(\mathcal{L})$ so $f(X(t)) - \int_0^t \mathcal{L} f(X(s))\ ds$ is a $\mathbb{P}^x$-martingale for all $x \in \mathbb{R}$.

Substituting $t \mapsto \tau \wedge t$, this means that $f(X(\tau \wedge t)) - \int_0^{\tau \wedge t} \mathcal{L} f(X(s))\ ds$ is also a $\mathbb{P}^x$-martingale for all $x \in \mathbb{R}$ (this is the stopped martingale). But we know that $a \leq X(\tau \wedge t) \leq b$ since $a < X(0) < b$ and $\tau$ is the hitting time of $\lbrace a, b \rbrace$. Therefore, the following is a $\mathbb{P}^x$-martingale for all $x \in \mathbb{R}$ (since we have specified $f$ and all of its derivatives on $[a, b]$):

$$
\begin{align*}
    f(X(\tau \wedge t)) - \int_0^{\tau \wedge t} \mathcal{L} f(X(s))\ ds
     & = f(X(\tau \wedge t)) - \int_0^{\tau \wedge t} \left( \frac{1}{2} f^{\prime\prime}(X(s)) - f^\prime(X(s)) \right)\ ds \\
     & = X(\tau \wedge t) + \int_0^{\tau \wedge t}\ ds                                                                       \\
     & = X(\tau \wedge t) + (\tau \wedge t).
\end{align*}
$$

Now, let $\tau$ be the hitting time of $\lbrace 0, R \rbrace$ for large $R > x$. Using the optional stopping theorem on the martingale described above, we have (since $\tau \wedge t \leq t$ is bounded):

$$
\begin{align*}
    \mathbb{E}^x[X(\tau \wedge t) + (\tau \wedge t)] = \mathbb{E}^x[X(0)] = x.
\end{align*}
$$

Then, since $X(\tau \wedge t) \in [0, R]$ is bounded, we can use the monotone convergence theorem to take the limit as $t \uparrow \infty$ and find that $\tau \in L^1(\mathbb{P}^x)$. Furthermore, we know that for all $t \geq 0$:

$$
\begin{align*}
    \mathbb{E}^x[\lvert X(\tau \wedge t) + (\tau \wedge t) \rvert]
    \leq \mathbb{E}^x[\lvert X(\tau \wedge t) \rvert] + \mathbb{E}^x[\lvert \tau \wedge t \rvert]
    \leq R + \mathbb{E}^x[\tau].
\end{align*}
$$

This shows that the martingale described above is uniformly integrable. Another application of the optional stopping theorem using the stopping time $\tau$ gives:

$$
\begin{align*}
    \mathbb{E}^x[X(\tau) + \tau] = \mathbb{E}^x[X(0)] = x
    \implies \mathbb{E}^x[\tau] = x - \mathbb{E}^x[X(\tau)].
\end{align*}
$$

Then, if $p_R$ is the probability of $X(t)$ hitting $R$ before 0, this reduces to (using the law of total expectation and the fact that $\tau$ is the hitting time of $\lbrace 0, R \rbrace$):

$$
\begin{align*}
    \mathbb{E}^x[\tau]
    = x - \mathbb{E}^x[X(\tau)]
    = x - R \cdot p_R.
\end{align*}
$$

Now we're going to take $R \to +\infty$ and show that $p_R$ decays superlinearly. Notice that $X(t) = B(t) + x - t$, where $B(t)$ is a standard Brownian motion; we'll show this by computing the transition semigroup and then the generator. For $f \in C_c^2(\mathbb{R})$, by Taylor's theorem we have (for some function $h$ which has $\lim_{y \to x} h(y) = 0$):

$$
\begin{align*}
     & T_X(t) f(x)                                                                                                                                                                              \\
     & \quad = \mathbb{E}^x[f(B(t) - t)]                                                                                                                                                        \\
     & \quad = f(x) + f^\prime(x) \cdot \mathbb{E}^x[(B(t) - t - x)] + \frac{1}{2} f^{\prime\prime}(x) \cdot \mathbb{E}^x[(B(t) - t - x)^2] + \mathbb{E}^x[h(B(t) - t) \cdot (B(t) - t - x)^2].
\end{align*}
$$

We know that $\mathbb{E}^x[B(t) - x] = 0$ and $\mathbb{E}^x[(B(t) - x)^2] = t$, so (since shifting doesn't change variance) the above reduces to:

$$
\begin{align*}
     & f(x) + f^\prime(x) \cdot \mathbb{E}^x[(B(t) - t - x)] + \frac{1}{2} f^{\prime\prime}(x) \cdot \mathbb{E}^x[(B(t) - t - x)^2] + \mathbb{E}^x[h(B(t) - t) \cdot (B(t) - t - x)^2]. \\
     & \quad = f(x) - t \cdot f^\prime(x) + \frac{t}{2} f^{\prime\prime}(x) + \mathbb{E}^x[h(B(t) - t) \cdot (B(t) - t - x)^2].
\end{align*}
$$

Recall that we've computed $\mathbb{E}^x[(B(t) - t - x)^2] = O(t)$. Since $h(B(t) - t) \to 0$ as $t \downarrow 0$ for a Brownian motion $B(t)$ started at $x$, we know that $\frac{1}{t} \cdot \mathbb{E}^x[h(B(t) - t) \cdot (B(t) - t - x)^2] \to 0$ as $t \downarrow 0$. Therefore, we have:

$$
\begin{align*}
    \mathcal{L}_X f(x)
    = \lim_{t \downarrow 0} \frac{T(t) f(x) - f(x)}{t}
    = \frac{1}{2} f^{\prime\prime}(x) - f^\prime(x).
\end{align*}
$$

Okay, the generators match, so we know the underlying process. Now, we want to control the probability that $X(t)$ hits $R$ before 0. But if $B(t) + x$ hasn't hit $R$ by time $R$, we know that $X(t) = B(t) + x - t$ has definitely hit 0 before $R$ (this is a sort of coupling argument). By symmetry and shift-invariance of Brownian motion, the probability of this is the same as the probability of $B(t) + R - x$ hitting 0 before time $R$. Let $\tau_0$ be the hitting time of 0 for a Brownian motion. By the reflection principle, we can actually bound this probability explicitly:

$$
\begin{align*}
    p_R
    \leq \mathbb{P}^{R - x}(\tau_0 < R)
    = \int_0^R \frac{R - x}{\sqrt{2 \pi z^3}} \cdot \exp\left( -\frac{(R - x)^2}{2z} \right)\ dz.
\end{align*}
$$

Substituting $u = \frac{R - x}{\sqrt{z}} \implies du = -\frac{R - x}{2 z^{3/2}}\ dz$, we get:

$$
\begin{align*}
    \int_0^R \frac{R - x}{\sqrt{2 \pi z^3}} \cdot \exp\left( -\frac{(R - x)^2}{2z} \right)\ dz
    = \sqrt{\frac{2}{\pi}} \cdot \int_{\frac{R - x}{\sqrt{R}}}^\infty \exp\left( -\frac{u^2}{2} \right)\ du.
\end{align*}
$$

Assume $R$ is such that $\max\lbrace 2x, 4 \rbrace \leq R$ so that $\frac{R}{2} \leq R - x$ and $\frac{\sqrt{R}}{2} \geq 1$. Then, we have:

$$
\begin{align*}
    \sqrt{\frac{2}{\pi}} \cdot \int_{\frac{R - x}{\sqrt{R}}}^\infty \exp\left( -\frac{u^2}{2} \right)\ du
    \leq \sqrt{\frac{2}{\pi}} \cdot \int_{\frac{\sqrt{R}}{2}}^\infty \exp\left( -\frac{u^2}{2} \right)\ du
    \leq \sqrt{\frac{2}{\pi}} \cdot \int_{\frac{\sqrt{R}}{2}}^\infty u \cdot \exp\left( -\frac{u^2}{2} \right)\ du.
\end{align*}
$$

Now substitute $v = \frac{u^2}{2} \implies dv = u\ du$ so that:

$$
\begin{align*}
    \sqrt{\frac{2}{\pi}} \cdot \int_{\frac{\sqrt{R}}{2}}^\infty u \cdot \exp\left( -\frac{u^2}{2} \right)\ du
    = \sqrt{\frac{2}{\pi}} \cdot \int_{\frac{R}{8}}^\infty \exp(-v)\ dv
    = \sqrt{\frac{2}{\pi}} \left[ -e^{-v} \right]_{v=R/8}^{v \to \infty}
    = \sqrt{\frac{2}{\pi}} \cdot e^{-R/8}.
\end{align*}
$$

Equipped with this crude bound, we now know that $R \cdot p_R \leq \sqrt{\frac{2}{\pi}} \cdot R e^{-R/8}$. Taking the limit as $R \to \infty$, we deduce that $R \cdot p_R \to 0$; in particular, if $\tau$ is the hitting time for $X(t)$ of the origin, then we have $\mathbb{E}^x[\tau] = x$.

# Exit time of a ball

Now, suppose $X(t)$ is a multi-dimensional Brownian motion started at $x \in \mathbb{R}^n$ with $\lVert x \rVert_2 < r$. We want to calculate the expected time for this Brownian motion to leave $D = \lbrace y \in \mathbb{R}^n : \lVert y \rVert_2 < r \rbrace$ (the ball of radius $r$ centered at the origin). Recall that $B(t)^2 - t$ is the quadratic martingale associated to a Brownian motion $B(t)$. In particular, $\lVert X(t) \rVert_2^2 - nt = \sum_{i=1}^n (X_i(t)^2 - t)$ is the sum of $n$ independent martingales so it is also a martingale. By the optional stopping theorem, since $\tau_D \wedge t \leq t$ is bounded, we have:

$$
\begin{align*}
    \mathbb{E}^x[\lVert X(\tau_D \wedge t) \rVert_2^2 - n \cdot (\tau_D \wedge t)] = \mathbb{E}^x[\lVert X(0) \rVert_2^2 - n \cdot 0] = \lVert x \rVert_2^2.
\end{align*}
$$

It's clear that $\tau_D < +\infty$ almost surely since each coordinate of $X$ is a Brownian motion which takes arbitrarily large values almost surely. But we know that $\lVert X(\tau_D \wedge t) \rVert_2^2 \leq r^2$ since $\tau_D$ is the hitting time of $D^c = \lbrace y \in \mathbb{R}^n : \lVert y \rVert_2 \geq r \rbrace$. Therefore, by the dominated convergence theorem (along with continuity of norm and continuity of sample paths of Brownian motion):

$$
\begin{align*}
    \lim_{t \to \infty}\ \mathbb{E}^x[\lVert X(\tau_D \wedge t) \rVert_2^2]
    = \mathbb{E}^x[\lVert X(\tau_D) \rVert_2^2]
    = r^2.
\end{align*}
$$

Furthermore, since $(\tau_D \wedge t) \uparrow \tau_D$ almost surely as $t \to \infty$, an application of the monotone convergence theorem gives:

$$
\begin{align*}
    \lim_{t \to \infty}\ \mathbb{E}^x[n \cdot (\tau_D \wedge t)]
    = n \cdot \mathbb{E}^x[\tau_D].
\end{align*}
$$

Therefore, taking limits in our original equation gives:

$$
\begin{align*}
    \lim_{t \to \infty}\ (\mathbb{E}^x[\lVert X(\tau_D \wedge t) \rVert_2^2 - n \cdot (\tau_D \wedge t)])
    = r^2 - n \cdot \mathbb{E}^x[\tau_D]
    = \lVert x \rVert_2^2
    \implies \mathbb{E}^x[\tau_D] = \frac{r^2 - \lVert x \rVert_2^2}{n}.
\end{align*}
$$

To be honest, when I first learned about optional stopping, it was a little lost on me exactly why this theorem is useful in the first place. These problems (among others) taught me that the optional stopping theorem is a really powerful way to reason about hitting times of martingales and perform explicit computations. Additionally, the reflection principle (despite only capturing the simplest intuition about up-down symmetry) also turns out to be a great way to compute statistics about Brownian motion and its relatives.
