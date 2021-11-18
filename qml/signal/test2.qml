import QtQuick 2.0

// Signal handlers for property change signal take the syntax form on<Property>Changed where <Property> is the name of the property

TextInput {
    text: "Change this!"

    onTextChanged: console.log("Text has changed to:", text)
}