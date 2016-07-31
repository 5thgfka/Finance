import bb.cascades 1.4

Sheet {
    id: stockPage
    
    property string name: ""
    property string dot: ""
    property string nowPic: ""
    property string rate: ""
    property string minurl: ""
    property string dayurl: ""
    property string weekurl: ""
    property string monthurl: ""
    property string todayMax: ""
    property string todayMin: ""
    property string todayStartPri: ""
    property string yestodEndPri: ""
    property string sellFive: ""
    property string sellFivePri: ""
    property string sellFour: ""
    property string sellFourPri: ""
    property string sellThree: ""
    property string sellThreePri: ""
    property string sellTwo: ""
    property string sellTwoPri: ""
    property string sellOne: ""
    property string sellOnePri: ""

    property string buyFive: ""
    property string buyFivePri: ""
    property string buyFour: ""
    property string buyFourPri: ""
    property string buyThree: ""
    property string buyThreePri: ""
    property string buyTwo: ""
    property string buyTwoPri: ""
    property string buyOne: ""
    property string buyOnePri: ""

    property string gid: ""
    property string nowPri: ""
    
    content: Page {
        titleBar: TitleBar {
            title: name
            dismissAction: ActionItem {
                title: qsTr("Close") + Retranslate.onLanguageChanged
                onTriggered: {
                    stockPage.close()
                    if (stockPage) stockPage.destroy();
                }
            }
        }
        ScrollView {
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    Label {
                        text: nowPri
                        textStyle.color: parseFloat(yestodEndPri) > parseFloat(nowPri) ? Color.Green:Color.Red
                        textStyle.fontSize: FontSize.Large
                    }
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }
                    Label {
                        text: nowPic
                        textStyle.color: parseFloat(yestodEndPri) > parseFloat(nowPri) ? Color.Green:Color.Red
                    }
                    Label {
                        text: rate + "%"
                        textStyle.color: parseFloat(yestodEndPri) > parseFloat(nowPri) ? Color.Green:Color.Red
                    }
                }
            }
        }
    }
}
