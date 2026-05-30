import QtQuick
import QtQuick.Controls
import "../elements" 

Page {


    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    FontLoader {
        id: productSansRegular
        source: "../assets/product-sans-regular.ttf"
    }

    background: Rectangle {
        color: "blue"
    }
}
