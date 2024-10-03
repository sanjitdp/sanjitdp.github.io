---
layout: note
title: Noninformative priors and Bayesian statistics
date: 2023-08-11
categories: [bayesian-statistics]
tags: [statistics, bayesian-statistics, noninformative-prior, jeffreys-prior, real-analysis]
math: true
comments: true
---

In this post, I want to write about an interesting computation I did using Bayesian statistics. I thought this example was particularly cool because it involves the beta distribution in a surprising way.

## Noninformative priors

Under the [Bayesian paradigm](https://en.wikipedia.org/wiki/Bayesian_statistics), the statistician assumes a [likelihood function](https://en.wikipedia.org/wiki/Likelihood_function) $f(x \vert \theta)$ which gives the probability of observing some data $x$ given an unknown parameter $\theta$. Furthermore, the statistician needs to quantify their initial belief by placing a [prior probability distribution](https://en.wikipedia.org/wiki/Prior_probability) $p(\theta)$ on the unknown parameter $\theta$. Then, Bayes' rule gives the update for this belief about $\theta$:

$$
\begin{align*}
    p(\theta \vert x) = \frac{f(x \vert \theta) \cdot p(\theta)}{p(x)}.
\end{align*}
$$

Here, $p(x)$ denotes the probability of observing $x$. The problem of finding a noninformative prior is to somehow systematically describe a prior belief when don't have any particularly strong beliefs about the unknown parameter $\theta$. Some statisticians argue against the use of noninformative priors, since part of the philosophy of Bayesian statistics is to clearly and honestly state one's prior beliefs about the unknown. On the other hand, uninformed priors are very useful and often quicker to use than a more reasoned approach would have been.

Well, it might intuitively seem that a uniform distribution is the best prior when we have no information about the prior; this was [Laplace's original idea](https://www2.stat.duke.edu/courses/Fall11/sta114/jeffreys.pdf). After all, saying that each value is as likely as any other appears to convey no information at all about the parameter. But notice that if we specify $\theta \sim \operatorname{Unif}(0, 1)$, for instance, then the reparametrization $\frac{1}{\theta}$ does not have a uniform distribution (in fact, it has the [inverse uniform](https://en.wikipedia.org/wiki/Inverse_distribution) distribution).

Hmm... so we have actually placed a nontrivial belief on $\frac{1}{\theta}$, despite not placing any on $\theta$ itself. This is strange, but it gives rise to Jeffreys' idea: any good noninformative prior should be invariant under smooth monotone transformations of the parameter.

Let $\mathcal{I}(\theta) = -\mathbb{E}_X\left[ \frac{\partial^2}{\partial \theta^2} \log(f(x \vert \theta)) \right]$ denote the [Fisher information](https://en.wikipedia.org/wiki/Fisher_information); this measures the curvature of the likelihood function and therefore the amount of information that $X$ carries about the unknown $\theta$. Then, it can be shown that choosing $p(\theta) \propto \sqrt{\mathcal{I}(\theta)}$ satisfies the invariance condition. This choice of $p(\theta)$ is known as the [Jeffreys prior](https://en.wikipedia.org/wiki/Jeffreys_prior), and most modern Bayesian statisticians agree that this is generally a better choice for a noninformative prior than Laplace's choice of the uniform distribution.

## Binomial noninformative prior

As an example, we'll compute the Jeffreys noninformative prior for the success probability $\theta$ where $X \sim \operatorname{Bin}(n, \theta)$ is a binomial random variable. We know since $X \sim \operatorname{Bin}(n, \theta)$ that:

$$
\begin{align*}
    p(X = x \lvert \theta) = \binom{n}{x} \cdot \theta^x (1 - \theta)^{n - x}.
\end{align*}
$$

Therefore, we compute the log-likelihood function:

$$
\begin{align*}
    \log(p(X = x \lvert \theta))
    = \log(n!) - \log(x!) - \log((n - x)!) + x \log(\theta) + (n - x) \log(1 - \theta).
\end{align*}
$$

Then, we take the derivative:

$$
\begin{align*}
    \frac{\partial}{\partial \theta} \log(p(X = x \lvert \theta))
    = \frac{x}{\theta} - \frac{n - x}{1 - \theta}.
\end{align*}
$$

Taking the second derivative, we find:

$$
\begin{align*}
    \frac{\partial^2}{\partial \theta^2} \log(p(X = x \lvert \theta))
    = -\frac{x}{\theta^2} - \frac{n - x}{(1 - \theta)^2}.
\end{align*}
$$

We know that the expectation of $X \sim \operatorname{Bin}(n, \theta)$ is $\mathbb{E}[X] = n \theta$. Therefore, by linearity of expectation:

$$
\begin{align*}
    -\mathbb{E}_X\left[ \frac{\partial^2}{\partial \theta^2} \log(f(X \lvert \theta)) \right]
    = \mathbb{E}_X\left[ \frac{X}{\theta^2} + \frac{n - X}{(1 - \theta)^2} \right]
    = \frac{n \theta}{\theta^2} + \frac{n - n \theta}{(1 - \theta)^2}
    = \frac{n}{\theta (1 - \theta)}.
\end{align*}
$$

Then, recall that the Jeffreys uninformed prior has $p(\theta) \propto \sqrt{\mathcal{I}(\theta)}$ where $\mathcal{I}(\theta)$ is the expected Fisher information:

$$
\begin{align*}
    I(\theta)
    = -\mathbb{E}_X\left[ \frac{\partial^2}{\partial \theta^2} \log(f(X \lvert \theta)) \right]
    = \frac{n}{\theta (1 - \theta)}.
\end{align*}
$$

In particular, $p(\theta) \propto \theta^{-\frac{1}{2}} (1 - \theta)^{-\frac{1}{2}}$. In particular, this means that the uninformed prior $p(\theta)$ follows the [beta distribution](https://en.wikipedia.org/wiki/Beta_distribution) $\operatorname{Be}\left( \frac{1}{2},\ \frac{1}{2} \right)$.

## Marginal distribution with beta prior

Now, suppose our prior for $\theta$ is $p(\theta) \sim \operatorname{Be}(\alpha, \beta)$. Let's compute the associated marginal distribution of $X \sim \operatorname{Bin}(n, \theta)$. We compute the prior distribution of $X$ directly, where $B(\alpha, \beta) = \frac{\Gamma(\alpha) \Gamma(\beta)}{\Gamma(\alpha + \beta)}$ is the [beta function](https://en.wikipedia.org/wiki/Beta_function) and $\Gamma$ denotes the [gamma function](https://en.wikipedia.org/wiki/Gamma_function):

$$
\begin{align*}
    p(X = x)
     & = \int_0^1 p(X = x \lvert \theta) \cdot p(\theta)\ d\theta                                                                                      \\
     & = \int_0^1 \binom{n}{x} \cdot \theta^x (1 - \theta)^{n - x} \cdot \frac{\theta^{\alpha - 1} (1 - \theta)^{\beta - 1}}{B(\alpha, \beta)}\ d\theta \\
     & = \binom{n}{x} \frac{1}{B(\alpha, \beta)} \int_0^1 \theta^{x + \alpha - 1} (1 - \theta)^{n - x + \beta - 1}\ d\theta.
\end{align*}
$$

But now recall that the density for $Y \sim \operatorname{Be}(x + \alpha, n - x + \beta)$ is:

$$
\begin{align*}
    p(Y = \theta) = \frac{\theta^{x + \alpha - 1} (1 - \theta)^{n - x + \beta - 1}}{B(x + \alpha, n - x + \beta)}.
\end{align*}
$$

Since the density of $Y$ integrates to 1, the above integral evaluates to $B(x + \alpha, n - x + \beta)$:

$$
\begin{align*}
    \binom{n}{x} \frac{1}{B(\alpha, \beta)} \int_0^1 \theta^{x + \alpha - 1} (1 - \theta)^{n - x + \beta - 1}\ d\theta
    = \binom{n}{x} \frac{B(x + \alpha, n - x + \beta)}{B(\alpha, \beta)}.
\end{align*}
$$

This is the marginal distribution we needed to compute.

## Constant marginal distribution

Consider the setup of the previous section. In this section, we would like to answer the question, when is the marginal distribution constant? In fact, we will show that the marginal $p(X = x)$ is constant if and only if $\alpha = \beta = 1$. First, we know that since $X \sim \operatorname{Bin}(n, \theta)$:

$$
\begin{align*}
    \mathbb{E}[X] = \mathbb{E}_\theta[\mathbb{E}[X \vert \theta]] = \mathbb{E}[n \theta] = n \mathbb{E}[\theta].
\end{align*}
$$

On the other hand, since $\theta \sim \operatorname{Be}(\alpha, \beta)$:

$$
\begin{align*}
    \mathbb{E}[\theta]
    = \frac{1}{B(\alpha, \beta)} \int_0^1 \theta^\alpha (1 - \theta)^{\beta - 1}\ d\theta.
\end{align*}
$$

But now recall that the density for $Y \sim \operatorname{Be}(\alpha + 1, \beta)$ is:

$$
\begin{align*}
    p(Y = \theta) = \frac{\theta^{\alpha} (1 - \theta)^{\beta - 1}}{B(\alpha + 1, \beta)}.
\end{align*}
$$

Since the density of $Y$ integrates to 1, we can compute the integral:

$$
\begin{align*}
    \frac{1}{B(\alpha, \beta)} \int_0^1 \theta^\alpha (1 - \theta)^{\beta - 1}\ d\theta
    = \frac{B(\alpha + 1, \beta)}{B(\alpha, \beta)}
    = \frac{\Gamma(\alpha + 1) \Gamma(\beta)}{\Gamma(\alpha + \beta + 1)} \cdot \frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha) \Gamma(\beta)}.
\end{align*}
$$

Using the recurrence relation $\Gamma(x + 1) = x \cdot \Gamma(x)$, we find:

$$
\begin{align*}
    \frac{\Gamma(\alpha + 1) \Gamma(\beta)}{\Gamma(\alpha + \beta + 1)} \cdot \frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha) \Gamma(\beta)}
    = \frac{\alpha}{\alpha + \beta}.
