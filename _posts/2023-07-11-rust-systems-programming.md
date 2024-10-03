---
layout: note
title: Experiments with systems programming in Rust
date: 2023-07-11
author: Sanjit Dandapanthula
---

This summer, I'm working as a project manager and research intern in the [IPAM RIPS](https://www.ipam.ucla.edu/programs/student-research-programs/research-in-industrial-projects-for-students-rips-2023-los-angeles/) program, which is a math REU focused on solving real-world problems from industry sponsors. For my project, I’m currently working for a startup company on applying new patented particle-type methods for optimal control to solving interesting problems in artificial intelligence.

In particular, I've recently been learning Rust with the goal of writing a fast Python module parallelizing some of the operations performed in our algorithm. I've unfortunately signed a non-disclosure agreement so I can't write about specific implementation details of the algorithm here; however, I thought it would be interesting to write about some of the things I've learned during this process.

## Motivation

One of the first problems we worked on this summer was solving the classic [cart-pole](https://gymnasium.farama.org/environments/classic_control/cart_pole/) environment from the Farama Foundation. In this environment, a tall pole is placed on a cart through an un-actuated joint, and the goal is to keep the pole balanced in an upright position (within 15 degrees of vertical). At each step, the agent chooses whether to apply a force pushing the cart to the left or the right along a frictionless track. Typically, an agent is considered to have succeeded in this environment if it is able to survive for 200 iterations (although we can manually lengthen the duration of the game).

![A visualization of the basic cart-pole environment from the Farama Foundation](/images/rust-systems-programming/cartpole.gif){: width="600"}
<p class='caption'>
A visualization of the basic cart-pole environment from the Farama Foundation
</p>

A classical approach to this problem would be to train a model (perhaps a [deep-Q network](https://sanjitdp.github.io/posts/dqn-ashta-chamma/)) by repeatedly playing the game and later run inference on a given state of the environment to come up with the next action. The issue with this approach is that the model requires prior training before the inference phase; for example, it typically takes around 5 minutes to fully train a DQN to solve cart-pole. On the other hand, our approach to the problem is to run inference on-the-fly using particle-type methods; our agent is able to fully survive all 200 iterations of cart-pole on its first try in under two seconds with no prior training.

I'm not sure we can do much better on the cart-pole problem at this point using our current methods, but one interesting observation is that with our approach, each particle's computation is effectively unique. This means that we can theoretically implement naïve concurrency (without any mutex locks, race conditions, or shared resources) in order to greatly increase the speed of the model.

The issue is that CPython has the infamous [Global Interpreter Lock (GIL)](https://wiki.python.org/moin/GlobalInterpreterLock), which is a mutex lock preventing multiple threads from modifying Python objects at the same time or executing Python bytecode in parallel. This means that [multithreading](https://docs.python.org/3/library/threading.html) in Python is only really used for performing slow I/O or network operations in an asynchronous fashion (and not for CPU-bound applications).

While Python does have multiprocessing capabilities, this approach to concurrency incurs a lot of runtime overhead and generally makes Python a bad choice for parallel programming. Usually, Python programmers avoid the issue by using fast libraries like `numpy` or `torch` (which are implemented in a low-level language like C++) and not worry explicitly about issues of concurrency. In my case, I want our custom algorithm to run fast for benchmarking purposes, so it makes sense to write high-performance code in a language like Rust.

Computing speed is becoming increasingly important for our project as we move towards more complex games like Pong or PacMan, as well as applications to 3D robotics and factory simulations in the [Nvidia Omniverse](https://www.nvidia.com/en-us/omniverse/). In fact, one of my stretch goals for this project is to use the [CUDA framework](https://developer.nvidia.com/cuda-toolkit) to implement very fast GPU-level parallelization (which [can also be done](https://github.com/Rust-GPU/Rust-CUDA) in Rust). This is especially appealing since IPAM has generously paid for a Google Colab Pro+ subscription (which gives me access to virtual machines with Nvidia A100 GPUs) and a Google Cloud server with an Nvidia T4 GPU capable of rendering the Nvidia Omniverse .

## Cool Rust language features

Rust is a newer language that's been gaining a lot of traction because of its clever approach to garbage collection and memory safety using ownership and borrowing (which carries over to thread safety as well), so I thought an interesting next step for the project would be to rewrite our code into a fast Python package implemented entirely in Rust. With the rest of this post, I want to talk about some interesting aspects of software engineering in Rust that I've learned about so far.

### Static type checking

The general philosophy of Rust is to prevent a lot of runtime errors by having a very restrictive compilation step. Rust is strongly and statically typed, although it will infer most types in your program. In fact, there are valid programs that won't compile because the compiler needs help with type inference. Variables are immutable by default, and Rust requires an explicit `mut` annotation in order to define mutable variables.

In aggregate, these choices prevent *a lot* of common errors at runtime but place a larger burden on the programmer at compile-time. In my experience, a lot of my time developing Rust code was spent fighting with the compiler instead of running the code and praying (as one would idiomatically do when writing Python code). However, Rust is well-known for having excellent compiler errors, which really helped me learn the language and fix many simple bugs. When it finally compiled, my code would typically run error-free -- if there were any runtime errors, the reason was typically clear.

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

This outputs 1, as expected. These sorts of little type conversions need to happen all the time in Rust, which is one of the first things I learned about the language. Additionally, strings are all UTF-encoded, which sacrifices string indexing (for example) in favor of first-class emoji support and support for characters in other languages 😄. Despite its usual strictness, Rust allows you to turn off a lot of its compiler checks using the `unsafe` keyword; the use of this keyword is detailed in the aptly-named [Rustonomicon](https://doc.rust-lang.org/nomicon/).

### Ownership

One interesting feature is that in Rust, variables take ownership of values. Only one variable can own a value, and when that owner goes out of scope, the value can be dropped from memory. This means that Rust doesn't need a garbage collector like that of Java or Python and also avoids manual memory management like that of C or C++. Although this seems like a simple concept, it seems like the rules of ownership and borrowing infuse their way into every aspect of Rust programming and lead to lots of unintuitive behavior. For example, the following code won't compile:

```rust
fn main() {
    let a = String::from("hello");
    let b = a;
    println!("{}", a);
}
```

Despite not having type annotations, the Rust compiler infers that `a` and `b` are both of type `String` by default. But why didn't the program compile? A snippet from the error message tells us why this code doesn't work:

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

### Borrowing and lifetimes

Since you might not always want to take ownership of a variable, Rust also allows you to take references of the variable using syntax like `b = &a;` for an immutable reference or `b = &mut a` to take a mutable reference. At any time, you can have either one mutable reference to an object or any number of immutable references. This is intended to prevent errors where two threads of execution are simultaneously trying to modify a value in the concurrency setting or iterator invalidation when elements of an array are deleted during iteration.

In general, it seems like this rule is intended to stop references from changing under you due to the actions of another mutable reference somewhere else. The syntax for references is very similar to pointer syntax in C++, and you can use `*` to follow a reference. In addition, Rust won't let you keep dangling references (even at the compilation step). For example, the following code snippet won't compile:

```rust
fn main() {
    let foo = bar();
}

fn bar() -> &String {
    let s = String::from("hello");
    &s
}
```

Rust's compiler notices that you're returning a variable containing a borrowed value which is deallocated at the end of the `bar` function scope:

```
error[E0106]: missing lifetime specifier
 --> src/main.rs:5:16
  |
5 | fn dangle() -> &String {
  |                ^ expected named lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but there is no value for it to be borrowed from
help: consider using the `'static` lifetime
  |
5 | fn dangle() -> &'static String {
  |                 +++++++

For more information about this error, try `rustc --explain E0106`.
```

Well, this is somewhat useful, but Rust's compiler actually tells us that we can add the lifetime annotation `'static` to indicate to the compiler that we want to keep the value referenced by `s` around for the entire duration of the program. I've spent quite a bit of time fighting the compiler on lifetime issues, which arise when the compiler is unsure about whether a borrowed reference will live long enough. For example, this is especially important when instantiating a struct containing objects (all of the objects must outlive the vector). The notation for lifetimes seems a bit messy, and one example from my current RIPS code looks like this:

```rust
pub struct Agent<'a> {
    env: &'a PyAny,
    // ...more cool stuff
}
```

This doesn't actually change the lifetime of the `env` object, but it tells the compiler that we know that `env` will survive at least as long as the `Agent` object. Theoretically speaking, lifetimes are specified for every object, but some patterns of lifetime annotation are so common that the Rust compiler will automatically add lifetime annotations; this is called "elision".

### Functional programming

Writing code in Rust seems to take a lot of influence from functional programming paradigms (more so than C++, for example). I've found myself using pattern matching and map-filter-reduce quite frequently, both of which are very fast. I've also used a lot of closures and lambda expressions, which are interesting due to their interplay with the rules of ownership, borrowing, and lifetimes. This is especially useful in multithreading, since threads take in a lambda expression and can capture their environment.

Furthermore, a lot of Rust's error handling comes from returning Results and Options, which are enumerated types. Results have `Ok` and `Err` variants and are used to communicate to the caller that an operation failed. This is sort of tedious at times, since many operations may fail (especially in my context working with Python requests, all of which may fail). On the other hand, Options have `Some` and `None` variants, which is sort of like the `nullptr` in C++ or `NULL` in C. This can be used to communicate exceptional (but not error-type) circumstances, like not finding an element in a data container.

Technically, Rust intends for the programmer to deal with `Result` and `Option` objects using its fast pattern matching. Often, though, I sidestep the issue of explicit error handling using the `?` or `.unwrap()` functions.

### Macro expansion

One last little pattern I've noticed in Rust is that a lot of Rust code relies on C-style macros. For example, the `println` macro is the way that developers typically write to `stdout`, and the `vec` macro is commonly used to initialize vectors. Here's an example that uses these macros:

```rust
fn main() {
  let odds: Vec<i32> = vec![1, 3, 5, 7, 9];
  println!("{:?}", odds);
}
```

Notice that Rust uses `!` for macro expansion and we can use `{:?}` as a debug format specifier. In general, we can make any struct printable for debugging using `#[derive(Debug)]` above the struct definition; this line will provide an implementation of the `Debug` trait for the given struct. I use this all the time when writing Rust code in order to see what my objects look like during execution of my program.

## Example: QuickSelect and MergeSort

One of the first little pieces of code I wrote when learning Rust was to calculate the mean of a vector. It's pretty similar to C++ code, but you'll notice the Rust compiler is quite pedantic and won't perform implicit casts from `i32` to `f64`; I had to do this myself:

```rust
fn mean(v: &[i32]) -> f64 {
    let mut sum: i32 = 0;

    for i in v {
        sum += i;
    }

    (sum as f64) / (v.len() as f64)
}
```

As another example, here's some code implementing randomized [QuickSelect](https://en.wikipedia.org/wiki/Quickselect) for linear-time median-finding:

```rust
fn median(v: &[i32]) -> f64 {
    let n = v.len();

    if n % 2 == 1 {
        return quick_select(v, n / 2) as f64;
    } else {
        return ((quick_select(v, n / 2 - 1) + quick_select(v, n / 2)) as f64) / 2.0;
    }
}

fn quick_select(v: &[i32], n: usize) -> i32 {
    let pivot = v.choose(&mut rand::thread_rng()).unwrap();

    let lt = v
        .iter()
        .filter(|&i| i < pivot)
        .map(|i| *i)
        .collect::<Vec<i32>>();
    let eq: Vec<i32> = v
        .iter()
        .filter(|&i| i == pivot)
        .map(|i| *i)
        .collect::<Vec<i32>>();
    let gt = v
        .iter()
        .filter(|&i| i > pivot)
        .map(|i| *i)
        .collect::<Vec<i32>>();

    if n < lt.len() {
        return quick_select(&lt, n);
    } else if n < lt.len() + eq.len() {
        return *pivot;
    } else {
        return quick_select(&gt, n - (lt.len() + eq.len()));
    }
}
```

I think this piece of code is a good example of a lot of the functional influences in Rust, which I like a lot. Finally, here's a little function implementing [MergeSort](https://en.wikipedia.org/wiki/Merge_sort) to get more used to working with vectors in Rust:

```rust
fn merge_sort(v: &[i32]) -> Vec<i32> {
    let n = v.len();

    if n <= 1 {
        return v.to_vec();
    }

    let sorted_left = merge_sort(&v[..(n / 2)]);
    let sorted_right = merge_sort(&v[(n / 2)..]);

    let mut output: Vec<i32> = Vec::new();

    let mut lp = 0;
    let mut rp = 0;

    for _ in 0..n {
        if sorted_left[lp] <= sorted_right[rp] {
            output.push(sorted_left[lp]);
            lp += 1;

            if lp == sorted_left.len() {
                output.extend_from_slice(&sorted_right[rp..]);
                break;
            }
        } else {
            output.push(sorted_right[rp]);
            rp += 1;

            if rp == sorted_right.len() {
                output.extend_from_slice(&sorted_left[lp..]);
                break;
            }
        }
    }

    output
}
```

Finally, Rust has first-class support for unit tests, which is really nice:

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn test_merge_sort() {
        let v: Vec<i32> = vec![1, 3, 4, 2, 5, -5, 6];
        assert_eq!(super::merge_sort(&v), vec![-5, 1, 2, 3, 4, 5, 6]);

        // ...
    }

    #[test]
    fn test_mean() {
        let v: Vec<i32> = vec![1, 3, 4, 2, 5, -5, 6];
        assert_eq!(super::mean(&v), 2.2857142857142856);

        // ...
    }

    #[test]
    fn test_median() {
        let v: Vec<i32> = vec![1, 3, 4, 2, 5, -5, 6];
        assert_eq!(super::median(&v), 3.0);

        // ...
    }
}
```

## High-performance computing

One of the main purposes of my project was to explore the potential for concurrency and high-performance computing to speed up computationally expensive operations. The two main challenges that I faced in working towards this goal are in implementing CPU-bound concurrency and allowing Rust to work with Python objects.

### Thread-level concurrency

One of my first experiments with multithreading in Rust was to try multiplying every element of a vector by two concurrently:

```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3, 4, 5, 6, 7, 8];

    let chunks = v.chunks(3);

    let output = chunks
        .map(|chunk| thread::spawn(move || multiply_two(&chunk)))
        .map(|handle| handle.join().unwrap())
        .reduce(|a, b| [a, b].concat())
        .unwrap();

    println!("{:?}", output);
}

fn multiply_two(chunk: &[i32]) -> Vec<i32> {
    chunk.iter().map(|x| x * 2).collect()
}
```

But this code doesn't work. The Rust compiler gives us this cryptic error:

```
error[E0597]: `v` does not live long enough
  --> src/main.rs:6:18
   |
4  |     let v = vec![1, 2, 3, 4, 5, 6, 7, 8];
   |         - binding `v` declared here
5  |
6  |     let chunks = v.chunks(3);
   |                  ^^^^^^^^^^^ borrowed value does not live long enough
...
9  |         .map(|chunk| thread::spawn(move || multiply_two(&chunk)))
   |                      ------------------------------------------- argument requires that `v` is borrowed for `'static`
...
15 | }
   | - `v` dropped here while still borrowed

For more information about this error, try `rustc --explain E0597`.
```

Hmm. Apparently, `v` doesn't live long enough, but it really looks like it does. However, one thing I learned about concurrency during this project is that the threads that we spawn here might actually outlive the `main` thread, which will drop `v` after it goes out of scope. Therefore, we need to use a scoped thread, with a scope that ends before the `main` function's scope ends:

```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3, 4, 5, 6, 7, 8];

    let chunks = v.chunks(3);

    thread::scope(|s| {
        let output = chunks
            .map(|chunk| s.spawn(move || multiply_two(&chunk)))
            .map(|handle| handle.join().unwrap())
            .reduce(|a, b| [a, b].concat())
            .unwrap();

        println!("{:?}", output);
    });
}

