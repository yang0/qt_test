var clickCount = 0;   // this state is separate for each instance of MyButton
function onClicked(button) {
    clickCount += 1;
    console.log(clickCount)
    if ((clickCount % 5) == 0) {
        button.color = Qt.rgba(1,0,0,1);
    } else {
        button.color = Qt.rgba(0,1,0,1);
    }
}