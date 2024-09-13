import QtQuick
import QtQuick.Controls   // 用Button 和Dialog控件的头文件

Window {
    id:windows
    width: 640
    height: 480
    visible: true
    title: qsTr("Snake")
    color:"#E0EEE0"


    minimumWidth: 600
    minimumHeight: 460
    maximumWidth: 600
    maximumHeight: 460

    property int  speech: 600
    property int movestate: 1 //防止出现控制方向与行动方向相反的情况
    property var snakeBodyLength: -1
    property  var snakeBody: [] // 存储蛇身
    property  var keydirectionTow:4
    property var n: 0  // 自定义一把锁

    Component{//有了Component，就可以调用其createObject（）方法来创建该组件的实例
        id:creat
        Rectangle{
            id:test
            height: 20
            width: 20
            color: "red"
            radius: 5 // 设置圆角的大小，值越大，角落越钝
            Behavior on x {
                NumberAnimation {
                    duration: 0 // 动画持续500毫秒
                    // 可以添加更多的动画属性，例如 easing.type
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 0 // 动画持续500毫秒
                    // 可以添加更多的动画属性，例如 easing.type
                }
            }
        }
    }
    function creatObj()
    {
        snakeBodyLength++;
        var obj = creat.createObject(windows,{})  //新对象的父对象window  createObject用于创建一个组件的新实例
        return obj
    }

    Rectangle{
        id:border
        x:20
        y:20
        width: 400
        height: 400
        border.color: "#6E8B3D"
        border.width: 1
    }
    // 暂停按钮
    Button {
        id: stop
        x: 467
        y: 40
        width: 100
        height: 50
        text: qsTr("暂停")
        font.pixelSize: 16
        background: Rectangle {
            color: "#F0E68C"
            radius: 6
        }
        onClicked: {
            timer.running = false
        }
    }

    Button {
        id: start
        x: 467
        y: 100
        width: 100
        height: 50
        text: qsTr("开始")
        font.pixelSize: 16
        background: Rectangle {
            color: "#20668C"
            radius: 6
        }
        onClicked: {
            timer.running = true
        }
    }


    Button {
        id:test
        x: 467
        y: 160
        width:100
        height: 50
        text: qsTr("重置")
        font.pixelSize: 16
        background:Rectangle{
            color:"#BFEFFF"
            radius: 6
        }
        onClicked: {
            timer.running = false
            chicken.x = (Math.round(Math.random()*19)+1)*20//(1~20)*20即在20到400间取随机值
            chicken.y =(Math.round(Math.random()*19)+1)*20
            color: Qt.rgba(Math.random(),Math.random(),Math.random(),1)//rgba红黄蓝三色比例产生随机颜色,以及透明度
            snake.x = 500
            snake.y = 500
            score.text = 0

            for(var i = snakeBodyLength;i>=0;i--)
            {

                snakeBody.pop().destroy()
            }
        }

    }


    property int numberspeed: 200

    // //增加速度
    // Text {
    //     text: qsTr(numberspeed/100)
    //     id:speed
    //     x:467
    //     y:450
    //     width: 150
    //     height: 50
    // }


    Dialog
    {
        id:out_mesDialog
        title:"terrible new: You are out of bounds."
        x:100
        y:200
        width: 300
        height: 100
        background: Rectangle{
            border.color: "#ADD8E6"
        }
        Label{
            x:20
            y:0
            text:"grade:"
            font.pointSize: 20
        }
        Label{
            x:105
            y:0
            text:score.text
            font.pointSize: 20
        }
    }

    Text {
        id: scoretip
        x: 469
        y: 260
        width: 42
        height: 27
        text: qsTr("score:")
        font.pixelSize: 20
        color:"#EE9A00"
    }

    Text {//分数显示
        id: score
        x: 535
        y: 255
        property int number: 0
        width: 56
        height: 27
        text: qsTr(number)
        color:"#CD7054"
        font.pointSize: 20
    }

    //chicken
    Rectangle{
        id:chicken
        width: 20
        height: 20
        radius: 20
        //initial position
        x:(Math.round(Math.random()*19)+1)*20//(1~20)*20即在20到400间取随机值
        y:(Math.round(Math.random()*19)+1)*20
        color: Qt.rgba(Math.random(),Math.random(),Math.random(),1)//rgba红黄蓝三色比例产生随机颜色,以及透明度
    }
    function newchicken(){//刷新小鸡的函数

        //initial position
        chicken.x =(Math.round(Math.random()*19)+1)*20//(1~20)*20即在20到400间取随机值
        chicken.y =(Math.round(Math.random()*19)+1)*20
        chicken.color= Qt.rgba(Math.random(),Math.random(),Math.random(),1)//rgba红黄蓝三色比例产生随机颜色,以及透明度
    }
    Rectangle {
        id:snake
        property var keydirection: 4//键盘控制方向
        // 初始化蛇
        x:200
        y:200
        z:2//置位上层
        width: 20
        height: 20
        focus:true
        Behavior on x {
            NumberAnimation {
                duration: 0 // 动画持续500毫秒
                // 可以添加更多的动画属性，例如 easing.type
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: 0 // 动画持续500毫秒
                // 可以添加更多的动画属性，例如 easing.type
            }
        }
        Keys.onPressed: {

            switch(event.key){
            case Qt.Key_Left:
                if(keydirectionTow ==2)
                {
                    return
                }
                keydirection = 1
                keydirectionTow = keydirection
                left.visible = true;
                right.visible = false;
                up.visible = false;
                down.visible = false;

                break
            case Qt.Key_Right:
                if(keydirectionTow ==1)
                {
                    return
                }
                keydirection = 2
                keydirectionTow = keydirection
                right.visible = true;
                left.visible = false;
                up.visible = false;
                down.visible = false;
                break
            case Qt.Key_Down:
                if(keydirectionTow ==4)
                {
                    return
                }
                keydirection = 3
                keydirectionTow = keydirection
                down.visible = true;
                up.visible = false;
                left.visible = false;
                right.visible = false;
                break
            case Qt.Key_Up:
                if(keydirectionTow ==3)
                {
                    return
                }
                keydirection = 4
                keydirectionTow = keydirection
                up.visible = true;
                down.visible = false;
                left.visible = false;
                right.visible = false;
                break
            default:
            }
            console.log("snake.keydirection="+snake.keydirection)
            event.accepted = true//应该被设置为 true 以免它被继续传递

        }
        Image {
            id: up
            x:snake.x; y: snake.y
            anchors.fill: parent
            source: "qrc:new//prefix1/image/UP.png"
        }
        Image {
            id:down
            x:snake.x; y: snake.y
            anchors.fill: parent
            source: "qrc:new//prefix1/image/Down.png"
        }
        Image {
            id: left
            x:snake.x; y: snake.y
            anchors.fill: parent
            source: "qrc:new//prefix1/image/left.png"
        }
        Image {
            id: right
            x:snake.x; y: snake.y
            anchors.fill: parent
            source: "qrc:new//prefix1/image/right.png"
        }

    }
    Timer{
        id:timer
        interval: 200
        repeat: true
        running: false
        onTriggered: {
            move()
        }
    }

    function move()
    {
        //  `Keys.onPressed` 事件处理器是绑定在 `Rectangle` 控件（蛇）上的。当定时器启动后，如果蛇的控件没有焦点，或者某种情况下事件处理被阻止了，那么您可能无法接收到键盘事件。
        //要确保即使在定时器运行时也能接收到键盘事件，请确保以下几点： 1. 蛇控件（`snake`）保持焦点状态。 2. 在 `Keys.onPressed` 事件处理器中，您已经设置了 `event.accepted = true`，这是正确的，它可以阻止事件进一步传播到其他控件。
        //如果以上两点都正确无误，那么我们需要检查定时器触发事件中是否有代码导致蛇控件失去了焦点。
        //在 `move` 函数中，没有明显的代码会改变蛇控件的焦点状态。 一个可能的问题是，如果您的蛇控件在渲染时被其他控件遮挡，或者由于某种原因不可见，那么它可能无法接收键盘事件。
        //另外，还需要检查的是在定时器触发时是否有代码阻止了键盘事件的进一步处理。这可能是由于事件冒泡机制导致的。
        //最后这句代码设置当前代表蛇控件的焦点。解决了定时器启动后，收不到键盘事件的问题
        snake.focus = true;
        console.log("  snake.x= " +snake.x+"  snake.y= " + snake.y+"  chicken.x= " +chicken.x+"  chicken.y= " + chicken.y)
        console.log("move snake.keydirection="+snake.keydirection)
        switch(snake.keydirection){
        case 1:
            if(snake.x-20< 20)
            {
                out_mesDialog.open()
                timer.running = false
                return
            }

            if(snake.x == chicken.x && snake.y == chicken.y )
            {

                eat()
            }
            snakemove()
            snake.x-=20
            judge(snake,one)

            break
        case 2:
            if(snake.x+20> 400)
            {
                out_mesDialog.open()
                timer.running = false
                return
            }
            if(snake.x == chicken.x && snake.y == chicken.y )
            {

                eat()
            }
            snakemove()
            snake.x+=20
            judge(snake,one)

            break
        case 3:
            if(snake.y+20> 400)
            {
                out_mesDialog.open()
                timer.running = false
                return
            }
            if(snake.x == chicken.x && snake.y == chicken.y )
            {

                eat()
            }
            snakemove()
            snake.y+=20
            judge(snake,one)
            break
        case 4:
            if(snake.y-20< 20)
            {
                out_mesDialog.open()
                timer.running = false
                return
            }
            if(snake.x == chicken.x && snake.y == chicken.y )
            {
                eat()
            }
            snakemove()
            snake.y-=20
            judge(snake,one)
            break
        default:
        }

    }

    //蛇躯移动
    function snakemove()
    {

        if(snakeBodyLength >=0)
        {

            for(var i = snakeBodyLength; i>0 ; --i)
            {

                snakeBody[i].x = snakeBody[i-1].x
                snakeBody[i].y = snakeBody[i-1].y
            }
            snakeBody[0].x = snake.x
            snakeBody[0].y = snake.y
        }


    }
    //吃球
    function eat()
    {
        snakeBody.push(creatObj())

        snakeBody[snakeBodyLength].x = snake.x
        snakeBody[snakeBodyLength].y = snake.y

        newchicken()
        judge(chicken,tow)

        score.number++
    }

    property  string one: "snake"
    property string tow: "chicked"

    function judge(item1,str1 )
    {

        for(var i = snakeBodyLength; i> 0 ; --i)
        {
            if(snakeBody[i].x == item1.x  && snakeBody[i].y == item1.y)
            {
                if(str1 == "snake")
                {
                    out_mesDialog.open()
                    timer.running = false
                    return
                }
                if(str1 == "chicked")
                {
                    newchicken()
                }

            }
        }
    }


}
