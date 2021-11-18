import QtQuick 2.12
import "fib.js" as MathFunctions

Item {
    TapHandler {
        onTapped: console.log(MathFunctions.fibonacci(10))
    }
}