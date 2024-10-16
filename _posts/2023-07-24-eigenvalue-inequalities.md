---
layout: note
title: A few interesting eigenvalue inequalities
date: 2023-07-24
author: Sanjit Dandapanthula
---

- TOC
{:toc}

In this post, I'll prove some eigenvalue inequalities that are sometimes used in numerical linear algebra. Note that several of these results are exercises from the book "[Topics in random matrix theory](https://terrytao.files.wordpress.com/2011/02/matrix-book.pdf)". We'll start with an easy optimization problem.

# Positive semi-definite approximation

For a symmetric matrix $A$, we would like to solve the optimization problem:

$$
\begin{align*}
    \arg\min_{A \succeq 0}\ \lVert X - A \rVert_F.
\end{align*}
$$

Here, $A \succeq 0$ means that we're enforcing that $A$ is positive semidefinite. We should already have a guess at the solution due to the spectral theorem, but here is a more rigorous solution. First, because $A$ is symmetric we have $A = Q \Lambda Q^\top$ with $\Lambda$ diagonal and $Q$ orthogonal (by the spectral theorem). We're going to show that $X = Q \cdot \operatorname{ReLU}(\Lambda) \cdot Q^\top$ solves the optimization problem. We know that, since $\operatorname{tr}(AB) = \operatorname{tr}(BA)$:

$$
\begin{align*}
    \lVert X - A \rVert_F
     & = \lVert X - Q \Lambda Q^\top \rVert_F                                                                                \\
     & = \lVert Q (Q^\top X Q - \Lambda) Q^\top \rVert_F                                                                     \\
     & = \operatorname{tr}\left( Q (Q^\top X Q - \Lambda) Q^\top \left( Q (Q^\top X Q - \Lambda) Q^\top \right)^\top \right) \\
     & = \operatorname{tr}\left( Q (Q^\top X Q - \Lambda) Q^\top Q (Q^\top X Q - \Lambda)^\top Q^\top \right)                \\
     & = \lVert Q^\top X Q - \Lambda \rVert_F.
\end{align*}
$$

Hence, minimizing $\lVert X - A \rVert_F$ with $X$ positive semi-definite is equivalent to minimizing $\lVert Y - \Lambda \rVert_F$ with $Y$ positive semi-definite and choosing $X = QYQ^\top$. However, we have:

$$
\begin{align*}
    \lVert Y - \Lambda \rVert_F
    = \sum_{i \neq j} Y_{ij}^2 + \sum_{i=1}^n (Y_{ii} - \Lambda_{ii})^2.
\end{align*}
$$

It's clear that $Y$ must be a diagonal matrix in order to minimize this quantity. Now, $Y$ is positive semi-definite if and only if $Y_{ii} \geq 0$ for $1 \leq i \leq n$. Thus, we have:

$$
\begin{align*}
    \sum_{i \neq j} Y_{ij}^2 + \sum_{i=1}^n (Y_{ii} - \Lambda_{ii})^2
    \geq \sum_{i=1}^n (Y_{ii} - \Lambda_{ii})^2
    \geq \sum_{i=1}^n \mathbf{1}_{\Lambda_{ii} < 0} \cdot \Lambda_{ii}^2.
\end{align*}
$$

