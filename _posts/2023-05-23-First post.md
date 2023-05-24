---
title: Some sketching and streaming algorithms
date: 2023-05-23
categories: [high-dimensional-stats]
tags: [cs, sketching, streaming, algorithms]
math: true
comments: true
---

Something I've been thinking about lately is my final project for Stats 200C at UCLA (grad. high-dimensional stats). The topic I chose is sketching and streaming algorithms, which I found particularly interesting because I participated in an REU under Prof. [Jelani Nelson](https://people.eecs.berkeley.edu/~minilek/) last summer, who's an expert on these sorts of algorithms. In any case, here are a few basic sketching algorithms to get us started.

## Morris' algorithm

We would like a data structure to count up to a large number $n$ - this is called the "approximate counting" problem. This data structure should support `increment()` and `query()` methods, to increment the count and return an estimate of the current count respectively. Typically, we would need $\log_2(n)$ bits in the worst case to count up to a number $n$.

One easy idea: what if we only incremented with probability $\frac{1}{2}$ each time? Then, maybe we could multiply our count by 2, and by the law of large numbers, we can expect a reasonably good estimator for the true count. However, we would need $\log_2(n) - 1$ bits to store the number. This still $O(\log(n))$ bits, but we can do better; this is the idea of Morris' algorithm. As the count gets larger, we increment with smaller probability. Here's an incomplete data structure reflecting this idea:

```python
from random import random

class Morris:
    __init__(self):
        # initialize the counter to 0
        self.counter = 0
    update(self):
        # increment counter with probability 1/2^(counter)
        if random() <= 1 / (2 ** self.counter):
            self.counter += 1
```

This is a good idea because $\frac{1}{2^x}$ decays quickly, so with high probability our estimator will be a relatively small number (we'll quantify this later). But given this update algorithm, what should a query to the true count return? Define $X_n$ to be the count in Morris' algorithm after $n$ updates. Then, we have by the law of total expectation:

<center>
$$
\begin{align*}
    \mathbb{E}[2^{X_{n+1}}]
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot \mathbb{E}[2^{X_{n+1}} \vert X_n = k] \\
    & = \sum_{k=0}^\infty \mathbb{P}(X_n = k) \cdot \left( (k + 1) \cdot \frac{1}{2^k} + k \cdot \left( 1 - \frac{1}{2^k} \right) \right) \\
    & = \cdots
\end{align*}
$$
</center>

(more to come...)
