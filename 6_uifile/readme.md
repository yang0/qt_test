# 把.ui编译成.py文件
pyside6-uic mainwindow.ui > ui_mainwindow.py

# 直接使用.ui也是可以的
见index2.py

# 在desiner里面使用自定义widget
https://doc.qt.io/qtforpython/tutorials/basictutorial/uifiles.html

自定义插件目录：
D:\Users\yang0\AppData\Local\Programs\Python\Python38\Lib\site-packages\PySide6\plugins\designer

需要两个文件：
一个是widget文件，一个regist widget的文件
pyqt自带的两个example文件在：
D:\Users\yang0\AppData\Local\Programs\Python\Python38\Lib\site-packages\PySide6\examples\widgetbinding

把两个相关的py文件拷贝到
D:\Users\yang0\AppData\Local\Programs\Python\Python38\Lib\site-packages\PySide6\plugins\designer
然后稍作修改

运行：pyside6-designer

进去就可以看到修改过的plugin了

