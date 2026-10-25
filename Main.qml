import QtQuick
import QtQuick.Controls
import QtQuick.Effects

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    minimumWidth: 160
    minimumHeight: 160
    title: "Rectio"

    opacity: 0
    Component.onCompleted: opacity = 1
    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

    readonly property Item root: contentItem
    readonly property int gap: 8

    function gcd(a, b) {
        return b === 0 ? a : gcd(b, a % b);
    }

    readonly property string ratioText: {
        let w = rectW.value;
        let h = rectH.value;
        let divisor = gcd(w, h);
        return (w / divisor) + ":" + (h / divisor);
    }

    Rectangle {
        id: rect
        color: rectHover.hovered ? "#A80000" : "#8B0000"
        Behavior on color { ColorAnimation { duration: 150 } }

        readonly property real availW: root.width - window.gap * 3 - rectHContainer.width
        readonly property real availH: root.height - window.gap * 3 - rectW.height
        readonly property real ratio: rectW.value / rectH.value

        property real animRatio: ratio

        width: Math.min(availW, availH * animRatio)
        height: width / animRatio

        x: window.gap + (availW - width) / 2
        y: window.gap + (availH - height) / 2

        Behavior on animRatio { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

        HoverHandler {
            id: rectHover
        }

        Rectangle {
            color: (rect.width < txtColumn.width || rect.height < txtColumn.height) ? Qt.rgba(0, 0, 0, 0.5) : "transparent"
            radius: 8

            anchors.centerIn: parent

            width: txtColumn.width + window.gap * 2
            height: txtColumn.height + window.gap

            Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
            Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

            HoverHandler {
                id: textFieldHover
            }

            Column {
                id: txtColumn
                spacing: 2

                anchors.centerIn: parent

                Text {
                    id: txtArea
                    color: "white"

                    anchors.horizontalCenter: parent.horizontalCenter

                    text: (rectW.value * rectH.value).toLocaleString()
                    font.pixelSize: 40

                    scale: 1.0
                    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }
                }

                Text {
                    id: txtRatio
                    color: "white"

                    anchors.horizontalCenter: parent.horizontalCenter
                    bottomPadding: (-areaMetrics.tightBoundingRect.y - (-ratioMetrics.tightBoundingRect.y)) / 2

                    opacity: textFieldHover.hovered ? 1.0 : 0.6
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    text: window.ratioText
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            TextMetrics {
                id: areaMetrics

                text: txtArea.text
                font: txtArea.font
            }

            TextMetrics {
                id: ratioMetrics

                text: txtRatio.text
                font: txtRatio.font
            }
        }
    }

    SpinBox {
        id: rectW

        anchors.horizontalCenter: rect.horizontalCenter
        anchors.bottom: root.bottom
        anchors.bottomMargin: window.gap

        from: 1
        to: 9999
        editable: true

        scale: rectW.hovered ? 1.05 : 1
        Behavior on scale { NumberAnimation { duration: 100 } }

        onValueChanged: {
            scaleWAnim.restart()
        }

        SequentialAnimation {
            id: scaleWAnim
            NumberAnimation { target: txtArea; property: "scale"; to: 1.05; duration: 50; easing.type: Easing.OutQuad }
            NumberAnimation { target: txtArea; property: "scale"; to: 1.0; duration: 150; easing.type: Easing.OutBounce }
        }
    }

    Item { // bypassing rotation of spinBox
        id: rectHContainer

        anchors.verticalCenter: rect.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: window.gap

        height: rectH.width
        width: rectH.height

        SpinBox {
            id: rectH
            rotation: -90

            anchors.centerIn: parent

            from: 1
            to: 9999
            editable: true

            scale: rectH.hovered ? 1.05 : 1
            Behavior on scale { NumberAnimation { duration: 100 } }

            onValueChanged: {
                scaleHAnim.restart()
            }

            SequentialAnimation {
                id: scaleHAnim
                NumberAnimation { target: txtRatio; property: "scale"; to: 1.05; duration: 50; easing.type: Easing.OutQuad }
                NumberAnimation { target: txtRatio; property: "scale"; to: 1.0; duration: 150; easing.type: Easing.OutBounce }
            }
        }
    }
}
