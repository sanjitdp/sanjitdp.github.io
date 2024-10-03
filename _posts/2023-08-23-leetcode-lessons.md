---
layout: note
title: A few programming lessons from LeetCode
date: 2023-08-23
categories: [algorithms]
tags: [data-structures, algorithms, cs]
math: true
comments: true
---

In the past three weeks, I've solved over 130 problems on [LeetCode](https://leetcode.com), a popular site for competitive programming which contains thousands of fun problems on data structures and algorithms. The problems on LeetCode are divided into three categories: Easy, Medium, and Hard. Many of these problems (or problems in a similar style) tend to appear in software engineering interviews, so LeetCode has sort of become a cultural part of the computer science major at university.

Many people seem to think of LeetCode as difficult; this makes sense, since many problems seem unapproachable at first glance even for those who have taken a class in data structures and algorithms. However, like anything else, I think LeetCode is just a game; you play enough rounds and you start to see some patterns emerge which render most problems much easier. In this post, I want to discuss some of the most important lessons and tricks I learned from my experience so far on the site.

First, many thanks to my good friend [Jack Rankin](https://github.com/jackrankin), who was my teammate at the [IPAM RIPS program](https://www.ipam.ucla.edu/programs/student-research-programs/research-in-industrial-projects-for-students-rips-2023-los-angeles/) this summer. Jack taught me many of these tricks; I'm certain this process would have taken me much longer without the generous help and friendly competition that he provided.

## Picking the right data structure

Lesson one: most Easy problems can be solved just by picking an appropriate data structure. For instance, take the first problem on the site, which is called [Two Sum](https://leetcode.com/problems/two-sum/). In this question, we're asked to find two unique elements in an array which sum to a given `target` value and return their indices. Additionally, we are guaranteed that there is exactly one solution. This constraint is important, since we no longer need to worry about the case when there are not two numbers which sum to `target`.

A naive approach would be to search through all pairs of elements and see if they sum to `target`.

```python
def twoSum(self, nums: List[int], target: int) -> List[int]:
    for i in range(len(nums)):
        for j in range(i + 1, len(nums)):
            if nums[i] + nums[j] == target:
                return (i, j)
```

Now, this approach is $O(n^2)$ in time complexity and $O(n)$ in space complexity (to store the original array). It's good to know this so that we have a baseline for any future approaches we take.

Next, let's try a new approach using a hash set. If we have a set of values, we only need to query whether `target - num` is in the set for each number in `nums`. This approach is fast, since querying takes $O(1)$ time using a set. The only problem with this approach is that we can't get the indices of the associated elements which sum to `target`. But now we can solve this problem using a dictionary, mapping each element to its index.

```python
def twoSum(self, nums: List[int], target: int) -> List[int]:
    d = {}

    for i in range(len(nums)):
        if target - nums[i] in d:
            return (d[target - nums[i]], i)
        d[nums[i]] = i
```

This approach is $O(n)$ in both time and space complexity, which is definitely the best we can do. Now, Two Sum would have been much easier if you were told at the start that it was a dictionary problem, which is why a lot of my time on LeetCode was just spent building intuition for guessing the appropriate data structure for a problem.

In fact, this may seem like a silly lesson to have learned, but many Medium and Hard problems can be solved this way as well. For instance, take [Merge $k$ Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/), in which we're asked to merge $k$ sorted linked lists into one large linked list. This problem is classified as Hard, and one approach is to merge lists pairwise (as in the MergeSort algorithm) until we arrive at a larger sorted list. This is doable, but it's a little annoying to write the associated code.

```python
def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
    dummy = ListNode(float("-inf"), None)

    if not lists:
        return None
    
    dummy.next = lists.pop()
    while lists:
        curr_list = lists.pop()
        l = dummy
        r = curr_list

        if not r:
            continue
            
        if l.val < r.val:
            head = l
            l = l.next
        else:
            head = r
            r = r.next

        curr = head
        while True:
            if not r:
                curr.next = l
                break
            if not l:
                curr.next = r
                break
            
            if l.val < r.val:
                nxt = curr.next
                l_nxt = l.next

                curr.next = l
                l.next = nxt

                l = l_nxt
            else:
                nxt = curr.next
                r_nxt = r.next

                curr.next = r
                r.next = nxt

                r = r_nxt
            curr = curr.next
    return dummy.next
```

This algorithm runs in 4284 milliseconds, and only beats 7.68% of solutions in runtime on LeetCode. However, this problem is incredibly easy to solve if I give you the data structure: it's a heap problem. Now it's clear what to do; we need to push all the values onto a heap and iteratively pop from the heap to get the next list node. Now the code is really easy to write:

```python
def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
    h = []
    for l in lists:
        while l:
            heappush(h, (l.val, l))
            l = l.next
    
    dummy = ListNode(0, None)
    curr = dummy
    while h:
        curr.next = heappop(h)[1]
        curr = curr.next
    
    return dummy.next
```

This seems like it will work, but we get an annoying `TypeError: '<' not supported between instances of 'ListNode' and 'ListNode'`. What's happening here? Python uses a lexicographic order on tuples, which sorts by the first dimension, then breaks ties using the second dimension, the third dimension, and so on. Some nodes have the same value, so Python is trying to break ties using the `ListNode` objects, which are not ordered. We can avoid this by giving Python an additional dimension by which it can break ties between two nodes with the same value.

```python
def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
    h = []
    i = 0
    for l in lists:
        while l:
            heappush(h, (l.val, i, l))
            l = l.next
            i += 1
    
    dummy = ListNode(0, None)
    curr = dummy
    while h:
        curr.next = heappop(h)[2]
        curr = curr.next
    
    return dummy.next
```

Now this approach runs in 69 milliseconds and beats 99.87% of other solutions. The general principle at play is that a heap allows fast `push` and `pop` operations in $O(\log(n))$ time, so HeapSort is an easy way to merge lists. Eventually, I learned many of these principles through experience with a variety of different problems on LeetCode.

## Two-pointer problems

One common approach in LeetCode problems is to use two pointers. This approach works well whenever the input container has some sort of monotonicity property (e.g., a sorted array, a binary search tree, etc.). For instance, consider the problem [Two Sum II](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/). This problem is the same as Two Sum (described above) but we are given a sorted input array. We could try the same approach as we did in Two Sum, which would create a dictionary mapping each element to its index. However, this approach would require $O(n)$ additional space, which we don't need here. 

Instead, another approach is to use two pointers. We maintain a `left` pointer (starting at the leftmost element of the array) and a `right` pointer (starting at the rightmost element of the array). The goal is to make the `left` and `right` pointers point respectively to elements which sum to `target`. If `left + right > target`, we know that the `right` pointer needs to be decremented. In particular, we know that there is no scenario in which the larger number in the solution is greater than or equal to the element behind the `right` pointer. Similarly, the `left` pointer needs to be incremented if `left + right < target`.

```python
def twoSum(self, numbers: List[int], target: int) -> List[int]:
    i = 0
    j = len(numbers) - 1

    while True:
        if numbers[i] + numbers[j] > target:
            j -= 1
        elif numbers[i] + numbers[j] < target:
            i += 1
        else:
            return [i + 1, j + 1]
```

This is much better, because we only use $O(1)$ additional space. This "two-pointer" pattern shows up all over the place on LeetCode, and it's a good one to keep in mind.

## Sliding window problems

Another common trick is to use a sliding window which slides across all "valid" subarrays. One classic example of this is the Medium problem [Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/). Given a string `s`, we want to find the longest contiguous substring without repeating characters. The idea is to use a sliding window from index `i` to index `j`. As long as there are no repeated characters, we increment `j`. If there is a repeated character, we increment `i` until there are no longer any repeats. This technique is guaranteed to find all candidates, since we find the longest substrings ending at the characters `s[j]` for `0 <= j < n`. Furthermore, since `i` and `j` are both being incremented from `0` to `n - 1`, this sliding window algorithm takes only $O(n)$ time.

```python
def lengthOfLongestSubstring(self, s: str) -> int:
    if not s:
        return 0
    
    i = 0
    seen_so_far = set()
    output = 0

    for j in range(len(s)):
        if s[j] in seen_so_far:
            while s[i] != s[j]:
                seen_so_far.remove(s[i])
                i += 1
            i += 1
        else:
            seen_so_far.add(s[j])
            output = max(output, len(seen_so_far))

    return output
```

This trick appears relatively frequently in subarray and substring questions, so it should be kept in mind.

## Binary search

Binary search in a sorted array is simple enough (despite all the annoying off-by-one errors you inevitably get), and Python even provides built-in functions `bisect_left()` and `bisect_right()` that do this for you. However, some neater applications of binary search are in solving "maximality" questions. If we're asked to find a maximal $k$ so that a property holds, we could just binary search over the whole range of $k$ and see if the property holds for each value of $k$ that we try; this automatically gives an algorithm which has a logarithmic dependence on the size of $k$'s range!

One easy example of this is the Medium problem [H-index II](https://leetcode.com/problems/h-index-ii/description/). The `h`-index is defined as the maximal number such that a researcher has at least `h` papers with more than `h` citations. Given a list of a researcher's citation numbers sorted in ascending order, we want to find their `h`-index.

A naive idea is to iterate from the back of the `citations` array and check whether the current citation number is still larger than the number of papers we've included. This is an $O(h)$ algorithm, but we can do better. Instead, we binary search over all possible values of `h` and check whether each value is feasible in constant time; this is an $O(\log(n))$ algorithm.

```python
def hIndex(self, citations: List[int]) -> int:
    n = len(citations)
    
    l = 0
    r = n
    h = 0
    while l <= r:
        mid = (l + r) // 2
        if mid == 0:
            l = 1
        elif citations[n-mid] >= mid:
            h = mid
            l = mid + 1
        else:
            r = mid - 1
    
    return h
```

In many problems (think questions in the family of maximum subarray) the optimal algorithm may be something like an $O(n)$ monotonic deque, which can be hard to come up with. On the other hand, you can easily get an $O(n \log(n))$ algorithm instead of an $O(n^2)$ algorithm without much thought using binary search, which can be a useful first step on these questions.

## Graph algorithms

A lot of graph algorithms are just recursive, and don't require much thought. First trick: the easiest way to deal with a graph is to immediately convert it to an adjacency list. This is fast and makes it easier to perform more complex algorithms on the graph. After this, the most common patterns in more involved graph questions tend to be simple search algorithms, especially depth-first search.

### Depth-first search (DFS)

Depth-first search is the simplest algorithm possible to traverse a graph. The way I remember DFS is by the associated data structure: it's just a stack algorithm. We keep a stack which represents the path we took to get to a particular node, and we pop from the stack if there are no more valid outgoing edges. In addition, we often keep a copy of the stack in the form of a hash set, which allows us to efficiently check if a vertex has been visited already and avoid cycles. Sometimes we keep track of the stack explicitly; other times, we write a recursive function and represent the stack implicitly using the function call stack. DFS is a simple algorithm, but it has many clever applications in LeetCode problems.

One example of a DFS problem is the Medium problem [Course Schedule](https://leetcode.com/problems/course-schedule/). In this problem, there are `numCourses` courses, numbered from `0` to `numCourses - 1`. We are also given a list of prerequisites `[a_i, b_i]`, where `b_i` is a prerequisite to take course `a_i`. We need to return `True` if it is possible to finish all courses, and `False` otherwise. The first insight is that the only reason why this would not be possible is if there is a cycle in the prerequisite graph. The second insight is that DFS can be easily adapted to perform cycle-checking; if we are ever able to traverse to a node already in the stack, there must be a cycle. This leads to the following code.

```python
def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
    adj_list = defaultdict(list)

    for edge in prerequisites:
        adj_list[edge[0]].append(edge[1])
    
    @cache
    def no_cycle(course):
        if course in self.checking:
            return False
        
        self.checking.add(course)

        temp = all(no_cycle(c) for c in adj_list[course])
        self.checking.remove(course)
        
        return temp

    for course in range(numCourses):
        self.checking = set()
        if not no_cycle(course):
            return False
    
    return True
```

DFS is also used for connected component detection. One example of this is the [Number of Islands](https://leetcode.com/problems/number-of-islands/) problem, which is a Medium. In this problem, we have a grid containing `"0"`s and `"1"`s, where `"1"`s represent land and `"0"`s represent water. An island is defined to be a patch of land which is connected vertically and horizontally, and the problem is to count the number of islands. The way to solve the problem is to perform a depth-first search from each piece of land and count the number of islands we find. One further optimization is that instead of keeping a `seen` set as above, we can modify the input in-place (changing `"1"`s to `"0"`s as we traverse) to keep track of our search.

```python
def numIslands(self, grid: List[List[str]]) -> int:
    m = len(grid)
    n = len(grid[0])

    def dfs(i, j):
        if not (0 <= i < m and 0 <= j < n) or grid[i][j] != "1":
            return
        grid[i][j] = "0"
        for offset in {-1, 1}:
            dfs(i + offset, j)
            dfs(i, j + offset)

    count = 0
    for i in range(m):
        for j in range(n):
            if grid[i][j] != "0":
                dfs(i, j)
                count += 1

    return count
```

DFS is used in many other places, and is typically the first thing I think of when I see a new graph question.

### Breadth-first search (BFS)

Similarly, I remember BFS by the associated data structure: a queue. We pop the front node from a queue, append its children to the back of the queue, and continue recursively. For instance, BFS can be used to find the shortest path to any node or perform a level-order traversal of a tree or a graph (a traversal by distance from the root). One problem which uses BFS is [Binary Tree Level Order Traversal](https://leetcode.com/problems/binary-tree-level-order-traversal/). Note that a level-order traversal is just a BFS where the queue is processed in phases by distance from the root.

```python
def levelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
    if not root:
        return []
    
    frontier = deque([root])
    lot = []
    curr = []
    while frontier:
        y = len(frontier)
        for _ in range(y):
            x = frontier.popleft()
            curr.append(x.val)
            if x.left:
                frontier.append(x.left)
            if x.right:
                frontier.append(x.right)
        
        lot.append(curr)
        curr = []
    
    return lot
```

## Binary trees

Most tree algorithms are either flat-out recursive or an application of one of the above search algorithms. Consider the Easy problem [Same Tree](https://leetcode.com/problems/same-tree/), where we're asked to determine whether two binary trees are identical.

```python
def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
    if not p:
        return not q
    
    if not q:
        return not p
    
    return p.val == q.val and self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```

Other common patterns for binary tree problems include using the preorder, inorder, or postorder traversals. The preorder traversal processes the root node, then the left subtree, then the right subtree. It is useful because it is the most intuitive way to process a tree. The inorder traversal processes the left subtree, then the root node, then the right subtree. Finally, the postorder traversal processes the left subtree, then the right subtree, then the current node.

Preorder traversals are useful because they are the most intuitive way to process a binary tree and correspond to a DFS. The inorder traversal is useful because it effectively sorts the elements of a binary search tree. As for postorder traversals, Jack Rankin once told me, "all my homies hate postorder traversals". He was unfortunately correct -- postorder traversals are not very useful. One example application of an inorder traversal is the Medium problem [Kth Smallest Element in a BST](https://leetcode.com/problems/kth-smallest-element-in-a-bst/), which corresponds exactly to the $k$th element in the inorder traversal.

```python
def kthSmallest(self, root: Optional[TreeNode], k: int) -> int:
    counter = 0

    def dfs(x):
        nonlocal counter

        if x is None:
            return

        y = dfs(x.left)
        if y is not None:
            return y
        
        counter += 1
        if counter == k:
            return x.val
            
        y = dfs(x.right)
        if y is not None:
            return y
    
    return dfs(root)
```

Note that the other traversals also correspond to a DFS, but we just change when we process the current node.

## Dynamic programming (DP)

Dynamic programming is just the process of reducing a problem into subproblems, memorizing the solutions to any subproblems for easier reuse, and combining the subproblem solutions into a solution of the larger problem. Technically, this is top-down DP; bottom-up DP is generating the solutions to the subproblems and iteratively building up a solution to the larger problem. DP problems are generally pretty easy in my opinion, and it usually boils down to finding an appropriate subproblem to solve. Jack Rankin loves to point out that DP is equivalent to performing a DFS (which is sometimes a useful intuition to have). We try something, see if we can make it work, and then backtrack.

### 1-D dynamic programming

As an example, consider the problem [Coin Change](https://leetcode.com/problems/coin-change/). Given an `amount`, we need to return the fewest number of coins from `coins` that we need to make `amount`, assuming we have an infinite amount of each coin. This is a classic DP problem, and I solved it using top-down DP. One optimization that can be made is that if we sort `coins`, we can stop considering coins which have amount larger than `n` in the DP.

```python
def coinChange(self, coins: List[int], amount: int) -> int:
    coins.sort()

    @cache
    def dp(n):
        if n == 0:
            return 0

        fewest_coins = float("inf")
        for coin in coins:
            if coin > n:
                break
            fewest_coins = min(1 + dp(n - coin), fewest_coins)
        
        return fewest_coins
```

Another example of a DP problem is the Medium problem [Decode Ways](https://leetcode.com/problems/decode-ways/). In this problem, a message containing capital letters can be encoded via the mapping `"A" -> "1", ..., "Z" -> "26"`. Given an encoded string `s`, we need to find the number of original messages that it could have come from. Bottom-up DP is usually more efficient, but I always start by trying a top-down DP solution. Here, the DP is the number of possible original original strings that could have created `s[n:]`. We can either choose to include the current digit as a unit, or include the next two digits as a unit. Using this approach, we arrive at a top-down solution.

```python
def numDecodings(self, s: str) -> int:
    @cache
    def dp(n):
        if n == len(s):
            return 1
        total = 0
        if s[n] in decodings:
            total += dp(n+1)
        if n < len(s) - 1 and s[n:n+2] in decodings:
            total += dp(n+2)
        return total

    return dp(0)
```

Then, it becomes easy to come up with the bottom-up DP solution, which I find less intuitive to write from scratch.

```python
def numDecodings(self, s: str) -> int:
    dp = [1 <= int(s[-1]) <= 26, 1]
    for i in range(1, len(s)):
        x = len(s) - 1 - i
        total = dp[0] * (1 <= int(s[x]) <= 26) + dp[1] * (s[x] != "0" and 1 <= int(s[x:x+2]) <= 26)
        dp[1] =  dp[0]
        dp[0] = total

    return int(dp[0])
```

### 2-D dynamic programming

In fact, many two-dimensional DP problems can be solved using similar approaches. For instance, consider the Medium problem [Longest Common Subsequence](https://leetcode.com/problems/longest-common-subsequence/description/), in which we need to return the length of longest common subsequence of two strings `text1` and `text2` (here, the subsequence doesn't need to be contiguous). As usual, I start with a top-down DP approach, where the DP is over the longest common subsequence in `text1[m:]` and `text2[n:]`. Then, we can case over whether the `text1[m]` and `text2[n]` are equal and use the subproblem solutions for larger `m` and `n`.

```python
def longestCommonSubsequence(self, text1: str, text2: str) -> int:
    @cache
    def dp(m, n):
        if m == len(text1) or n == len(text2):
            return 0
        
        skip_curr = max(dp(m + 1, n), dp(m, n + 1))
        if text1[m] != text2[n]:
            return skip_curr
        else:
            return max(skip_curr, 1 + dp(m + 1, n + 1))
    
    return dp(0, 0)
```

For reference, this solution runs in 2172 milliseconds and only beats 5.46% of solution runtimes for this problem. I then rewrote my solution using bottom-up DP.

```python
def longestCommonSubsequence(self, text1: str, text2: str) -> int:
    dp = [[0] * (len(text2) + 1) for _ in range(len(text1) + 1)]
    
    for m in range(len(text1) - 1, -1, -1):
        for n in range(len(text2) - 1, -1, -1):
            if text1[m] == text2[n]:
                dp[m][n] = max(dp[m+1][n], dp[m][n+1], 1+dp[m+1][n+1])
            else:
                dp[m][n] = max(dp[m+1][n], dp[m][n+1])
    
    return dp[0][0]
```

Now, this solution runs in only 670 milliseconds and beats 70.69% of solutions to this problem.

## Prefix-suffix patterns

Yet another common pattern is to do some computation for the prefixes and suffixes of an array and use these to build a solution. For instance, take the problem [Product of Array Except Self](https://leetcode.com/problems/product-of-array-except-self/). In this problem, we are given an array `nums` and we want to create a new array which has `i`th element consisting of the product of all other elements in `nums` in $O(n)$ time without using the `/` operator. We're going to compute the prefix products and the suffix products, and then the problem will become easy. This might sort of seem like a clever ad-hoc solution, but it's a pattern which shows up in many LeetCode problems.

```python
def productExceptSelf(self, nums: List[int]) -> List[int]:
    forward_products = [1]
    for num in nums:
        forward_products.append(forward_products[-1] * num)

    reverse_products = [1]
    for num in nums[::-1]:
        reverse_products.append(reverse_products[-1] * num)

    n = len(nums)
    return [forward_products[i] * reverse_products[n-i-1] for i in range(n)]
```

One minor optimization we can make now that we have a solution is to build the output array as we compute the reverse products.

```python
def productExceptSelf(self, nums: List[int]) -> List[int]:
    n = len(nums)

    products = [1] * (n-1) + [nums[-1]] + [1]
    for i in range(1, n):
        products[n-i-1] = products[n-i] * nums[-i-1]

    products[0] = 1

    output = [0] * n
    for i in range(n):
        output[i] = products[i+1] * products[i]
        products[i+1] = products[i] * nums[i]

    return output
```

However, this problem is really just a prefix-suffix problem at heart.

## Linked lists

With linked lists, one common trick is to use fast and slow pointers. One example of this is the Medium problem [Remove Nth Node From End of List](https://leetcode.com/problems/remove-nth-node-from-end-of-list/), wherein we would like to remove the $n$ th node from the back of a linked list. To find the $n$ th node from the end of a linked list, we can maintain a fast pointer which has a headstart by $n$ vertices. Then, we allow the fast and slow pointers to traverse, and as the fast pointer finishes processing the list, the slow pointer will be at the $n$th node from the end.

```python
def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
    fast = head
    slow = head
    for _ in range(n):
        fast = fast.next
    
    if fast is None:
        return head.next
    
    while fast.next is not None:
        fast = fast.next
        slow = slow.next
    
    slow.next = slow.next.next

    return head
```

### Cycle detection

One neat cycle detection algorithm for lists is [Floyd's algorithm](https://en.wikipedia.org/wiki/Cycle_detection), which uses a tortoise-hare paradigm. A fast and a slow pointer start from the root node; the fast pointer increments twice and the slow pointer increments once with each iteration. Then, if there is a cycle, the slow pointer will catch up to the fast pointer at some point. I wasn't convinced of this the first time I heard it, so here's a quick proof. Suppose there's a cycle of length $N$. Eventually, both the fast and slow pointers will get caught in this cycle; at this point, suppose the fast pointer is $k$ ahead of the slow pointer. Essentially, we're now solving the congruence $i \equiv 2i + k \pmod N \iff i \equiv -k \pmod N$. But we know this will happen after $i = N - k$ steps! In particular, we're guaranteed to find a cycle in $O(n)$ time, which is the best that we could hope for.

One application of this algorithm is in the Easy problem [Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/description/). Given a linked list, we're asked to find whether it contains a cycle. This is a perfect application for Floyd's algorithm, and the code is shown below.

```python
def hasCycle(self, head: Optional[ListNode]) -> bool:
    fast = head
    slow = head

    while fast is not None and fast.next is not None:
        fast = fast.next.next
        if fast == slow:
            return True
        slow = slow.next
        if fast == slow:
            return True
    
    return False
```

### Dummy nodes

Another common trick in linked list questions is to use a dummy node when there's no clear start for a list. One instance where we might use a dummy node is in the Easy problem [Merge Two Sorted Lists](https://leetcode.com/problems/merge-two-sorted-lists/description/), where we are given two sorted linked lists and need to merge them into one large linked list.

```python
def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
    l = list1
    r = list2

    dummy = ListNode(float("-inf"), None)

    curr = dummy
    while True:
        if not r:
            curr.next = l
            break
        if not l:
            curr.next = r
            break
        
        if l.val < r.val:
            nxt = curr.next
            l_nxt = l.next

            curr.next = l
            l.next = nxt

            l = l_nxt
        else:
            nxt = curr.next
            r_nxt = r.next

            curr.next = r
            r.next = nxt

            r = r_nxt
        
        curr = curr.next

    return dummy.next
```

The most common linked list patterns are just to play around with pointers; I think most of what needs to be done here is pretty intuitive. In general, we can use reversing a linked list and merging linked lists as black-box operations to build more complex algorithms.

## Priority queues (heaps)

Priority queues, or heaps, are commonly used when we need to find the smallest element (or smallest $k$ elements) but not necessarily sort the list. Heapification of an array only takes $O(n)$ time, while pushing to and popping from a heap can be done in $O(\log(n))$ time. Therefore, for instance, finding the $k$ largest elements in an array can be done in $O(k \log(n))$ time using a heap. A heap is represented as a complete binary tree, which can be represented easily as an array containing the level-order traversal of the tree. Heapification is pretty cool, so I might write a brief post on heaps at some point later.

### Dijkstra's algorithm

Dijkstra's algorithm is a classic algorithm for finding shortest paths in graphs with positive weights. This algorithm was introduced to me in both my discrete math class and my data structures and algorithms class as some sort of extremely clever algorithm. However, it's really not special -- it's just that the problem of finding the shortest path is easiest using a priority queue. We keep a priority queue of outgoing edges from our current set of vertices and process the edges with least total weight first. This way, we ensure that we have found the shortest possible path to any vertex in our current set.

### Prim's algorithm

Prim's algorithm is a technique for computing the minimal spanning tree. It has a fancy name, but it's basically the same as Dijkstra's algorithm. We pick a root arbitrarily, and add all outgoing edges from our current tree into a priority queue. Then, we pop the minimum weight edge, follow it, and add the associated node to our tree with the given edge. Repeating this process, we can grow a minimal spanning tree. Prim's algorithm can be made more efficient in the long-run using a fancier data structure: the Fibonacci heap. However, this data structure and others like it are harder to program correctly and don't offer much of a speed-up (if any) over a traditional heap in practice.

### Max-min heap pairs

We can use a max-heap and min-heap pair to keep track of order statistics in an online fashion. For instance, take the Hard problem [Find Median from Data Stream](https://leetcode.com/problems/find-median-from-data-stream/). We need to implement a data structure which supports adding a number and finding the median of all current numbers. We solve the problem by keeping a max-heap of all elements smaller than the median and a min-heap of all elements larger than the median, ensuring that both of these heaps stay balanced in their number of elements.

```python
def __init__(self):
    self.minheap = []
    self.maxheap = []

def addNum(self, num: int) -> None:
    if len(self.minheap) + len(self.maxheap) == 0:
        heappush(self.minheap, num)
    elif len(self.minheap) <= len(self.maxheap):
        heappush(self.minheap, num)
        if self.minheap[0] < -self.maxheap[0]:
            heappush(self.maxheap, -heappop(self.minheap))
            heappush(self.minheap, -heappop(self.maxheap))
    else:
        heappush(self.maxheap, -num)
        if self.minheap[0] < -self.maxheap[0]:
            heappush(self.maxheap, -heappop(self.minheap))
            heappush(self.minheap, -heappop(self.maxheap))

def findMedian(self) -> float:
    if len(self.minheap) > len(self.maxheap):
        return self.minheap[0]
    else:
        return (self.minheap[0] - self.maxheap[0]) / 2
```

## Prefix trees ("tries")

Prefix trees, or tries, are trees which represent objects like dictionaries for fast prefix lookup. Each trie contains 27 subtries, which represent each letter along with a special "end of word" character. For instance, `"a"` maps to a trie which represents all words which start with the letter `"a"`, and so forth. Here's my implementation of a `Trie` object, which solves the Medium problem [Implement Trie (Prefix Tree)](https://leetcode.com/problems/implement-trie-prefix-tree/).

```python
class Trie:
    def __init__(self):
        self.subtries = {}
        
    def insert(self, word: str) -> None:
        curr = self
        for c in word:
            if c not in curr.subtries:
                curr.subtries[c] = Trie()
            curr = curr.subtries[c]
        
        curr.subtries['\n'] = None

    def search(self, word: str) -> bool:
        curr = self
        for c in word:
            if c not in curr.subtries:
                return False
            curr = curr.subtries[c]
        
        return '\n' in curr.subtries
        
    def startsWith(self, prefix: str) -> bool:
        curr = self
        for c in prefix:
            if c not in curr.subtries:
                return False
            curr = curr.subtries[c]
        
        return True
```

Tries can be used in games like word search for fast lookup. For instance, the Hard problem [Word Search II](https://leetcode.com/problems/word-search-ii/) asks us to find a list of all words on a given board, where a word is constructed from sequentially adjacent cells with no repeats. Here, we store all of the given words in a tree and then use DFS to efficiently find all of the words on the board.

```python
def findWords(self, board: List[List[str]], words: List[str]) -> List[str]:
    trie = {}
    for word in words:
        curr = trie
        for c in word:
            if c not in curr:
                curr[c] = {}
            curr = curr[c]
        
        curr['\n'] = word
    
    n = len(board)
    m = len(board[0])
    self.all_words = []
    def dfs(i, j, trie):
        if board[i][j] not in trie:
            return

        trie = trie[board[i][j]]
        if not trie:
            return
        
        old_char = board[i][j]
        board[i][j] = '!'

        if '\n' in trie:
            self.all_words.append(trie['\n'])
            del trie['\n']
        for x_offset in {-1, 1}:
            if 0 <= i + x_offset < n:
                dfs(i + x_offset, j, trie)
        for y_offset in {-1, 1}:
            if 0 <= j + y_offset < m:
                dfs(i, j + y_offset, trie)
        
        board[i][j] = old_char

    for i in range(n):
        for j in range(m):
            dfs(i, j, trie)
    
    return self.all_words
```

## Stacks

One common application for stacks is in processing things like parentheses and operators (as in a calculator, for example). As an example, the Easy problem [Valid Parentheses](https://leetcode.com/problems/valid-parentheses/), where we are asked to determine whether the given string constitutes a valid set of matching parentheses, can be solved very easily using a stack.

```python
def isValid(self, s: str) -> bool:
    close_to_open = {'}': '{', ')': '(', ']': '['}

    open_parens = set(close_to_open.values())

    stack = []
    for c in s:
        if c in open_parens:
            stack.append(c)
        else:
            if not stack or stack.pop() != close_to_open[c]:
                return False
    
    return not stack
```

## Monotonic stacks + deques

This is perhaps one of the coolest tricks on the list, since it isn't really taught in a standard data structures and algorithms class but is relatively common on LeetCode. Monotonic stacks and monotonic deques are stacks and deques respectively which maintain the property that they are always sorted (and typically maintain an additional monotonicity property as well, sometimes with respect to indices in an array). If we want to insert an element, we need to pop off elements until the inserted element respects the monotonicity property.

One example of a monotonic deque application is the Hard problem [Sliding Window Maximum](https://leetcode.com/problems/sliding-window-maximum/). In this problem, we are given an array nums and a number `k`. As a sliding window of size `k` moves across `nums`, we need to return an array containing the maximum of the elements contained in the sliding window at each point. The idea is to initialize a deque and push the first `k` indices into the deque. As we push each index, if `nums` at the leftmost index is less than nums at the current index, we pop it off of the deque.

Therefore, the deque will be monotonically increasing with respect to the associated values of `nums`. Furthermore, it will simultaneously respect a monotonically decreasing property with respect to the indices themselves. We continue this process for all elements in the array and append to our output array accordingly. At each step, we pop from the back of the deque until the queue only contains indices which are within the last `k` indices (the current sliding window).

```python
def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
    d = deque()

    for i in range(k):
        while d and nums[d[0]] <= nums[i]:
            d.popleft()

        d.appendleft(i)

    output = [nums[d[-1]]] + [0] * (len(nums) - k)

    for i in range(k, len(nums)):
        while d and nums[d[0]] <= nums[i]:
            d.popleft()
        
        while d and d[-1] <= i - k:
            d.pop()

        d.appendleft(i)
        output[i - k + 1] = nums[d[-1]]

    return output
```

Monotonic stacks and deques are definitely more complicated than some of the other data structures I've mentioned. However, once you have the idea to use one of these structures, it's usually not too hard to figure out how it can be used.

## Interval problems

Most interval problems can be made much easier by sorting the intervals by start time or by end time. For instance, take the Medium problem [Merge Intervals](https://leetcode.com/problems/merge-intervals/). We're given a list of closed intervals and we need to return a new list of intervals where overlapping intervals have been merged. Once we sort by end time, this problem becomes easy. For a given end time, pop from the list as long as its end time is larger than the smallest start time we've seen so far. Then, we append the associated interval to our output array and continue.

```python
def merge(self, intervals: List[List[int]]) -> List[List[int]]:
    intervals.sort(key=(lambda x: x[1]))

    output = []
    while(intervals):
        smallest, largest = intervals.pop()
        while intervals and intervals[-1][1] >= smallest:
            smallest = min(smallest, intervals.pop()[0])

        output.append([smallest, largest])
    
    return output
```

## Bit manipulation

Many bit manipulation problems can be boiled down into two tricks: using bitmasks and using properties of the XOR operation.

### Using bitmasks

Of course, one simple application of bitmasks is to find the least significant bit. For instance, consider the Easy problem [Number of 1 Bits](https://leetcode.com/problems/number-of-1-bits/), where we're asked to count the number of 1 bits in an unsigned integer.

```python
def hammingWeight(self, n: int) -> int:
    total = 0
    while n:
        total += n & 1
        n >>= 1
    
    return total
```

Another cleverer application of bitmasks is for reversing a number's bits (credit goes to Jack Rankin). To reverse an unsigned integer's bits, we can first swap the first half and second half, then swap the first and second halves of those, and so on. Thinking a little about the bitmasks required to get the appropriate halves, we get the following solution.

```python
def reverseBits(self, n: int) -> int:
    n = ((0xffff0000 & n) >> 16) ^ ((0x0000ffff & n) << 16)
    n = ((0xff00ff00 & n) >> 8) ^ ((0x00ff00ff & n) << 8)
    n = ((0xf0f0f0f0 & n) >> 4) ^ ((0x0f0f0f0f & n) << 4)
    n = ((0xcccccccc & n) >> 2) ^ ((0x33333333 & n) << 2)
    return ((0xaaaaaaaa & n) >> 1) ^ ((0x55555555 & n) << 1)
```

Finally, another application for bitmasks is to represent arithmetic overflow. One example of this is the problem [Sum of Two Integers](https://leetcode.com/problems/sum-of-two-integers/), where we're asked to compute the sum of two signed integers without using the operations `+` and `-`. Here, we can use the bitmask `0xffffffff` to keep only the lower 32 bits of a number. We use XOR to get all of the non-carry bits and use `&` with the left-shift `<<` to get the carry bits.

```python
def getSum(self, a: int, b: int) -> int:
    mask = 0xffffffff

    while (b & mask) != 0:
        carry_bits = (a & b) << 1
        a ^= b
        b = carry_bits

    return a & mask if b != 0 else a
```

This is by no means an exhaustive list of the applications of bitmasks, but hopefully this motivates why you should keep bitmasks in mind.

### XOR properties

Many problems can be solved using properties of the XOR operation. Recall that XOR corresponds to bit-wise addition of two bit-strings modulo 2. First, XOR is associative and commutative. Second, every element is self-inverse under XOR. Finally, zero is the identity element for bit-strings under XOR. We can use these properties to solve all kinds of problems. For instance, take the Easy problem [Single Number](https://leetcode.com/problems/single-number/). Here, we're given a list where each element appears twice except for one; we want to find the only single number. Well, XOR is commutative and associative, so since each element is self-inverse, we can XOR together all of the elements to find the only single element.

```python
def singleNumber(self, nums: List[int]) -> int:
    return reduce(xor, nums)
```

Short and sweet. Another example is [Missing Number](https://leetcode.com/problems/missing-number/), where we want to find the only number in the range $[0, n]$ which is missing from a given array. Well, if we add all of the numbers in $[0, n]$ into our list, this problem reduces to the Single Number problem above. Therefore, we can try the following, which turns out to be quite efficient.

```python
def missingNumber(self, nums: List[int]) -> int:
    return reduce(xor, range(len(nums) + 1)) ^ reduce(xor, nums)
```

In many cases, bit operations can make otherwise slow code much faster, so it's useful to try and use these on LeetCode whenever possible.

## Rarer algorithms

Here are a few of the rarer algorithms on LeetCode and other competitive programming platforms which are still worth knowing.

### Union-find and Kruskal's algorithm

The union-find data structure supports two operations: performing a union on two disjoint member sets and finding which set contains a given element. Typically, union-find data structures are represented using an array of trees, where the root node of each tree is the representative of a given member set (represented by the remainder of the tree). Two optimizations are typically used for a union-find data structure. The first is union-by-rank, which factors in the maximum depth of both trees when deciding how to union two different trees. The second is path compression, where each inserted node is actually made a child of its grandparent, which halves the length of all paths to the root node.

Union-find is sometimes used in graph algorithms, where each connected component is represented by a member set in a union-find structure. One example application of union-find is Kruskal's algorithm for finding a minimum spanning tree. Each vertex is initially in its own member set, and we put all the edges into a priority queue. We keep popping from the edge heap until we find one that wouldn't form a cycle (we can't have both nodes in the edge in the same member set). Then, we add this edge to the associated tree and union the two member sets. Repeating this process, all nodes are included in a final minimal spanning tree.

In general, union-find questions are more rare and many competitive programmers have a pre-written class handling all union-find operations. I think most union-find questions can be solved in other ways (or by coming up with union-find on the spot) so I think this is a less useful technique than others listed here.

### Max-flow and min-cut

The Ford-Fulkerson algorithm for max-flow and min-cut finds the maximum flow that can be sent through a sequence of pipes with capacity constraints on each of the edges. This is an interesting optimization problem (I might write a post on this someday) but it is rare that such a problem appears on LeetCode.

### $A^*$ search algorithm

The $A^\*$ search algorithm is a fancier version of breadth-first search which uses a priority queue with a given heuristic function instead of one based only on depth. This algorithm can be *much* more efficient than BFS for finding shortest paths, but the problem needs to have some structure which we can take advantage of with a clever heuristic.

### Fenwick trees + segtrees

Fenwick trees, or binary indexed trees, are dynamic prefix sum arrays that allow for fast computations of prefix sums and allow updates to the original array. Segment trees, or segtrees, are a generalization of Fenwick trees that store some property of segments that makes it easier to compute some property of the whole (for example, the minimum value of a segment). Both of these have efficient and clever algorithms associated with them, but they don't appear very frequently on LeetCode. Therefore, I'll save discussion of these for a potential future post.

## Matrix operations

One neat trick I learned from Jack Rankin was for rotating a matrix (this is the Medium problem [Rotate Image](https://leetcode.com/problems/rotate-image/)), where we want to rotate a given matrix by 90 degrees clockwise in-place. Jack noticed that you can flip the columns, then flip the rows -- this will rotate the matrix. Here's my proof: take a square piece of paper and mark the four corners with different colors. Then, if you flip the square across its vertical axis followed by its horizontal axis, the colors remain in the same place. This observation makes an otherwise annoying problem significantly easier.

```python
def rotate(self, matrix: List[List[int]]) -> None:
    """
    Do not return anything, modify matrix in-place instead.
    """

    n = len(matrix)
    
    for i in range(n):
        for j in range(n - i):
            matrix[i][j], matrix[n-1-j][n-1-i] = matrix[n-1-j][n-1-i], matrix[i][j]

    matrix.reverse()
```

## Python-specific tricks

One Python-specific trick is to use string operations where possible. Oftentimes, string operations with a high theoretical time complexity will still run faster than other algorithms due to Python's optimizations for strings. Another related trick is to use list slices. Python's list slicing is also highly optimized and will make for significantly faster code. Furthermore, sorting is very fast in Python and can often be faster than using a heap (even though using a heap should be more efficient for things like finding the `k` largest elements in an array).

Another trick is that Python uses dynamic arrays, which will often allocate too much space or too little (which would require an expensive resize). Instead, if you know the size of the array in advance, it makes more sense to pre-allocate an array like `a = [0] * n`. This will avoid the inefficiencies associated with dynamic resizing and help boost your solution.

Yet another trick that many others use (although I don't use this one) is to open the output file in write mode and print directly to this file.

```python
f = open('user.out', 'w')
print(my_output, file=f)
```

I find this one a bit cheap, but to each their own.

## Guessing time complexities

Finally, one silly trick is to guess the time complexity required by looking at the input size constraints. If a constraint says `0 <= n < 10^4`, you might be able to get away with an $O(n^2)$ algorithm while an $O(n \log(n))$ or an $O(n)$ solution is likely optimal. If a constraint says `1 <= n < 10^9`, on the other hand, you automatically know that your algorithm has to be linear. In dynamic programming problems, constraints like these can help determine what dimension your dynamic programming should recurse over.