fn multiply_two(chunk: &[i32]) -> Vec<i32> {
    chunk.iter().map(|x| x * 2).collect()
}
```

Finally, one slightly more complicated example is an example where I concurrently count the frequency of characters in a list of words:

```rust
use std::cmp;
use std::collections::HashMap;
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    if input.is_empty() {
        return HashMap::<char, usize>::new();
    }

    let worker_count = cmp::min(worker_count, input.len());

    let chunks = input.chunks(worker_count);

    let mut output = HashMap::<char, usize>::new();
    thread::scope(|s| {
        output = chunks
            .map(|chunk| s.spawn(move || count_frequencies(&chunk)))
            .map(|handle| handle.join().unwrap())
            .reduce(|a, b| combine_maps(a, b))
            .unwrap();
    });

    output
}

fn count_frequencies(chunk: &[&str]) -> HashMap<char, usize> {
    let mut frequencies = HashMap::<char, usize>::new();

    for &word in chunk {
        for c in word
            .to_lowercase()
            .chars()
            .filter(|c| !c.is_digit(10) && !c.is_ascii_punctuation())
        {
            match frequencies.get(&c) {
                Some(count) => frequencies.insert(c, count + 1),
                None => frequencies.insert(c, 1),
            };
        }
    }

    frequencies
}

