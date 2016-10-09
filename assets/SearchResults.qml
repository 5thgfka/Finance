import bb.cascades 1.4

Sheet {
    content:  Page{
        titleBar: TitleBar {
            title: "搜索结果"
            dismissAction: ActionItem {
                title: qsTr("Close") + Retranslate.onLanguageChanged
                onTriggered: {
                    stockPage.close()
                    if (stockPage) stockPage.destroy();
                }
            }
        }
        Container {
            Label {
                text: 'search results'
            }
        }
    }
}
