import bb.cascades 1.4
import WebImageView 1.0

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
    property string traAmount: ""
    property string traNumber: ""

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
                Container {
                    leftPadding: ui.du(2)
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Container {
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                        Label {
                            text: nowPri
                            textStyle.color: parseFloat(yestodEndPri) > parseFloat(nowPri) ? Color.Green : Color.Red
                            textStyle.fontSize: FontSize.Large
                        }
                    }
                    Container {
                        leftPadding: ui.du(1)
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        Label {
                            text: parseFloat(nowPic) < 0 ? nowPic: "+" + nowPic
                            textStyle.color: parseFloat(yestodEndPri) > parseFloat(nowPri) ? Color.Green : Color.Red
                        }
                        Label {
                            text: parseFloat(rate) < 0 ? rate + "%" : "+" + rate + "%"
                            textStyle.color: parseFloat(yestodEndPri) > parseFloat(nowPri) ? Color.Green : Color.Red
                        }
                    }
                }
                Divider {
                }
                Container {
                    leftPadding: ui.du(1)
                    layout: GridLayout {
                        columnCount: 3
                    }
                    Container {
                        leftPadding: ui.du(1)
                        id: todayStartPrice
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "今开"
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            Label {
                                text: todayStartPri
                                textStyle.fontWeight: FontWeight.Bold
                                textStyle.fontSize: FontSize.XXSmall
                            }
                        }
                    }
                    Container {
                        id: todayMaxPrice
                        leftPadding: ui.du(1)
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "最高"
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            Label {
                                text: todayMax
                                textStyle.fontWeight: FontWeight.Bold
                                textStyle.fontSize: FontSize.XXSmall
                            }
                        }
                    }
                    Container {
                        id: tradeNumber
                        leftPadding: ui.du(1)
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "成交量(股)"
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            Label {
                                text: traNumber
                                textStyle.fontWeight: FontWeight.Bold
                                textStyle.fontSize: FontSize.XXSmall
                            }
                        }
                    }
                    Container {
                        id: yestodEndPrice
                        leftPadding: ui.du(1)
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "昨收"
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            Label {
                                text: yestodEndPri
                                textStyle.fontWeight: FontWeight.Bold
                                textStyle.fontSize: FontSize.XXSmall
                            }
                        }
                    }
                    Container {
                        id: todayMinPrice
                        leftPadding: ui.du(1)
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "最低"
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            Label {
                                text: todayMin
                                textStyle.fontWeight: FontWeight.Bold
                                textStyle.fontSize: FontSize.XXSmall
                            }
                        }
                    }
                    Container {
                        id: tradeAmount
                        leftPadding: ui.du(1)
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "总市值"
                        }
                        Container {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                            Label {
                                text: traAmount
                                textStyle.fontWeight: FontWeight.Bold
                                textStyle.fontSize: FontSize.XXSmall
                            }
                        }
                    }
                }
                Divider {
                }
                Container {
                    SegmentedControl {
                        id: trans
                        Option {
                            text: qsTr("分时")
                            value: "today"
                            selected: true
                            onSelectedChanged: {
                            }
                        }
                        
                        Option {
                            text: qsTr("日K")
                            value: "dk"
                            onSelectedChanged: {
                            }
                        }
                        
                        Option {
                            text: qsTr("周K")
                            value: "wk"
                            onSelectedChanged: {
                            }
                        }
                        
                        Option {
                            text: qsTr("月K")
                            value: "mk"
                            onSelectedChanged: {
                            }
                        }
                        
                        onSelectedIndexChanged: {
                            // _calendar.filter = selectedValue
                        }
                    }
                    WebImageView {
                        horizontalAlignment: HorizontalAlignment.Fill
                        url: minurl
                    }
                }
            }
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id: graph
            WebImageView {
                id: wiv
                scalingMethod: ScalingMethod.AspectFit
                horizontalAlignment: HorizontalAlignment.Center
                implicitLayoutAnimationsEnabled: false
            }
        }
    ]
}
