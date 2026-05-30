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

    Image {
        anchors.fill: parent
        source: "../assets/creditspage_bg.png" 
        fillMode: Image.PreserveAspectCrop
    }

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

        // The Repeater automatically creates a new row for every item in the model
        Repeater {
            model: ListModel {
                // Here is your actual data!
                ListElement { role: "Lead"; name: "Bartosz Strączek" }
                ListElement { role: "Frontend"; name: "Marek Masorz" }
                ListElement { role: "Backend"; name: "Łukasz Międlar" }
            }
            
            // The 'delegate' is the blueprint for how ONE row should look
            delegate: Item {
                width: parent.width // Stretches to the Column's 400px width
                height: 30

                // Role (Left aligned, Bold)
                Text {
                    text: model.role 
                    color: "white"
                    font.family: productSansBold.name
                    font.bold: true
                    font.pixelSize: 36
                    
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Name/Initials (Right aligned, Regular)
                Text {
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

    GoBackBtn {
        anchors.top: titleText.bottom
        anchors.topMargin: 590
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            creditspage.StackView.view.pop() // Go back to the previous page
        }
    }
}