\end{align*}
$$

Hence, we deduce that $\mathbb{E}[X] = \frac{n \alpha}{\alpha + \beta}$. However, if $p(X = x)$ is constant for $0 \leq x \leq n$, then we know that $X$ has density $p(X = x) = \frac{1}{n + 1}$ for $0 \leq x \leq n$. If this is true, the expectation must also be:

$$
\begin{align*}
    \mathbb{E}[X]
    = \sum_{x = 0}^n \frac{x}{n + 1}
    = \frac{n (n + 1)}{2 (n + 1)}
    = \frac{n}{2}.
\end{align*}
$$

This means that:

$$
\begin{align*}
    \frac{n \alpha}{\alpha + \beta} = \frac{n}{2}
    \implies 2 \alpha = \alpha + \beta
    \implies \alpha = \beta.
\end{align*}
$$

Using the prior distribution for $X$ which we computed in the previous section, we know that for $0 \leq x \leq n$ (by the recurrence relation for $\Gamma(x)$):

$$
\begin{align*}
    p(X = x)
     & = \binom{n}{x} \frac{B(x + \alpha, n - x + \beta)}{B(\alpha, \beta)}                                                                                                                        \\
     & = \binom{n}{x} \frac{\Gamma(x + \alpha) \Gamma(n - x + \beta)}{\Gamma(n + \alpha + \beta)} \cdot \frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha) \Gamma(\beta)}                                \\
     & = \binom{n}{x} \frac{(x - 1 + \alpha) \cdots (1 + \alpha) \alpha \cdot (n - x - 1 + \beta) \cdots (1 + \beta) \beta}{(n - 1 + \alpha + \beta) \cdots (1 + \alpha + \beta) (\alpha + \beta)} \\
     & = \frac{1}{n + 1}.
