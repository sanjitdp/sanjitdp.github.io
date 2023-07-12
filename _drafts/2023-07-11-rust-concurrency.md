---
title: Experiments with systems programming in Rust
date: 2023-07-11
categories: [systems-programming]
tags: [rust, pyo3, concurrency, python, ai]
math: true
comments: true
---

This summer, I'm working as a project manager and research intern in the [IPAM RIPS](https://www.ipam.ucla.edu/programs/student-research-programs/research-in-industrial-projects-for-students-rips-2023-los-angeles/) program, which is a math REU focused on solving real-world problems from industry sponsors. For my project, I’m currently working for a startup (Artificial Genius, Inc.) on applying new patented particle-type methods for optimal control to solving interesting problems in artificial intelligence.

In particular, I've recently been learning Rust with the goal of writing a fast Python module parallelizing some of the operations performed in our algorithm. I've unfortunately signed a non-disclosure agreement so I can't write about specific implementation details of the algorithm here; however, I thought it would be interesting to write about some of the things I've learned during this process.

## Motivation

One of the first problems we worked on this summer was solving the classic [cart-pole](https://gymnasium.farama.org/environments/classic_control/cart_pole/) environment from the Farama Foundation. In this environment, a tall pole is placed on a cart through an un-actuated joint, and the goal is to keep the pole balanced in an upright position (within 15 degrees of vertical). At each step, the agent chooses whether to apply a force pushing the cart to the left or the right along a frictionless track. Typically, an agent is considered to have succeeded in this environment if it is able to survive for 200 iterations (although we can manually lengthen the duration of the game).

![](/images/rust-concurrency/cartpole.gif){: width="600"}
_A visualization of the basic cart-pole environment from the Farama Foundation._

A classical approach to this problem would be to train a model (perhaps a [deep-Q network](https://sanjitdp.github.io/posts/dqn-ashta-chamma/)) by repeatedly playing the game and later run inference on a given state of the environment to come up with the next action. The issue with this approach is that the model requires prior training before the inference phase; for example, it typically takes around 5 minutes to fully train a DQN to solve cart-pole. On the other hand, our approach to the problem is to run inference on-the-fly using particle-type methods; our agent is able to fully survive all 200 iterations of cart-pole on its first try in under two seconds with no prior training.

I'm not sure we can do much better on this problem at this point using our current methods, but one interesting observation is that with our approach, each particle's computation is effectively unique. This means that we can theoretically implement naïve concurrency (without any mutex locks, race conditions, or shared resources) in order to greatly increase the speed of the model.

The issue is that CPython has the infamous [Global Interpreter Lock (GIL)](https://wiki.python.org/moin/GlobalInterpreterLock), which is effectively a mutex lock preventing multiple threads from modifying Python objects at the same time or executing Python bytecode in parallel. This means that [multithreading](https://docs.python.org/3/library/threading.html) in Python is only really used for performing slow I/O or network operations in an asynchronous fashion (and not for CPU-bound applications).

While Python does have multiprocessing capabilities, this approach to concurrency incurs a lot of runtime overhead and generally makes Python a bad choice for parallel programming. Usually, Python programmers avoid the issue by using fast libraries like `numpy` or `torch` (which are implemented in a low-level language like C++) and not worry explicitly about issues of concurrency. In my case, I want our custom algorithm to run fast for benchmarking purposes, so it makes sense to write high-performance code in a 

## Rust language features

Rust is a newer language that's been gaining a lot of traction because of its clever approach to garbage collection and memory safety using ownership and borrowing (which carries over to thread safety as well), so I thought an interesting next step for the project would be to rewrite our code into a fast Python package implemented entirely in Rust. With the rest of this post, I want to talk about some interesting aspects of software engineering in Rust that I've learned about so far.

### Static type checking

The general philosophy of Rust is to prevent a lot of runtime errors by having a very restrictive compilation step. Rust is strongly and statically typed, although it will infer most types in your program. In fact, there are valid programs that won't compile because the compiler needs help with type inference. Variables are immutable by default, and Rust requires an explicit `mut` annotation in order to define mutable variables.

In aggregate, these choices prevent *a lot* of common errors at runtime but place a larger burden on the programmer at compile-time. In my experience, a lot of my time developing Rust code was spent fighting with the compiler instead of running the code and praying (as one would idiomatically do when writing Python code). However, Rust is well-known for having excellent compiler errors, which really helped me learn the language and fix many simple bugs. Furthermore, whenever it compiled, my code would run like magic and if there were any runtime errors, the reason was typically clear.

One annoying consequence is that we can't perform any operations on incompatible types. For example, the following code won't compile:

```rust
fn main() {
    let a: f32 = 5.0;
    let b: u32 = 5;
    println!("{}", a / b);
}
```

Let's look at the error message to understand why this is incorrect:

```
error[E0277]: cannot divide `f32` by `u32`
 --> src/main.rs:4:22
  |
4 |     println!("{}", a / b);
  |                      ^ no implementation for `f32 / u32`
  |
```

Well, this seems sort of silly. The compiler is complaining that we can't divide a floating-point number by an unsigned integer even though it's very clear what we mean by this. However, Rust is very strict and forces us to think carefully about every operation that we perform. Rust will not perform implicit conversions and therefore avoids many of the issues faced by languages like JavaScript (where implicit conversions happen all the time). In fact, Rust won't even implicitly convert from an integer type to a boolean type or vice versa, which is a very uncommon choice. We can fix the program as follows:

```rust
fn main() {
    let a: f32 = 5.0;
    let b: u32 = 5;
    println!("{}", a / (b as f32));
}
```

This outputs 1, as expected. These sorts of little conversions happen all the time in Rust, which is one of the first things I learned about the language.

### Ownership

One interesting feature is that in Rust, variables take ownership of values. Only one variable can own a value, and when that owner goes out of scope, the value can be dropped from memory. This means that Rust doesn't need a garbage collector like that of Java or Python and also avoids manual memory management like that of C or C++. Although this seems like a simple concept, it seems like the rules of ownership and borrowing infuse their way into every aspect of Rust programming and lead to lots of unintuitive behavior. For example, the following code won't compile:

```rust
fn main() {
    let a = String::from("hello");
    let b = a;
    println!("{}", a);
}
```

Despite not having type annotations, the Rust compiler infers that `a` and `b` are both of type `i32` (32-bit signed integer) by default. But why didn't the program compile? A snippet from the error message tells us why this code doesn't work:

```
error[E0382]: borrow of moved value: `a`
 --> src/main.rs:4:20
  |
2 |     let a = String::from("hello");
  |         - move occurs because `a` has type `String`, which does not implement the `Copy` trait
3 |     let b = a;
  |             - value moved here
4 |     println!("{}", a);
  |                    ^ value borrowed here after move
  |

help: consider cloning the value if the performance cost is acceptable
  |
3 |     let b = a.clone();
  |              ++++++++

For more information about this error, try `rustc --explain E0382`.
```

That is an excellent error message. It tells us that `b` took ownership of `"hello"`, thereby invalidating `a`. In fact, `String` doesn't implement the `Copy` trait, which explains why the assignment on line 3 represents an ownership transfer and not a deep copy. Furthermore, the Rust compiler provides a potential solution: we can explicitly `clone()` the value associated to `a` and avoid the ownership transfer. I haven't found very many ownership issues in my own code, but I have encountered plenty of errors surrounding lifetimes (which I'll discuss later). Interestingly, the compiler also provides a warning for the above code:

```
warning: unused variable: `b`
 --> src/main.rs:3:9
  |
3 |     let b = a;
  |         ^ help: if this is intentional, prefix it with an underscore: `_b`
  |
  = note: `#[warn(unused_variables)]` on by default
```

Rust's compiler will warn you about unused variables, which can be kind of annoying when prototyping a solution. Typically I'll turn this warning off or prefix variables with underscores to get rid of these warnings, though.

### Borrowing

### Lifetimes

### Functional programming

### Results and Options

### Macro expansion

## Example: QuickSelect and MergeSort

## High-performance computing

### Thread-level concurrency

### PyO3 bindings
