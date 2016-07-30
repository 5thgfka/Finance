import bb.cascades 1.4
// for key stock at home page
Container {
    property string name
    property string nowPri
    property string nowPic
    property string yestodEndPri
    property string dot
    property string rate
    background: Color.White
    
    horizontalAlignment: HorizontalAlignment.Center
    verticalAlignment: VerticalAlignment.Center
    // top to bottom layout
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    Container {
        // first row
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        Label {
            id: nameField
            text: name
        }
    }
    Container {
        // second row
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        leftMargin: ui.du(5)
        Label {
            id: dotField
            text: dot
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            leftMargin: ui.du(5)
            Label {
                id: nowPicField
                text: nowPic
                textStyle.fontSize: FontSize.XXSmall
            }
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            leftMargin: ui.du(5)
            background: parseFloat(yestodEndPri) > parseFloat(nowPri) ? Color.Green:Color.Red
            Label {
                id: rateField
                text: rate + "%"
                textStyle.fontSize: FontSize.XXSmall
            }
        }
    }
    
}
