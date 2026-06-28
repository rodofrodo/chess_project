import QtQuick
import QtQuick.Controls
import "../elements" 

Page {
    id: creditspage

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    FontLoader {
        id: productSansRegular
        source: "../assets/product-sans-regular.ttf"
    }

    // background
    Image {
        anchors.fill: parent
        source: "../assets/creditspage_bg.png" 
        fillMode: Image.PreserveAspectCrop
    }

    // smaller custom text
    ChessStartText {
        fontSize: 64
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 87
        anchors.leftMargin: 145
    }

    Text {
        id: titleText
        text: "CREDITS"
        color: "#fff" 
        font.family: productSansBold.name
        font.pixelSize: 64
        font.letterSpacing: 10
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 240
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column {
        anchors.top: titleText.bottom
        anchors.topMargin: 115
        anchors.horizontalCenter: parent.horizontalCenter
        
        width: 881
        spacing: 90

        Repeater {
            /*
                so I was wondering what roles would suit the team members best, and I came up with these.
                I led the project, Marek was responsible for integration, and Łukasz handled the backend.
            */
            model: ListModel {
                ListElement { role: "Lead"; name: "Bartosz Strączek" }
                ListElement { role: "Integration"; name: "Marek Masorz" }
                ListElement { role: "Backend"; name: "Łukasz Międlar" }
            }
            
            delegate: Item {
                width: parent.width
                height: 30

                Text { // role
                    text: model.role 
                    color: "white"
                    font.family: productSansBold.name
                    font.bold: true
                    font.pixelSize: 36
                    
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text { // name
                    text: model.name
                    color: "white"
                    font.family: "Arial"
                    font.pixelSize: 36
                    
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // github repo button
    Rectangle {
        id: repoLinkButton
        width: 250
        height: 60

        color: repoMouseArea.containsMouse ? "#1a1a1a" : "transparent" 
        radius: 50

        anchors.bottom: backBtn.top
        anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors.centerIn: parent
            spacing: 10

            Image {
                width: 32
                height: 32
                source: "../assets/github-logo.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Text {
                    text: "Check out our repo"
                    color: "white"
                    font.family: productSansBold.name
                    font.pixelSize: 18
                    font.bold: true
                }

                Text {
                    text: "Click here to follow"
                    color: "#CCCCCC"
                    font.family: productSansRegular.name
                    font.pixelSize: 12
                }
            }
        }

        MouseArea {
            id: repoMouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: {
                Qt.openUrlExternally("https://github.com/rodofrodo/chess_project")
            }
        }
    }

    GoBackBtn {
        id: backBtn
        anchors.top: titleText.bottom
        anchors.topMargin: 590
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            creditspage.StackView.view.pop()
        }
    }
}