\end{align*}
$$

Then, choosing $x = 0$ in the above equation, we have:

$$
\begin{align*}
    \frac{(n - 1 + \alpha) \cdots (1 + \alpha) \alpha}{(n - 1 + 2 \alpha) \cdots (1 + 2 \alpha) 2 \alpha} = \frac{1}{n + 1}
    \implies \frac{n + 1}{2} \cdot \frac{(n - 1 + \alpha) \cdots (1 + \alpha)}{(n - 1 + 2 \alpha) \cdots (1 + 2 \alpha)} = 1.
\end{align*}
$$

We're going to get a bound on this fraction. First, define the function $g : \mathbb{R}^+ \to \mathbb{R}$ by $g(z) = \frac{r + z}{r + 2z}$, where $r > 0$. Then, we have:

$$
\begin{align*}
    g^\prime(z)
    = \frac{r + 2z - 2 (r + z)}{(r + 2z)^2}
    = -\frac{r}{(r + 2z)^2}
    < 0.
\end{align*}
$$

In particular, $g$ is strictly decreasing on $\mathbb{R}^+$. Suppose for a contradiction that $\alpha = \beta > 1$. Since $\alpha > 1$, this means that $\frac{r + \alpha}{r + 2 \alpha} < \frac{r + 1}{r + 2}$ for all $r \in \mathbb{N}$:

$$
\begin{align*}
    \frac{n + 1}{2} \cdot \frac{(n - 1 + \alpha) \cdots (1 + \alpha)}{(n - 1 + 2 \alpha) \cdots (1 + 2 \alpha)}
    < \frac{n + 1}{2} \cdot \frac{n}{n + 1} \cdots \frac{3}{4} \cdot \frac{2}{3}
    = \frac{n + 1}{2} \cdot \frac{2}{n + 1}
    = 1.
\end{align*}
$$

This gives the desired contradiction. Similarly, when $\alpha = \beta < 1$, we know that $\frac{r + \alpha}{r + 2 \alpha} > \frac{r + 1}{r + 2}$ for all $r \in \mathbb{N}$ since $g$ is strictly decreasing on $\mathbb{R}^+$. Therefore, we have:

$$
\begin{align*}
    \frac{n + 1}{2} \cdot \frac{(n - 1 + \alpha) \cdots (1 + \alpha)}{(n - 1 + 2 \alpha) \cdots (1 + 2 \alpha)}
    > \frac{n + 1}{2} \cdot \frac{n}{n + 1} \cdots \frac{3}{4} \cdot \frac{2}{3}
    = \frac{n + 1}{2} \cdot \frac{2}{n + 1}
    = 1.
\end{align*}
$$

Again, this gives a contradiction. Finally, assume $\alpha = \beta = 1$. Then, we know by the above calculation that the prior distribution of $X$ is given by:

$$
\begin{align*}
    p(X = x)
    = \binom{n}{x} \frac{(x - 1 + \alpha) \cdots (1 + \alpha) \alpha \cdot (n - x - 1 + \beta) \cdots (1 + \beta) \beta}{(n - 1 + \alpha + \beta) \cdots (1 + \alpha + \beta) (\alpha + \beta)}
    = \frac{n!}{x! (n - x)!} \frac{x! (n - x)!}{(n + 1)!}
    = \frac{1}{n + 1}.
\end{align*}
$$

Hence, we deduce that $p(X = x)$ is constant for $0 \leq x \leq n$ if and only if $\alpha = \beta = 1$; this is what we needed to show.