fn combine_maps(a: HashMap<char, usize>, b: HashMap<char, usize>) -> HashMap<char, usize> {
    let mut combined: HashMap<char, usize> = a.clone();

    for (key, value) in b.iter() {
        match combined.get(key) {
            Some(count) => combined.insert(*key, count + value),
            None => combined.insert(*key, *value),
        };
    }

    combined
}

fn main() {}
```

The general strategy is to map each chunk to a thread and reduce their outputs by adding the `HashMap`s together. More recently, people have been using the lightweight `rayon` crate for easier-to-use concurrency, which is what I might end up doing for my project.

### PyO3 bindings

Another challenge that I faced with this project was learning how to access the Farama Foundation's `gymnasium` environments through Rust. The Rust programming language has a large centralized set of packages, called crates, at [crates.io](https://crates.io). This makes it incredibly easy to collaborate and use existing code from another project. For example, in order to use a prior implementation of the $k$-nearest neighbors algorithm, I only needed to add this line to my `Cargo.toml` file:

```toml
[dependencies]
# ...
knn = "0.1.3"
```

Then, in my Rust code, I could get started using the package immediately and trust that `cargo` (Rust's package manager) would handle the rest:

```rust
extern crate knn;

// ...

use knn::PointCloud;

// ...

let mut pc = PointCloud::new(euclidean_distance);

