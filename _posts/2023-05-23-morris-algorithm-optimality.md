---
title: The optimality of Morris' algorithm
date: 2023-05-23
categories: [high-dimensional-stats]
tags: [cs, sketching, algorithms, approximate-counting, morris-algorithm]
math: true
comments: true
---

Something I've been thinking about lately is my final project for Stats 200C at UCLA (grad. high-dimensional stats). The topic I chose is algorithms for approximate counting, which I found particularly interesting because I participated in an REU under Prof. [Jelani Nelson](https://people.eecs.berkeley.edu/~minilek/) last summer, who's an expert in this field. In any case, here's a cool [counting algorithm](https://arxiv.org/pdf/2010.02116.pdf) I've been reading about (which is provably optimal).

## Morris' algorithm

Let's start with the traditional [Morris' algorithm](https://dl.acm.org/doi/pdf/10.1145/359619.359627) due to [Robert Morris](https://en.wikipedia.org/wiki/Robert_Morris_(cryptographer)). We would like a data structure to count (approximately) up to a large number $n$ using very little storage - this is called the "approximate counting" problem. In exchange for the reduced space complexity, maybe we don't need the exact count - we only need to get reasonably close. This data structure should support `increment()` and `query()` methods, to increment the count and return an estimate of the current count respectively. Typically, we would need $\log_2(n)$ bits in the worst case to count up to a number $n$.

One easy idea: what if we only incremented with probability $\frac{1}{2}$ each time? Then, maybe we could multiply our count by 2, and by the law of large numbers, we can expect a reasonably good estimator for the true count. However, we would need $\log_2(n) - 1$ bits to store the number. This still requires $O(\log(n))$ bits, but we can do better; this is the idea of Morris' algorithm. As the count gets larger, we increment with smaller probability. Here's an incomplete data structure reflecting this idea:

```python
from random import getrandbits

class Morris:
    def __init__(self):
        # initialize the counter to 0
        self.counter = 0
    def update(self):
        # increment counter with probability 1/2^(counter)
        if not getrandbits(self.counter):
            self.counter += 1
```

This is a good idea because $n \mapsto \frac{1}{2^n}$ decays quickly, so with high probability our estimator will be a relatively small number (we'll quantify this later). But given this update algorithm, what should a query to the true count return? Define $X_n$ to be the count in Morris' algorithm after $n$ updates. Then, we have by the law of total expectation:

$$
\begin{align*}
    \mathbb{E}[2^{X_{n+1}}]
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot \mathbb{E}[2^{X_{n+1}} \vert X_n = k] \\
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot \left( 2^{k+1} \cdot \frac{1}{2^k} + 2^k \cdot \left( 1 - \frac{1}{2^k} \right) \right) \\
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot (2^k + 1) \\
    & = \mathbb{E}[2^{X_n}] + 1.
\end{align*}
$$

Since $2^{X_0} = 2^0 = 1$, we know that $\mathbb{E}[2^{X_0}] = 1$. Solving the recurrence in $n$ gives $\mathbb{E}[2^{X_n}] = n + 1$, which suggests that $2^{X_n} - 1$ is an unbiased estimator for $n$. Therefore, we obtain the complete Morris' algorithm:

```python
from random import getrandbits

class Morris:
    def __init__(self):
        # initialize the counter to 0
        self.counter = 0
    def update(self):
        # increment counter with probability 1/2^(counter)
        if not getrandbits(self.counter):
            self.counter += 1
    def query(self):
        # return the unbiased estimate
        return (2 ** self.counter) - 1
```

Just how good is this estimator? Well, Chebyshev's inequality tells us that $2^{X_n} - 1$ concentrates around its mean:

$$
\mathbb{P}(\lvert 2^{X_n} - 1 - n \rvert \geq n \epsilon) \leq \frac{1}{\epsilon^2 n^2} \cdot \mathbb{E}[(2^{X_n} - 1 - n)^2].
$$

But we have:

$$
\begin{align*}
    \mathbb{E}[2^{2 X_{n+1}}]
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot \mathbb{E}[2^{2 X_{n+1}} \vert X_n = k] \\
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot \left( 2^{2k+2} \cdot \frac{1}{2^k} + 2^{2k} \cdot \left( 1 - \frac{1}{2^k} \right) \right) \\
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot (2^{k+2} + 2^{2k} - 2^k) \\
    & = \mathbb{E}[2^{X_n + 2}] + \mathbb{E}[2^{2 X_n}] - \mathbb{E}[2^{X_n}] \\
    & = 3 (n + 1) + \mathbb{E}[2^{2 X_n}].
\end{align*}
$$

Again, we can solve the recurrence with the initial condition $\mathbb{E}[2^{2 X_0}] = 1$ to find $\mathbb{E}[2^{2 X_n}] = \frac{3}{2} n^2 + \frac{3}{2} n + 1$. Therefore, we have (for $n \geq 1$):

$$
\begin{align*}
    \mathbb{E}[(2^{X_n} - 1 - n)^2]
    & = \mathbb{E}[(2^{X_n} - (n + 1))^2] \\
    & = \mathbb{E}[2^{2 X_n}] - 2 (n + 1) \mathbb{E}[2^{X_n}] + (n + 1)^2 \\
    & = \frac{3}{2} n^2 + \frac{3}{2} n + 1 - 2 (n + 1)^2 + (n + 1)^2 \\
    & = \binom{n}{2} \\
    & < \frac{n^2}{2}.
\end{align*}
$$

Therefore, our original Chebyshev bound gives:

$$
\mathbb{P}(\lvert 2^{X_n} - 1 - n \rvert \geq n \epsilon) < \frac{1}{2 \epsilon^2}.
$$

This bound suggests that this algorithm is really not that great. In particular, we need $\epsilon \geq 1$ to at least get a failure probability better than $\frac{1}{2}$. But with $\epsilon \geq 1$, Chebyshev's inequality only tells us (at best) that our estimate is in $[0, 2n]$. This is a *really* wide range, and not very useful at all.

## Fooling around

Okay, so we have a not-so-great algorithm. But we're computer scientists, and that isn't going to stop us from trying to make this work! There are a few tricks we can use to sharpen our estimate.

### Trick #1

We'll create $s$ independent instantiations of the Morris algorithm and take an average to reduce the variance. Letting $\tilde{n}\_i$ be the estimator given by the $i$th instantiation, our estimator is $\tilde{n} = \frac{1}{s} \sum_{i=1}^s \tilde{n}_i$. Then, by properties of variance and our previous result about Morris' original algorithm:

$$
\mathbb{E}[(\tilde{n} - n)^2]
= \frac{1}{s} \cdot \mathbb{E}[(2^{X_n} - 1 - n)^2]
\leq \frac{n^2}{2s}.
$$

Now, Chebyshev's bound gives the sharper estimate:

$$
\mathbb{P}(\lvert \tilde{n} - n \rvert \geq n \epsilon) < \frac{1}{2 s \epsilon^2}.
$$

Now, we can fix a failure probability $\delta > 0$ and choose $s \geq \frac{1}{2 \epsilon^2 \delta}$ so that $\mathbb{P}(\lvert \tilde{n} - n \rvert \geq n \epsilon) < \delta$. This algorithm is sometimes called "Morris+".

### Trick #2

Here's another neat trick to further reduce the dependence of our bound on the failure probability $\delta$ to $\log\left( \frac{1}{\delta} \right)$. Run $t$ instantiations of Morris+, each with failure probability $\delta = \frac{1}{3}$, for instance. Then, let $Y_i$ be 1 if the $i$th Morris+ algorithm fails and 0 otherwise, so that the following bound comes for free:

$$
\mathbb{E}\left[ \sum_{i=1}^t Y_i \right]
= \sum_{i=1}^t \mathbb{E}[Y_i]
= \sum_{i=1}^t \mathbb{P}(Y_i = 1)
\leq \frac{t}{3}.
$$

Then, since $0 \leq Y_i \leq 1$ is a bounded random variable (and therefore sub-exponential), Hoeffding's inequality allows us to control the number of failures:

$$
\mathbb{P}\left( \sum_{i=1}^t Y_i \geq \frac{t}{2} \right)
\leq \mathbb{P}\left( \sum_{i=1}^t Y_i - \mathbb{E}\left[ \sum_{i=1}^t Y_i \right] \geq \frac{t}{6} \right)
\leq \exp\left( -\frac{t}{18} \right).
$$

Choosing $t \geq 18 \log\left( \frac{1}{\delta} \right)$, we get $\mathbb{P}\left( \sum_{i=1}^t Y_i \geq \frac{t}{2} \right) \leq \delta$. In particular, this means that choosing $t$ this way, the median $\tilde{n}$ of the Morris+ runs satisfies $\lvert \tilde{n} - n \rvert < n \epsilon$ with probability at least $1 - \delta$. Therefore, we take the median of our Morris+ instantiations as our new estimator and obtain an improved failure rate. This algorithm is sometimes called "Morris++".

## Space complexity

Fix $\epsilon > 0$ and $\delta > 0$. Running Morris++ with the minimal choices of $s$ and $t$ requires running Morris+ for $t = \Theta\left( \log\left( \frac{1}{\delta} \right) \right)$ iterations, each of which require running the original Morris' algorithm $s = \Theta\left( \frac{1}{\epsilon^2} \right)$ times. If any counter in the original Morris' algorithm reaches $\log_2\left( \frac{nst}{\delta} \right)$, it will be incremented with probability at most $\frac{\delta}{nst}$. Therefore, a union bound tells us that the probability that the counter will be incremented in the next $n$ steps is at most $\frac{\delta}{st}$. Another union bound tells us that the probability that any of the $st$ counters will ever surpass $\log_2\left( \frac{nst}{\delta} \right)$ is at most $\delta$. This means that with probability at least $1 - \delta$, the space complexity of Morris++ is of the following order:

$$
O\left( \frac{1}{\epsilon^2} \cdot \log_2\left( \frac{1}{\delta} \right) \cdot \log_2\left( \log_2\left( \frac{n}{\epsilon \delta} \right) \right) \right).
$$

Notice that for fixed $\epsilon$ and $\delta$, the space complexity of Morris++ is $O(\log(\log(n)))$. [Terence Tao](https://terrytao.wordpress.com) once joked to our class that no one knows whether $\log(\log(n))$ actually goes to infinity - no one has seen it happen. This is a really good space complexity!

## Optimality and new work

(more to come...)
