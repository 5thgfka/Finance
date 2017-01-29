import bb.cascades 1.4

Sheet {
    id: resultPage
    
    content:  Page{
        titleBar: TitleBar {
            title: "搜索结果"
            dismissAction: ActionItem {
                title: qsTr("Close") + Retranslate.onLanguageChanged
                onTriggered: {
                    resultPage.close()
                    if (resultPage) resultPage.destroy();
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
