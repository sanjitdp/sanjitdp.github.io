---
layout: note
title: The sub-Gaussian distributional Johnson-Lindenstrauss lemma 
date: 2023-12-07
author: Sanjit Dandapanthula
---

- TOC
{:toc}

In this note, I'll discuss a version of the [distributional Johnson-Lindenstrauss lemma](https://en.wikipedia.org/wiki/Johnson%E2%80%93Lindenstrauss_lemma) (DJL lemma) with a sub-Gaussian assumption. The DJL lemma provides a randomized algorithm used to find low-distortion embeddings for data and has shares similarities with many results in [compressed sensing](https://en.wikipedia.org/wiki/Compressed_sensing). For instance, the DJL lemma is very similar to the [restricted isometry property](https://en.wikipedia.org/wiki/Restricted_isometry_property) (RIP), which is famously sufficient to ensure success of the [basis pursuit](https://en.wikipedia.org/wiki/Basis_pursuit) linear program for [exact recovery of sparse signals](https://arxiv.org/pdf/math/0410542.pdf).

I originally learned about the DJL lemma from Prof. [Jelani Nelson](https://people.eecs.berkeley.edu/~minilek/) during my participation in an REU with him in 2022. Prof. Nelson is an expert in this field -- in fact, he proved the [optimality of the JL lemma bound](https://arxiv.org/pdf/1609.02094.pdf) in 2017.

# Introduction

The setup of the problem is as follows: fix $\epsilon > 0$ and $\delta > 0$. Suppose we have a set of points $u_1, u_2, \cdots, u_N \in \mathbb{R}^d$ and let $X = \frac{Z}{\sqrt{m}}$ where $Z \in \mathbb{R}^{m \times d}$ has independent zero-mean, unit-variance, and [sub-Gaussian](https://en.wikipedia.org/wiki/Sub-Gaussian_distribution) entries. Then, if $m$ is chosen large enough (we'll make this more precise soon), the DJL lemma gives the following bound for all $i \neq j$, with probability at least $1 - \epsilon$:

$$
\begin{align*}
    (1 - \delta) \lVert u_i - u_j \rVert _2^2 \leq \lVert X (u_i - u_j) \rVert _2^2 \leq (1 + \delta) \lVert u_i - u_j \rVert _2^2.
\end{align*}
$$

This means that $X$ actually preserves distances between the original $u_i$ (to some extent) despite reducing the dimension of the data. Furthermore, we can explicitly compute $X$ without any dependence on the vectors $u_i$ by random sampling. Before showing this result, let's show a basic fact about sub-Gaussian random variables.

Note that many kernel methods from statistical learning (such as the [$k$-nearest neighbors](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm) clustering) depend only on the pairwise distances between data points. As a result, the Johnson-Lindenstrauss lemma is very helpful in these instances -- take a dataset with high dimension, apply DJL to reduce dimension while preserving pairwise distances, and run your favorite $k$-NN algorithm more efficiently in a lower dimension.

In fact, it's even better than that! Suppose we've used the DJL lemma to reduce the dimension of our dataset, but we suddenly get 20 new data points. We don't even need to do very much re-computation, since the matrix $X$ has no dependence on the data. Instead, we just compute $X u_i$ for each of our 20 new data points, and our pre-computed projections all still work. Additionally, if $X$ is sparse, it becomes even quicker to compute these projections. In particular, the algorithmic efficiency of applying the DJL lemma makes it a good choice when working with big data.

# Sub-Gaussian variance bound

Suppose that $X$ is sub-Gaussian with parameter $\sigma$; this is equivalent to the bound $\mathbb{E}[e^{\lambda X}] \leq e^{\sigma^2 \lambda^2 / 2}$ on the moment-generating function. First, Jensen's inequality gives $e^{\lambda \mathbb{E}[X]} \leq \mathbb{E}[e^{\lambda X}] \leq e^{\sigma^2 \lambda^2 / 2}$, so taking the logarithm gives:

$$
\begin{align*}
    \lambda \mathbb{E}[X] \leq \frac{\sigma^2 \lambda^2}{2}.
\end{align*}
$$

When $\lambda > 0$, this means that $\mathbb{E}[X] \leq \frac{\sigma^2 \lambda}{2}$ and when $\lambda < 0$, this means that $\mathbb{E}[X] \geq \frac{\sigma^2 \lambda}{2}$. Taking the limit as $\lambda \to 0$ from above and below respectively gives $\mathbb{E}[X] = 0$. Then, we expand both sides as a Taylor series when $\lambda \neq 0$ (using that $\mathbb{E}[X] = 0$):

$$
\begin{align*}
     & \mathbb{E}[e^{\lambda X}]
    = \mathbb{E}\left[ \sum_{k=0}^\infty \frac{\lambda^k X^k}{k!} \right]
    = \sum_{k=0}^\infty \frac{\lambda^k \cdot \mathbb{E}[X^k]}{k!}
    \leq \sum_{k=0}^\infty \frac{\sigma^{2k} \lambda^{2k}}{2^k k!}
    = e^{\sigma^2 \lambda^2 / 2}                                                   \\
     & \quad \implies \sum_{k=2}^\infty \frac{\lambda^k \cdot \mathbb{E}[X^k]}{k!}
    \leq \sum_{k=1}^\infty \frac{\sigma^{2k} \lambda^{2k}}{2^k k!}
    \implies \sum_{k=2}^\infty \frac{\lambda^{k-2} \cdot \mathbb{E}[X^k]}{k!}
    \leq \sum_{k=1}^\infty \frac{\sigma^{2k} \lambda^{2k-2}}{2^k k!}.
\end{align*}
$$

Then, taking the limit as $\lambda \to 0$ gives:

$$
\begin{align*}
    \frac{\mathbb{E}[X^2]}{2} \leq \frac{\sigma^2}{2}
    \implies \mathbb{E}[X^2] \leq \sigma^2.
\end{align*}
$$

This is the desired inequality.

# Johnson-Lindenstrauss Lemma

First, we'll show that if $z \in \mathbb{R}^d$ is a random vector with independent components, each zero-mean and sub-Gaussian with parameter $\sigma_i \leq 1$, then $\langle z, v \rangle$ is sub-Gaussian with parameter 1 for any unit vector $v \in \mathbb{R}^d$. To see this, note that:

$$
\begin{align*}
    \mathbb{E}[e^{\lambda \langle z, v \rangle}]
    = \mathbb{E}[e^{\lambda \sum_{i=1}^d z_i v_i}]
    = \prod_{i=1}^d \mathbb{E}[e^{\lambda z_i v_i}]
    \leq \prod_{i=1}^d e^{\lambda^2 \sigma_i^2 / 2}
    = \exp\left( \frac{\lambda^2}{2} \sum_{i=1}^d \sigma_i^2 \right)
    \leq \exp\left( \frac{\lambda^2}{2} \right).
\end{align*}
$$

Now, define (where $z_i^\top$ is the $i$th row of $Z$):

$$
\begin{align*}
    Y(u) = \frac{\lVert Zu \rVert _2^2}{\lVert u \rVert _2^2} = \sum_{i=1}^m \left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle^2.
\end{align*}
$$

Then, since $z_{ij}$ is zero-mean, unit variance, and sub-Gaussian with parameter $\sigma_{ij}$ we have $\sigma_{ij} \leq \mathbb{E}[z_{ij}^2] = 1$ by our previous variance bound. Therefore, by the result shown above, we deduce that $\left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle$ is sub-Gaussian with parameter 1 for $1 \leq i \leq m$. On the other hand, it's clear that $\mathbb{E}\left[ \left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle \right] = 0$ by linearity of expectation. Then, by independence of the components of $Z$ we have:

$$
\begin{align*}
    \mathbb{E}\left[ \left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle^2 \right]
    = \operatorname{Var}\left[ \left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle \right]
    = \sum_{i=1}^d \frac{u_i^2}{\lVert u \rVert _2^2} \operatorname{Var}\left[ z_{ij} \right]
    = 1.
\end{align*}
$$

In particular, the variables $\left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle$ are sub-Gaussian with parameter at most 1, so $\left\lVert \left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle \right\rVert _{\psi_2} \leq C$ for some absolute constant $C > 0$. Therefore, we have:

$$
\begin{align*}
    \left\lVert \left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle^2 - 1 \right\rVert _{\psi_1}
    = \left\lVert \left\langle z_i, \frac{u}{\lVert u \rVert _2} \right\rangle \right\rVert _{\psi_2}^2
    \leq C^2.
\end{align*}
$$

Now, since $X = \frac{Z}{\sqrt{m}}$, Bernstein's inequality gives the following bound for all $\delta \in (0, 1)$ and some universal constant $c > 0$:

$$
\begin{align*}
    \mathbb{P}\left( \left\lvert \frac{\lVert X u \rVert _2^2}{\lVert u \rVert _2^2} - 1 \right\rvert \geq \delta \right)
     & \leq \mathbb{P}\left( \left\lvert \frac{Y(u)}{m} - 1 \right\rvert \geq \delta \right)          \\
     & = \mathbb{P}(\lvert Y(u) - m \rvert \geq m \delta)                                             \\
     & \leq 2 \exp\left( -c \min\left\{ \frac{m \delta^2}{C^4}, \frac{m \delta}{C^2} \right\} \right) \\
     & \leq 2 \exp\left( -c m \delta^2 \min\left\{ \frac{1}{C^4}, \frac{1}{C^2} \right\} \right).
\end{align*}
$$

Letting $K = c \min\left\lbrace \frac{1}{C^4}, \frac{1}{C^2} \right\rbrace$ be a universal constant, we have:

$$
\begin{align*}
    \mathbb{P}\left( \left\lvert \frac{\lVert X u \rVert _2^2}{\lVert u \rVert _2^2} - 1 \right\rvert \geq \delta \right)
    \leq 2 \exp\left( -K m \delta^2 \right).
\end{align*}
$$

Applying a union bound and using $\binom{N}{2} \leq N^2$, we have:

$$
\begin{align*}
    \mathbb{P}\left( \bigcup_{i \neq j} \left\{ \left\lvert \frac{\lVert X (u_i - u_j) \rVert _2^2}{\lVert u_i - u_j \rVert _2^2} - 1 \right\rvert \geq \delta \right\} \right)
     & \leq \sum_{i \neq j} \mathbb{P}\left( \left\lvert \frac{\lVert X (u_i - u_j) \rVert _2^2}{\lVert u_i - u_j \rVert _2^2} - 1 \right\rvert \geq \delta \right) \\
     & \leq 2 \binom{N}{2} \exp\left( -K m \delta^2 \right)                                                                                                       \\
     & \leq 2 N^2 \exp\left( -K m \delta^2 \right).
\end{align*}
$$

But we know that:

$$
\begin{align*}
    2 N^2 \exp\left( -K m \delta^2 \right) \leq \epsilon
    \iff m \geq \frac{1}{K \delta^2} \log\left( \frac{2 N^2}{\epsilon} \right).
\end{align*}
$$

In particular, if $m$ is chosen as above, then with probability at least $1 - \epsilon$, we have:

$$
\begin{align*}
    (1 - \delta) \lVert u_i - u_j \rVert _2^2 \leq \lVert X (u_i - u_j) \rVert _2^2 \leq (1 + \delta) \lVert u_i - u_j \rVert _2^2
\end{align*}
$$

This gives the distributional Johnson-Lindenstrauss lemma in the sub-Gaussian case as desired.

# Example application

In fact, we can explicitly compute an example of a sparse matrix $X$ with an associated integer matrix $Z$ that satisfies the distributional Johnson-Lindenstrauss lemma as stated above. For $s \in \left[ 0, \frac{1}{2} \right]$, define the following probability distribution on $\{ -1, 0, 1 \}$:

$$
\begin{align*}
    p_s(x)
    = \begin{cases}
          s      & \quad x = -1 \\
          1 - 2s & \quad x = 0  \\
          s      & \quad x = 1
      \end{cases}
\end{align*}
$$

Let $X_s$ be distributed as above. It's clear that $X_s$ has expectation zero; we compute its variance:

$$
\begin{align*}
    \mathbb{E}[X_s^2]
    = s \cdot (-1)^2 + (1 - 2s) \cdot 0^2 + s \cdot 1^2
    = 2s.
\end{align*}
$$

Fix $k \geq 1$ in $\mathbb{N}$ and choose $s = \frac{1}{2k^2}$. Then, if $z_{ij}$ is i.i.d. with the same distribution as $k \cdot X_s$, it clearly still has mean zero and we have:

$$
\begin{align*}
    \mathbb{E}[z_{ij}^2]
    = \mathbb{E}\left[ \left( k \cdot X_s \right)^2 \right]
    = k^2 \cdot \mathbb{E}[X_s^2]
    = 2k^2 \cdot \frac{1}{2k^2}
    = 1.
\end{align*}
$$

Hence the entries of $Z$ are i.i.d. with zero mean and unit variance, where the sparsity of $Z$ is controlled by the parameter $k$. It's also clear that the entries of $Z$ are integers and by boundedness we know that they are sub-Gaussian. Let $X = \frac{Z}{\sqrt{m}}$. Then, by the Johnson-Lindenstrauss lemma proven in the previous section, we have the following bound with probability at least $1 - \epsilon$ whenever $m \geq \frac{1}{K \delta^2} \log\left( \frac{2 N^2}{\epsilon} \right)$ (where $\epsilon$ and $\delta$ are in $(0, 1)$):

$$
\begin{align*}
    (1 - \delta) \lVert u_i - u_j \rVert _2^2 \leq \lVert X (u_i - u_j) \rVert _2^2 \leq (1 + \delta) \lVert u_i - u_j \rVert _2^2.
\end{align*}
$$

This is the bound we wanted, and we can choose $k \in \mathbb{N}$ to make $X$ as sparse as we want!