// ...
```

In my opinion, `cargo` is better than `pip` or `conda` and definitely better than the hack-y solution to package management that C++ takes.

For my RIPS project, I wanted to use the actual `gymnasium` environments in Python and not a Rust port of similar environments so that I could correctly benchmark my algorithms. In this vein, the crate I ended up choosing to use is [PyO3](https://pyo3.rs/v0.19.1/), which provides bindings for running Python code and writing Python packages. Having to keep track of many Python types is difficult, but this approach is the most extensible to other games. Here's a little code snippet that's prototypical of the work that I recently did with PyO3:

```rust
let (_, _, terminated, truncated, _) = self
  .env
  .call_method("step", (action,), None)
  .unwrap()
  .extract::<(&PyArray<f32, Ix1>, f32, bool, bool, &PyDict)>()
  .unwrap();
```

To get PyO3 to work with a virtual environment, I needed to activate the environment and change the `$PYTHONPATH` environment variable to force PyO3 to search my local directory for Python packages first. Doing this each time grew to be slightly irksome, so I wrote up a brief shell script that automates the setup process:

```bash
#!/bin/bash

source .env/bin/activate
export PYTHONPATH=$PYTHONPATH:$(pwd)/.env/lib/python3.11/site-packages
```

Just from rewriting our codebase in Rust, I was able to shave down our solution time for CartPole by over half (the agent survives 1000 iterations in 3.6 seconds where this previously took 7.7 seconds in Python). In addition, PyO3 allows you to release Python's GIL and run concurrent Python code, which is the next step for my work at RIPS. This will likely not provide any gains (if at all) for CartPole, but it will likely become more helpful in solving more complex games like Pong or PacMan.

## Final thoughts

Rust has been topping the [StackOverflow developer survey](https://survey.stackoverflow.co/2022) as the most beloved language for several years now. Having now worked with it extensively, I think I understand why. Rust is a fast compiled language, but finds more elegant solutions than existing languages to memory safety, thread safety, and garbage collection. It has an excellent package manager and helpful error messages. It almost feels like Rust's ownership and borrowing system was built for concurrency, and immutability by default can avoid a lot of hassle with mutex locks and race conditions.

A lot of code is functional and elegant, but Rust makes sure that the programmer is aware of many potential sources of error. As one example, `f32` does not implement the `Ord` trait, only because it's not fully clear what to do with `f32::NAN` values. This makes it harder to sort a `Vec<f32>` object, but in return, the programmer knows exactly what's going on under the hood. Things like this make Rust a pleasure to program in, and I'm looking forward to writing more Rust code in the near future.
