--- 
title: Ruby Benchmarking & Complexity
short: Ruby Benchmarking
date: 2011-01-25 09:42:00 +01:00
category: Ruby
keywords: 
- benchmarking
- complexity
- performance
- ruby
- minitest
---
I was recently looking at the presentation @{http://confreaks.net/videos/427-rubyconf2010-zomg-why-is-this-code-so-slow}{ZOMG WHY IS THIS CODE SO SLOW} given by Aaron Patterson (aka @{http://tenderlovemaking.com/}{tenderlove}) at RubyConf 2010. His talk was about benchmarking, performance and optimization in ruby, examples being extracted from his recent work on @{http://ar.rubyonrails.org/}{ActiveRecord} and @{https://github.com/rails/arel}{ARel}. I must confess being a bit embarrassed about what I'm going to say here (Aaron is a really famous ruby hacker, member of both ruby-core and rails-core teams, developer of excellent ruby tools like @{https://github.com/rails/arel}{ARel}, @{https://github.com/tenderlove/mechanize}{mechanize}, and so on.) but...  I'm a bit... how to say?... hum, surprised! 

The reason is that some examples in the slides can be very misleading IMHO. Amazingly, Aaron himself writes "Don't believe me" and "Think critically". Let's do that: I dare this writing.

### Benchmarking and asserting execution time

The example below is given at slide 104 (@{http://www.slideshare.net/tenderlove/zomg-why-is-this-code-so-slow)}{click here for the slides}, when Aaron introduces the @{https://github.com/seattlerb/minitest}{minitest/benchmark} library (I must add that, at the time of writing, a very similar example is given in @{https://github.com/seattlerb/minitest/blob/81fe0a56f5dd29036e3bec107cca48a136c42470/README.txt#L110-119)}{minitest's own README}. 

#<{benchmarking/fib1_test.rb}

The example is quite easy to understand:

1. The method `fib` computes the n-th @{http://en.wikipedia.org/wiki/Fibonacci_number}{fibonacci number},
1. As its name suggests, the method `bench_fib` aims at benchmarking and asserting the performance of (the implementation of) `fib`. 
1. It relies on `assert_performance_linear` (provided by minitest/benchmark) which will invoke the block with increasing values for `n` (1, 10, 100, 1000, and 10000). 
1. By measuring the execution time of each of these invocations, minitest is able to check whether the execution time is a linear function of `n` or not.

As you can see below, the test passes. The execution time exhibits a beautiful linear progression! Can we say therefore that `fib` is a linear function? Not at all!

#<{benchmarking/fib1_result.sh}

### Trivially true or simply wrong?

Not at all, because the assertion is trivially true. Therefore the test is useless, if not simply wrong.

#<{ruby}{
assert_performance_linear 0.99 do |n|
  n.times do
    fib(1000)
  end
end
}

Here is why:

1. The call to `fib(1000)` itself has a *constant* execution time _T_ (but see later),
1. One call to `fib(1000)` takes _T_ ms., ten calls take _10xT_ ms., ..., ten thousand calls take _10000xT_ ms.
1. Therefore, the linear progression is implied by `assert_performance_linear` only, and is absolutely independent of `fib`

In other words, from the points of view of the assertion at least (vs. the actual execution time, which differs) the code given in the example is somewhat equivalent to (and the test passes, of course):

#<{ruby}{
assert_performance_linear 0.99 do |n|
  n.times do
    # everything with constant execution time
    # nothing, for example
  end
end
}

The assertion is trivially true as well as the test, and the benchmarking approach itself is misleading, if not wrong.

### Really?

Unfortunately if you want to go deeper in your understanding, things get more complicated. The truth is that answering whether the benchmarking is wrong or not depends on what you want to assert precisely. In this respect, the example at hand is amazing because:

> It proves (or at least asserts) a lot of things, but *certainly not* that `fib` has a linear execution time (even if it does)

If you do not trust me, modify `fib` as below. The modified implementation (does not compute a fibonacci number anymore and) presents an exponential execution time with respect to `n`.

#<{ruby}{
def fib n
  a, b = 0, 1
  (2**n).times do 
    a, b = b, a + b 
  end
  a
end
}

Execute the test now (I've only replaced 1000 by 10 here to have something that ends in a reasonable amount of time. Sorry for the confusion it could introduce):

#<{ruby}{
assert_performance_linear 0.99 do |n|
  n.times do
    fib(10) 
  end
end
}

#<{benchmarking/fib2_result.sh}

The test passes and the performance is linear (the execution time is really similar to what we had before, but it is only because `10**2 == 1024 ~= 1000`). The problem is that such a test would pass and would assert a linear performance whatever the `fib` you choose, and whatever it's internal complexity: constant, linear, polynomial, or even exponential! 

Contrarily to what is argued by Aaron (see the @{http://confreaks.net/videos/427-rubyconf2010-zomg-why-is-this-code-so-slow)}{video around 18:00}, this kind of test will never detect the fact that your mate have replaced your linear function by an exponential one.

So what is asserted exactly? Is the assertion trivially true, really? No exactly. In fact, the test asserts that:

1. The method `Integer#times(n)` has a linear execution time with respect to `n` and
1. The call to `fib(1000)` has a constant execution time, which implies that...
1. ... it does not (seem to) depend on the number of times the function has been called before and
1. ... it does not (seem to) depend on another hidden parameter unless the latter is itself constant and
1. ... so on.


### What could /should it be?

At this step, you could argue that it is a typo on the slide and that the bench method was intended to be as shown below:

#<{ruby}{
assert_performance_linear 0.99 do |n|
  n.times do
    fib(n) 
  end
end
}

But no way! The test even fails, and *it has to fail*: `Integer#times` is linear in `n` and calls `fib` at each iteration, which is linear in `n` as well. The correct computation is therefore `n*n`, which is quadratic, not linear. Moreover, a similar mistake would be repeated on many other slides (see slides 100-102, 104-106, 109-114, 165-166, ...). 

What about the example below?

#<{ruby}{
assert_performance_linear 0.99 do |n|
  n.times do |i|
    fib(i) 
  end
end
}

Well, this time, the exact complexity formula is `n*(n+1)/2`, which is bounded by `n^2` and is therefore quadratic, not linear either. Contrast this with

#<{ruby}{
assert_performance_linear 0.99 do |n|
  100.times do
    fib(n) 
  end
end
}

