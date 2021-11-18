.pragma library
// 表示这是一个state shared js类

var factorialCount = 0;

function factorial(a) {
    a = parseInt(a);

    // factorial recursion
    if (a > 0)
        return a * factorial(a - 1);

    // shared state
    factorialCount += 1;

    // recursion base-case.
    return 1;
}

function factorialCallCount() {
    return factorialCount;
}