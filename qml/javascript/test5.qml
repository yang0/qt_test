import QtQuick 2.0
import "factorial.js" as FactorialCalculator // This JavaScript resource is only
                                             // ever loaded once by the engine,
                                             // even if multiple instances of
                                             // Calculator.qml are created.

Text {
    width: 500
    height: 100
    property int input: 17
    text: "The factorial of " + input + " is: " + FactorialCalculator.factorial(input)
}