Or simply:

#<{ruby}{
assert_performance_linear 0.99 do |n|
  fib(n) 
end
}

The last two examples are right, and correctly assert that `fib` itself has a linear complexity. The first one repeats the computation 100 times, to have better statistical results. The latter point is extremely important, to avoid having tests that wrongly success or fail (see later).

### So what?

So what? What happened? Is it important? For me, the main problem with Aaron's talk is that it mixes two different concerns:  _benchmarking_ and _asserting complexity_. And keeping these concerns separate is certainly important! Let's have a quick look at the differences. 

#### Benchmarking

What Aaron is actually interested in his talk is _benchmarking_. Benchmarking allows *measuring and comparing execution times*. In that case, executing the same constant code (e.g. `fib(1000)`) over and over again perfectly makes sense. It is what Aaron is actually doing on all slides showing linear curves (@{http://www.slideshare.net/tenderlove/zomg-why-is-this-code-so-slow}{slides} 153, 163, 166, 174, 180, 183, 187, and so on.): it compares different implementations of similar specifications. The fact that the curves are linear is misleading: it does not say anything about the internal complexity of the different implementations. But it makes the job: the delta between the different curves (in mathematical words: the difference of the slope of the curves) is representative of the efficiency difference between these implementations!

Even if it makes sense, remember that conducting a benchmarking experiment on one example only (e.g. `fib(1000)`) is extremely insignificant, statistically speaking. Varying parameters and computing the average execution time is certainly better that executing the code with the same parameter, even a billion times. I must confess that correctly designing such a benchmarking experiment is also a bit harder. Aaron showed you the easiest and the very pragmatic way, very arguable but working (as demonstrated)! 

#### Asserting complexity

Asserting the internal complexity of an algorithm is another beast, and is probably much harder than benchmarking. Asserting complexity is asserting about the *performance of an algorithm with respect to the size of the problem it solves*. Well, it is (somewhat) obvious that asserting complexity is not Aaron's motivation. Instead he mainly uses `assert_linear_performance` as a pragmatic way of measuring execution time and reporting it on a plot (see what he says at 18:15). All examples with `assert_linear_performance` are actually flawed, as I've discussed earlier.

To reason about the complexity of your algorithm you *have to* design an experiment where the size of the problem varies. In the `fib` example, you have to measure the execution time for different (well chosen) values of `n`. Executing the algorithm many times (say 10 times) for each parameter value and computing the average allows obtaining better results with respect to statistical significance. If you report the measured time against the size of the problem in a graph, you obtain the complexity profile (see @{http://www.slideshare.net/tenderlove/zomg-why-is-this-code-so-slow}{Aaron's slides} 229-233 for typical profiles). 

Asserting the complexity of the algorithm from such measures is even harder than simply visualizing it (isn't even undecidable??? please drop me an email if you know the answer). The idea (and what @{https://github.com/seattlerb/minitest}{minitest/benchmark} does) is to fit the measures with a given mathematical profile (linear, polynomial, exponential), and to check whether the fitting error is under a given threshold. In my opinion, designing and conducting such an experiment rigorously is difficult and requires time (both for the design and the execution of the experiment) and a lot of experience. For this reason, I personally doubt about the pertinence of having such assertions in an automated test suite. Anyway, if you plan to use them, remember to also output graphs and to have a look at it! Human inspection is sometimes much more pragmatic and rigorous than flawed automations ;-)

### Conclusion

I'll conclude this post with Aaron's own response to the mail I've sent to him about this:

> I think your post is accurate. The benchmark shows a constant amount of work in a linear progression. Did I say something else? If so, I apologize.

And with my girlfriend's:

> The benchmark shows that (unlike me) your computer is not tired of computing the 1000-th fibonacci number, even after a million times.

She's right!
