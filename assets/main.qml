/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.4
import bb.system 1.2

TabbedPane {
    showTabsOnActionBar: true
    Tab {
        // Localized text with the dynamic translation and locale updates support
        title: qsTr("Home") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/menuicon/icon_index.png"
        Page {
            actions: [
                ActionItem {
                    id: stars
                    title: "My Stars"
                    property string lastFileName: ""
                    enabled: false
                    imageSource: "asset:///images/menuicon/icon_star_side.png"
                    onTriggered: {
                    }
                }, // ActionItem
                ActionItem {
                    id: setting
                    title: "Setting"
                    property string lastFileName: ""
                    enabled: false
                    onTriggered: {
                    }
                } // ActionItem
            ]
            content: Container {

                Header {
                    title: qsTr("search")
                }

                Container {
                    layout: GridLayout {
                        columnCount: 2
                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill

                    leftPadding: ui.du(3.3)
                    topPadding: ui.du(3.3)
                    rightPadding: ui.du(3.3)
                    bottomPadding: ui.du(3.3)

                    TextField {
                        hintText: "search stocks"
                    }
                    ImageButton {
                        defaultImageSource: "asset:///images/menuicon/icon_search.png"
                    }
                }

                Header {
                    title: qsTr("ads")
                }

                Container {
                    ImageView {
                        imageSource: "asset:///images/ads/ad1.png"

                    }
                }

                Header {
                    title: qsTr("Key")
                }

                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    focusPolicy: FocusPolicy.Default
                    background: Color.LightGray
                    leftPadding: 8.0
                    bottomPadding: 8.0
                    topPadding: 8.0
                    rightPadding: 8.0
                    ListView {
                        id: keyItemList
                        dataModel: theModel

                        //                        scrollRole: ScrollRole.None
                        snapMode: SnapMode.LeadingEdge
                        layout: StackListLayout {
                            orientation: LayoutOrientation.LeftToRight
                            headerMode: ListHeaderMode.None
                        }
//                        flickMode: FlickMode.Momentum

                        leftPadding: 8
                        rightPadding: 8
                        listItemComponents: [
                            ListItemComponent {
                                type: 'item'
                                Container {
                                    preferredHeight: ui.du(20)
                                    preferredWidth: ui.du(25)
                                    horizontalAlignment: HorizontalAlignment.Center
                                    verticalAlignment: VerticalAlignment.Top
                                    KeyItem {
                                        name: ListItemData.name
                                        nowPic: ListItemData.nowPic
                                        nowPri: ListItemData.nowPri
                                        dot: ListItemData.dot
                                        rate: ListItemData.rate
                                        yestodEndPri: ListItemData.yestodEndPri
                                    }

                                    topMargin: ui.du(1.0)
                                    leftMargin: ui.du(1.0)
                                    rightMargin: ui.du(1.0)
                                    bottomMargin: ui.du(1.0)
                                }
                            }
                        ]
                    }
                }

                Header {
                    title: qsTr("news")
                }

                // bm news
                ListView {
                    id: news
                    listItemComponents: [
                        ListItemComponent {
                        }
                    ]
                    accessibility.name: "TODO: Add property content"

                        }
    
                    }
            }
    } //End of first tab
    Tab {
        title: qsTr("Star") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/menuicon/icon_star.png"
        Page {
            Container {
                layout: DockLayout {}
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    
                    leftPadding: ui.du(3.3)
                    topPadding: ui.du(3.3)
                    rightPadding: ui.du(3.3)
                    bottomPadding: ui.du(3.3)
                    
                    //! [0]
                    // The event list filter input
                    SegmentedControl {
                        id: mainSC
                        Option {
                            text: qsTr ("All")
                            value: "all"
                            selected: true
                            onSelectedChanged: {
                            }
                        }
                        
                        Option {
                            text: qsTr ("HS")
                            value: "hs"
                            onSelectedChanged: {
                            }
                        }
                        
                        Option {
                            text: qsTr ("HK")
                            value: "hk"
                            onSelectedChanged: {
                            }
                        }
                        
                        Option {
                            text: qsTr ("USA")
                            value: "usa"
                            onSelectedChanged: {
                            
                            }
                        }
                        
                        onSelectedIndexChanged: {
                            // _calendar.filter = selectedValue
                        }
                    }
                    //! [1]
                    // The list view with all events
                    ListView {
                        dataModel: _nao.model
                        
                        listItemComponents: [
                            ListItemComponent {
                                type: "header"
                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    Label {
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 5
                                        }
                                        horizontalAlignment: HorizontalAlignment.Left
                                        verticalAlignment: VerticalAlignment.Center
                                        text: "名称"
                                    }
                                    Label {
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 2
                                        }
                                        horizontalAlignment: HorizontalAlignment.Center
                                        verticalAlignment: VerticalAlignment.Center
                                        text: "当前价"
                                    }
                                    Label {
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 2
                                        }
                                        horizontalAlignment: HorizontalAlignment.Right
                                        verticalAlignment: VerticalAlignment.Center
                                        text: "涨跌幅"
                                    }
                                }
                            },
                            ListItemComponent {
                                type: "item"
                                
                                Container {
                                    
                                    topMargin: ui.du(1.0)
                                    leftMargin: ui.du(1.0)
                                    rightMargin: ui.du(1.0)
                                    bottomMargin: ui.du(1.0)
                                    
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    
                                    Container {
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 5
                                        }
                                        horizontalAlignment: HorizontalAlignment.Left
                                        verticalAlignment: VerticalAlignment.Center
                                        Label {
                                            text: ListItemData.name
                                        }
                                    }
                                    Container {
                                        horizontalAlignment: HorizontalAlignment.Center
                                        verticalAlignment: VerticalAlignment.Center
                                        
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 2
                                        }
                                        Label {
                                            text: ListItemData.dot
                                        }
                                    }
                                    Container {
                                        horizontalAlignment: HorizontalAlignment.Right
                                        verticalAlignment: VerticalAlignment.Center
                                        background: parseFloat(ListItemData.nowPri) > parseFloat(ListItemData.yestodEndPri) ? Color.Red:Color.Green
                                        
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 2
                                        }
                                        Label {
                                            text: ListItemData.nowPic  + "%"
                                        }
                                    }
                                    
                                }
                            }
                        ]
                        onTriggered: {
                            var StPage = stockPage.createObject(_app);
                            StPage.open();
                        }
                    }
                }
            }
            actions: [
                ActionItem {
                    id: star_stars
                    title: "My Stars"
                    property string lastFileName: ""
                    enabled: false
                    imageSource: "asset:///images/menuicon/icon_star_side.png"
                    onTriggered: {
                    }
                }, // ActionItem
                ActionItem {
                    id: star_setting
                    title: "Setting"
                    property string lastFileName: ""
                    enabled: false
                    onTriggered: {
                    }
                } // ActionItem
            ]
        }
    } //End of second tab
    Tab {
        title: qsTr("transaction") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/menuicon/icon_trans.png"
        Page {
            Container {
                layout: DockLayout {}
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    
                    leftPadding: ui.du(3.3)
                    topPadding: ui.du(3.3)
                    rightPadding: ui.du(3.3)
                    bottomPadding: ui.du(3.3)
                    
                    //! [0]
                    // The event list filter input
                    SegmentedControl {
                        id: trans
                        Option {
                            text: qsTr ("实盘")
                            value: "all"
                            selected: true
                            onSelectedChanged: {
                            }
                        }
                        
                        Option {
                            text: qsTr ("模拟")
                            value: "hs"
                            onSelectedChanged: {
                            }
                        }
                        
                        onSelectedIndexChanged: {
                            // _calendar.filter = selectedValue
                        }
                    }
                    Header {
                        title: "总市值"
                    }
                }
            }
            actions: [
                ActionItem {
                    id: trans_stars
                    title: "My Stars"
                    property string lastFileName: ""
                    enabled: false
                    imageSource: "asset:///images/menuicon/icon_star_side.png"
                    onTriggered: {
                    }
                }, // ActionItem
                ActionItem {
                    id: trans_setting
                    title: "Setting"
                    property string lastFileName: ""
                    enabled: false
                    onTriggered: {
                    }
                } // ActionItem
            ]
        }
    } //End of third tab
    
    onCreationCompleted: {
        console.log("ekselog: onCreationCompleted");
        _nao.getdata();
        console.log("ekselog: _nao.getdata() Completed");
        _nao.returned.connect(appendKeyItemData);
        console.log("ekselog: _nao.getKeyItems() Completed");
    }
    
    function appendKeyItemData(success, resp){
        if (success) {
            var keyItemObj = JSON.parse(resp);
            if (keyItemObj.reason == "SUCCESSED!") {
                var yestodEndPri = keyItemObj.result[0].data.yestodEndPri;
                var nowPri = keyItemObj.result[0].data.nowPri;
                var gid = keyItemObj.result[0].data.gid;
                
                var name = keyItemObj.result[0].dapandata.name;
                var nowPic = keyItemObj.result[0].dapandata.nowPic;
                var dot = keyItemObj.result[0].dapandata.dot;
                var rate = keyItemObj.result[0].dapandata.rate;

                theModel.insert({"gid": gid, "name":name, "nowPic": nowPic, "dot": dot, "rate": rate, "yestodEndPri": yestodEndPri, "nowPri": nowPri});
            }
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: stockPage
            StockPage{
                
            }
        },
        GroupDataModel {
            id: theModel
            grouping: ItemGrouping.None
        }
    ]
}