However, we can achieve this lower bound if we choose $Y = \operatorname{ReLU}(\Lambda)$ (where $\operatorname{ReLU}$ denotes the [rectified linear unit](https://en.wikipedia.org/wiki/Rectifier_(neural_networks))), and the result follows.

# Schur-Horn inequalities

In this section, we're going to prove the [Schur-Horn inequalities](https://en.wikipedia.org/wiki/Schur–Horn_theorem); suppose $A$ is symmetric. Since $A$ is symmetric we know that we can diagonalize $A$ with orthonormal eigenvectors as $A = Q \Lambda Q^\top$ where $Q$ is orthogonal and $\Lambda$ is diagonal. Now, suppose $u_i$ are the columns of $Q$ with associated eigenvalues $\lambda_i$ so that $\Lambda = \operatorname{diag}(\lambda_i)$. Now, we know that the $u_i$ form a basis for $\mathbb{R}^n$; let $V_k$ be the $k$-dimensional span of $u_1, \cdots, u_k$. Next, if $\lbrace v_1, \cdots, v_m \rbrace$ is any orthonormal basis for a subspace $V$, we define the [partial trace](https://en.wikipedia.org/wiki/Partial_trace) of $A$ over $V$ as:

$$
\begin{align*}
    \operatorname{tr}(A \downharpoonright_V) = \sum_{i=1} v_i^\top A v_i.
\end{align*}
$$

The partial trace is clearly well-defined, since it doesn't matter which basis we choose. Then, we know that:

$$
\begin{align*}
    \sup_{\dim(V) = k} \operatorname{tr}(A \downharpoonright_V)
    \geq \operatorname{tr}(A \downharpoonright_{V_k})
    = \sum_{i=1}^k u_i^\top A u_i
    = \sum_{i=1}^k \lambda_i u_i^\top u_i
    = \lambda_1(A) + \cdots + \lambda_k(A).
\end{align*}
$$

On the other hand, we'll show the reverse inequality by induction on $k$. The base case is trivially true when $k = 0$. Now, notice that for any $k$-dimensional subspace $V$ of $\mathbb{R}^n$ we have a $(k-1)$-dimensional $V_0 \subseteq V$ such that $V_0 \cap \operatorname{span}(u_1) = \{ 0 \}$; namely, $V_0 \subseteq \operatorname{span}(u_2, \cdots, u_k)$. Then, by the induction hypothesis we know that:

$$
\begin{align*}
    \operatorname{tr}(A \downharpoonright_{V_0})
    \leq \lambda_2(A) + \cdots + \lambda_{k}(A).
\end{align*}
$$

On the other hand, we know that for any unit vector $v \in V_0^\perp$ we have $v^\top A v \leq \lambda_1(A)$ by properties of the supremum. Hence, we have $\operatorname{tr}(A \downharpoonright_{V_0}) \leq \lambda_1(A) + \cdots + \lambda_k(A)$. Since $V$ was arbitrary, we have:

$$
\begin{align*}
    \sup_{\dim(V) = k} \operatorname{tr}(A \downharpoonright_V) = \lambda_1(A) + \cdots + \lambda_k(A).
\end{align*}
$$

By a completely symmetric argument, we can obtain the matching equality from below:

$$
\begin{align*}
    \inf_{\dim(V) = k} \operatorname{tr}(A \downharpoonright_V) = \lambda_{n-k+1}(A) + \cdots + \lambda_n(A).
\end{align*}
$$

Let $V_k = \operatorname{span}(\mathbf{e}\_{i_1}, \cdots, \mathbf{e}\_{i_k})$. Then, we have by the above result that:

$$
\begin{align*}
    \lambda_{n-k+1}(A) + \cdots + \lambda_n(A)
     & = \inf_{\dim(V) = k} \operatorname{tr}(A \downharpoonright_V)                                            \\
     & \leq \operatorname{tr}(A \downharpoonright_{V_k})
    = \sum_{r=1}^k \mathbf{e}_{i_r}^\top A \mathbf{e}_{i_r}
    = a_{i_1 i_1} + \cdots + a_{i_k i_k}                                                                        \\
     & \leq \sup_{\dim(V) = k} \operatorname{tr}(A \downharpoonright_V) = \lambda_1(A) + \cdots + \lambda_k(A).
\end{align*}
$$

These are called the Schur-Horn inequalities.

# Ky Fan inequality

In this section, we're going to quickly prove the [Ky Fan eigenvalue inequality](https://projecteuclid.org/journals/pacific-journal-of-mathematics/volume-5/issue-S2/A-comparison-theorem-for-eigenvalues-of-normal-matrices/pjm/1172000954.pdf) using the results we've shown above. First, we know by inequalities proven above that:

$$
\begin{align*}
    \lambda_1(A+B) + \cdots + \lambda_k(A+B)
    = \sup_{\dim(V) = k} \operatorname{tr}((A+B) \downharpoonright_V).
\end{align*}
$$

On the other hand, suppose $v_1, \cdots, v_k$ is an orthonormal basis for $V$. Then, we have:

$$
\begin{align*}
    \operatorname{tr}((A+B) \downharpoonright_V)
    = \sum_{i=1}^k v_i^\top (A + B) v_i
    = \sum_{i=1}^k v_i^\top A v_i + \sum_{i=1}^k v_i^\top B v_i
    = \operatorname{tr}(A \downharpoonright_V) + \operatorname{tr}(B \downharpoonright_V).
\end{align*}
$$

Hence, we have (by properties of the supremum):

$$
\begin{align*}
    \sup_{\dim(V) = k} \operatorname{tr}((A+B) \downharpoonright_V)
     & = \sup_{\dim(V) = k} \left( \operatorname{tr}(A \downharpoonright_V) + \operatorname{tr}(B \downharpoonright_V) \right)        \\
     & \leq \sup_{\dim(V) = k} \operatorname{tr}(A \downharpoonright_V) + \sup_{\dim(V) = k} \operatorname{tr}(B \downharpoonright_V) \\
     & = \lambda_1(A) + \cdots + \lambda_k(A) + \lambda_1(B) + \cdots + \lambda_k(B).
\end{align*}
$$

This establishes the Ky Fan inequality.

# Davis-Kahan $\sin(\Theta)$ theorem

In this section, we'll prove a version of the [Davis-Kahan $\sin(\Theta)$ theorem](https://core.ac.uk/download/pdf/82382146.pdf), which is a result from random matrix theory which is commonly used in image denoising (along with other applications). The statement of this theorem is somewhat long and seems unmotivated, but Philippe Rigollet at MIT has some [lecture notes](https://math.mit.edu/~rigollet/IDS160/Notes/IDS_160_Lecture_10.pdf) containing a few neat applications.

The Davis-Kahan $\sin(\Theta)$ theorem is as follows. Suppose $A = E_0 A_0 E_0^\top + E_1 A_1 E_1^\top$ and the perturbed version $A + H = F_0 \Lambda_0 F_0^\top + F_1 \Lambda_1 F_1^\top$ are both symmetric matrices, with both $[\begin{array}{cc} E_0 & E_1 \end{array}]$ and $[\begin{array}{cc} F_0 & F_1 \end{array}]$ being orthogonal matrices. Suppose also that the eigenvalues of $A_0$ are contained in $(a, b)$ and the eigenvalues of $\Lambda_1$ are excluded from $(a - \delta, b + \delta)$ for some $\delta > 0$. Then, we have:

$$
\begin{align*}
    \lVert F_1^\top E_0 \rVert _2 \leq \frac{\lVert F_1^\top H E_0 \rVert _2}{\delta}.
\end{align*}
$$

In fact, the proof will show that this is true if we replace the spectral norm with any unitarily-invariant norm. First, because $[\begin{array}{cc} E_0 & E_1 \end{array}]$ is orthogonal:

$$
\begin{align*}
    \left[\begin{array}{c} E_0^\top \\ E_1^\top \end{array}\right] \left[\begin{array}{cc} E_0 & E_1 \end{array}\right]
    = \left[\begin{array}{cc}
                    E_0^\top E_0 & E_0^\top E_1 \\
                    E_1^\top E_0 & E_1^\top E_1
                \end{array}\right]
    = I.
\end{align*}
$$

This means that $E_0^\top E_0 = I$ and $E_1^\top E_0 = 0$. Therefore, we know by direct computation that:

$$
\begin{align*}
    A E_0
    = E_0 A_0 (E_0^\top E_0) + E_1 A_1 (E_1^\top E_0)
    = E_0 A_0.
\end{align*}
$$

Now, since $H = (A + H) - A$ we find:

$$
\begin{align*}
    H E_0
    = (A + H) E_0 - A E_0
    = (A + H) E_0 - E_0 A_0.
\end{align*}
$$

Similarly, because $[\begin{array}{cc} F_0 & F_1 \end{array}]$ is orthogonal:

$$
\begin{align*}
    \left[\begin{array}{c} F_0^\top \\ F_1^\top \end{array}\right] \left[\begin{array}{cc} F_0 & F_1 \end{array}\right]
    = \left[\begin{array}{cc}
                    F_0^\top F_0 & F_0^\top F_1 \\
                    F_1^\top F_0 & F_1^\top F_1
                \end{array}\right]
    = I.
\end{align*}
$$

This means that $F_1^\top F_1 = I$ and $F_1^\top F_0 = 0$. Therefore, we compute:

$$
\begin{align*}
    F_1^\top H E_0
    = (F_1^\top F_0) \Lambda_0 F_0^\top E_0 + (F_1^\top F_1) \Lambda_1 F_1^\top E_0 - F_1^\top (A E_0)
    = \Lambda_1 F_1^\top E_0 - F_1^\top E_0 A_0.
\end{align*}
$$

By the reverse triangle inequality, we know that:

$$
\begin{align*}
    \lVert F_1^\top H E_0 \rVert
     & = \lVert \Lambda_1 F_1^\top E_0 - F_1^\top E_0 A_0 \rVert _2                                 \\
     & = \lVert (\Lambda_1 - cI) F_1^\top E_0 - F_1^\top E_0 (A_0 - cI) \rVert _2                   \\
     & \geq \lVert (\Lambda_1 - cI) F_1^\top E_0 \rVert _2 - \lVert F_1^\top E_0 (A_0 - cI) \rVert _2.
\end{align*}
$$

Meanwhile, we know that the eigenvalues of $A_0$ are contained in $(a, b)$ so the eigenvalues of $A_0 - cI$ are contained in the interval $(-r, r)$. This means that we have $\lVert A_0 - cI \rVert _2 \leq r$ by the [Courant-Fischer min-max theorem](https://en.wikipedia.org/wiki/Min-max_theorem), so we find:

$$
\begin{align*}
    \lVert F_1^\top E_0 (A_0 - cI) \rVert _2
    \leq \lVert F_1^\top E_0 \rVert _2 \lVert A_0 - cI \rVert _2
    \leq r \lVert F_1^\top E_0 \rVert _2.
\end{align*}
$$

Similarly, we know that the eigenvalues of $\Lambda_1$ are excluded from $(a - \delta, b + \delta)$ so the eigenvalues of $\Lambda_1 - cI$ are excluded from the interval $(-r-\delta, r+\delta)$. This means that we have $\lVert \Lambda_1 - cI \rVert _2 \geq r+\delta$ and $\lVert (\Lambda_1 - cI)^{-1} \rVert _2 \leq \frac{1}{r+\delta}$ by Courant-Fischer, so we find:

$$
\begin{align*}
    & \lVert F_1^\top E_0 \rVert _2
    \leq \lVert (\Lambda_1 - cI)^{-1} \rVert _2 \lVert (\Lambda_1 - cI) F_1^\top E_0 \rVert _2 \\
    & \quad \implies \lVert (\Lambda_1 - cI) F_1^\top E_0 \rVert _2
    \geq \frac{\lVert F_1^\top E_0 \rVert _2}{\lVert (\Lambda_1 - cI)^{-1} \rVert _2}
    \geq (r+\delta) \lVert F_1^\top E_0 \rVert _2.
\end{align*}
$$

Combining the inequalities derived above, we have:

$$
\begin{align*}
    \lVert F_1^\top H E_0 \rVert _2
    \geq \lVert (\Lambda_1 - cI) F_1^\top E_0 \rVert _2 - \lVert F_1^\top E_0 (A_0 - cI) \rVert _2
    \geq (r + \delta) \lVert F_1^\top E_0 \rVert _2 - r \lVert F_1^\top E_0 \rVert _2
    = \delta \lVert F_1^\top E_0 \rVert _2.
\end{align*}
$$

Dividing by $\delta$ on both sides of the inequality, we deduce the Davis-Kahan $\sin(\Theta)$ theorem.

# Low-rank perturbations

Here, we're going to characterize the singular values of a matrix as the solution to an optimization problem involving low-rank perturbations; in particular, we'll show that $\sigma_n(A) = \min_{X, \operatorname{rank}(A+X) < n} \lVert X \rVert _2$. We'll do this by showing the inequalities in both directions.

First, we know that if $A = \sum_{i=1}^n \sigma_i u_i v_i^\top$ then we can choose $X = -\sigma_n u_n v_n^\top$ so that $\operatorname{rank}(A+X) < n$. Now, we have $\lVert X \rVert \_2 = \sigma_n(A)$ since $\lVert B \rVert \_2 = \sigma_1(B)$. Hence, we have shown that $\min_{X, \operatorname{rank}(A+X) < n} \lVert X \rVert _2 \leq \sigma_n(A)$. Then, notice that we can substitute $X_0 = A+X$ to find:

$$
\begin{align*}
    \min_{X, \operatorname{rank}(A+X) < n} \lVert X \rVert _2
    = \min_{X_0, \operatorname{rank}(X_0) < n} \lVert X_0 - A \rVert _2.
\end{align*}
$$

Then, suppose $X_0$ has rank less than $n$; namely, we can write $X_0 = RS^\top$ where $R$ and $S$ have $n-1$ columns and $n$ rows. Then, there is a unit vector $z \in \ker(S)$ and we can write $z = \sum_{i=1}^n c_i v_i$. Now, we have:

$$
\begin{align*}
    \lVert A - X_0 \rVert _2^2
    & \geq \lVert (A - X_0) z \rVert _2^2 \\
    & = \lVert Az - R (S^T z) \rVert _2^2 \\
    & = \lVert Az \rVert _2^2 \\
    & = \left\lVert \sum_{i=1}^n \sigma_i u_i v_i^\top \cdot \left( \sum_{k=1}^n c_k v_k \right) \right\rVert _2^2 \\
    & = \left\lVert \sum_{i=1}^n \sigma_i c_i u_i \right\rVert _2^2 \\
    & = \sum_{i=1}^n \sigma_i^2 c_i^2.
\end{align*}
$$

Then, since $\sigma_n \leq \sigma_{n-1} \leq \cdots \leq \sigma_1$, we find:

$$
\begin{align*}
    \sum_{i=1}^n \sigma_i^2 c_i^2
    \geq \sigma_n^2.
\end{align*}
$$

Therefore, we find that $\min_{X_0, \operatorname{rank}(X_0) < n} \lVert A - X_0 \rVert _2 \geq \sigma_n$, and the result follows.

# Small gain theorem

Finally, we'll prove a version of the [small gain theorem](https://en.wikipedia.org/wiki/Small-gain_theorem) as a corollary of the previous result; in particular, we want to show that if $A$ has full rank, then $\min_{X, \operatorname{rank}(I-AX) < n} \lVert X \rVert _2 = \frac{1}{\sigma_1(A)}$. We know that because $A$ has full rank, $I-AX$ and $A^{-1}(I-AX) = A^{-1}-X$ have the same rank. Therefore, we compute:

$$
\begin{align*}
    \min_{X, \operatorname{rank}(I-AX) < n} \lVert X \rVert _2
    = \min_{X, \operatorname{rank}(A^{-1}-X) < n} \lVert X \rVert _2
    = \min_{X, \operatorname{rank}(A^{-1}+X) < n} \lVert X \rVert _2.
\end{align*}
$$

However, using the above result on low-rank perturbations, we know that the last quantity is equal to the smallest singular value of $A^{-1}$. Since the singular values of $A^{-1}$ are the reciprocals of the singular values of $A$, the smallest singular value of $A^{-1}$ is $\frac{1}{\sigma_1(A)}$ and we deduce the small gain theorem.
