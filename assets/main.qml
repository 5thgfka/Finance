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
        id: home_tab
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
                        onClicked: {
                            var searchResultPage = searchResultsDef.createObject();
                            searchResultPage.open();
                        }
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
                    //                    horizontalAlignment: HorizontalAlignment.Center
                    //                    focusPolicy: FocusPolicy.Default
                    background: Color.LightGray
                    //                    leftPadding: 35.0
                    //                    bottomPadding: 8.0
                    //                    topPadding: 8.0
                    //                    rightPadding: 15.0
                    ListView {
                        id: keyItemList
                        dataModel: theKeyItemsModel
                        //                        stickToEdgePolicy: ListViewStickToEdgePolicy.Default
                        //                        scrollRole: ScrollRole.None
                        snapMode: SnapMode.LeadingEdge
                        layout: StackListLayout {
                            orientation: LayoutOrientation.LeftToRight
                            headerMode: ListHeaderMode.None
                        }
                        flickMode: FlickMode.Momentum
                        scrollIndicatorMode: ScrollIndicatorMode.None
                        //                        leftPadding: 8
                        //                        rightPadding: 8
                        listItemComponents: [
                            ListItemComponent {
                                type: 'item'
                                Container {
                                    preferredHeight: ui.du(20)
                                    preferredWidth: ui.du(25)
                                    topPadding: 20
                                    leftPadding: 15
                                    rightPadding: 5
                                    horizontalAlignment: HorizontalAlignment.Center
                                    verticalAlignment: VerticalAlignment.Center
                                    KeyItem {
                                        name: ListItemData.name
                                        nowPic: ListItemData.nowPic
                                        nowPri: ListItemData.nowPri
                                        dot: ListItemData.dot
                                        rate: ListItemData.rate
                                        yestodEndPri: ListItemData.yestodEndPri
                                        topPadding: 20.0
                                        bottomMargin: 20.0
                                        topMargin: 20.0
                                        bottomPadding: 20.0
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
        id: star_tab
        title: qsTr("Star") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/menuicon/icon_star.png"
        Page {
            Container {
                layout: DockLayout {
                }
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
                            text: qsTr("All")
                            value: "all"
                            selected: true
                        }

                        Option {
                            text: qsTr("HS")
                            value: "hs"
                        }

                        Option {
                            text: qsTr("HK")
                            value: "hk"
                        }

                        Option {
                            text: qsTr("USA")
                            value: "usa"
                        }

                        onSelectedIndexChanged: {
                            // _calendar.filter = selectedValue
                        }
                    }
                    //! [1]
                    // The list view with all events
                    ListView {
                        dataModel: theStarItemsModel

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
                                    preferredHeight: ui.du(10)
                                    background: Color.Gray
                                    
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
                                        background: parseFloat(ListItemData.nowPri) > parseFloat(ListItemData.yestodEndPri) ? Color.Red : Color.Green

                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 2
                                        }
                                        Label {
                                            text: parseFloat(ListItemData.nowPic) < 0 ? ListItemData.nowPic + "%": "+" + ListItemData.nowPic + "%"
                                            horizontalAlignment: HorizontalAlignment.Right
                                        }
                                    }
                                }
                            }
                        ]
                        onTriggered: {
                            var selected = theStarItemsModel.data(indexPath);
                            console.log(selected.name);
                            var StPage = stockPage.createObject(_app);
                            StPage.gid = selected.gid;
                            StPage.name = selected.name;
                            StPage.nowPri = selected.nowPri;
                            StPage.nowPic = selected.nowPic;
                            StPage.rate = selected.rate;
                            StPage.yestodEndPri = selected.yestodEndPri;
                            StPage.traAmount = selected.traAmount;
                            StPage.traNumber = selected.traNumber;
                            StPage.todayStartPri = selected.todayStartPri;
                            StPage.todayMax = selected.todayMax;
                            StPage.todayMin = selected.todayMin;
                            StPage.monthurl = selected.monthurl;
                            StPage.weekurl = selected.weekurl;
                            StPage.dayurl = selected.dayurl;
                            StPage.minurl = selected.minurl;
                            StPage.stared = true;
                            
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
    
    onCreationCompleted: {
        //        theModel.insert({"gid": "123", "name":"上证指数", "nowPic": "-17.32", "dot": "2979.3388", "rate": "12", "yestodEndPri": "123", "nowPri": "123"});
        //        theModel.insert({"gid": "123", "name":"上证指数", "nowPic": "-17.32", "dot": "2979.3388", "rate": "12", "yestodEndPri": "123", "nowPri": "123"});
        //        theModel.insert({"gid": "123", "name":"上证指数", "nowPic": "-17.32", "dot": "2979.3388", "rate": "12", "yestodEndPri": "123", "nowPri": "123"});
//        theStarItemsModel.insert({"gid": "123", "name":"上证指数", "nowPic": "-17.32", "dot": "2979.3388", "rate": "12", "yestodEndPri": "123", "nowPri": "123"});
        _nao.starReturned.connect(appendStarItemData);
        _nao.keyReturned.connect(appendKeyItemData);
        _nao.getSimulationData.connect(getSimulateData);
    }
    
    function getSimulateData(resp){
        var size = resp.size;
        if(size == 0){
            total = 0;
            dayincome = 0;
            income = 0;
            rate = 0;
        }
        else{
            total = resp.total;
            dayincome = resp.dayincome;
            income = resp.income;
            rate = resp.rate;
        }
    }
    
    function appendStarItemData(success, resp) {
        if (success) {
            var keyItemObj = JSON.parse(resp);
            if (keyItemObj.reason == "SUCCESSED!") {
                var yestodEndPri = keyItemObj.result[0].data.yestodEndPri;
                var nowPri = keyItemObj.result[0].data.nowPri;
                var gid = keyItemObj.result[0].data.gid;
                var sellFive = keyItemObj.result[0].data.sellFive;
                var sellFivePri = keyItemObj.result[0].data.sellFivePri;
                var sellFour = keyItemObj.result[0].data.sellFour;
                var sellFourPri = keyItemObj.result[0].data.sellFourPri;
                var sellThree = keyItemObj.result[0].data.sellThree;
                var sellThreePri = keyItemObj.result[0].data.sellThreePri;
                var sellTwo = keyItemObj.result[0].data.sellTwo;
                var sellTwoPri = keyItemObj.result[0].data.sellTwoPri;
                var sellOne = keyItemObj.result[0].data.sellOne;
                var sellOnePri = keyItemObj.result[0].data.sellOnePri;
                var buyFive = keyItemObj.result[0].data.buyFive;
                var buyFivePri = keyItemObj.result[0].data.buyFivePri;
                var buyFour = keyItemObj.result[0].data.buyFour;
                var buyFourPri = keyItemObj.result[0].data.buyFourPri;
                var buyThree = keyItemObj.result[0].data.buyThree;
                var buyThreePri = keyItemObj.result[0].data.buyThreePri;
                var buyTwo = keyItemObj.result[0].data.buyTwo;
                var buyTwoPri = keyItemObj.result[0].data.buyTwoPri;
                var buyOne = keyItemObj.result[0].data.buyOne;
                var buyOnePri = keyItemObj.result[0].data.buyOnePri;
                var todayMax = keyItemObj.result[0].data.todayMax;
                var todayMin = keyItemObj.result[0].data.todayMin;
                var todayStartPri = keyItemObj.result[0].data.todayStartPri;
                var traAmount = keyItemObj.result[0].data.traAmount;
                var traNumber = keyItemObj.result[0].data.traNumber;
                
                var name = keyItemObj.result[0].data.name;
                var nowPic = keyItemObj.result[0].data.increase;
                var dot = keyItemObj.result[0].data.nowPri;
                var rate = keyItemObj.result[0].data.increPer;
                
                var minurl = keyItemObj.result[0].gopicture.minurl
                var dayurl = keyItemObj.result[0].gopicture.dayurl
                var weekurl = keyItemObj.result[0].gopicture.weekurl
                var monthurl = keyItemObj.result[0].gopicture.monthurl
                
                var dict = {
                     "gid": gid, "dot": dot, "name": name,
                     "rate": rate, "nowPic": nowPic, "yestodEndPri": yestodEndPri, 
                     "nowPri": nowPri, "sellFive": sellFive, "sellFivePri": sellFivePri, 
                     "sellFour": sellFour, "sellFourPri": sellFourPri, "sellThree": sellThree, 
                     "sellThreePri": sellThreePri, "sellTwo": sellTwo, "sellTwoPri": sellTwoPri, 
                     "sellOne": sellOne, "sellOnePri": sellOnePri, "buyFive": buyFive, 
                     "buyFivePri": buyFivePri, "buyFour": buyFour, "buyFourPri": buyFourPri, 
                     "buyThree": buyThree, "buyThreePri": buyThreePri, "buyTwo": buyTwo, 
                     "buyTwoPri": buyTwoPri, "buyOne": buyOne, "buyOnePri": buyOnePri, 
                     "todayMax": todayMax, "todayMin": todayMin, "todayStartPri": todayStartPri,
                     "traAmount": traAmount, "traNumber": traNumber, "minurl": minurl,
                     "dayurl": dayurl, "weekurl": weekurl, "monthurl": monthurl
                     };
                theStarItemsModel.insert(dict);
                theStarItemsBackModel.insert(dict);
            }
        }
    }

    function appendKeyItemData(success, resp) {
        if (success) {
            var keyItemObj = JSON.parse(resp);
            if (keyItemObj.reason == "SUCCESSED!") {
                var yestodEndPri = keyItemObj.result[0].data.yestodEndPri;
                var nowPri = keyItemObj.result[0].data.nowPri;
                var gid = keyItemObj.result[0].data.gid;

                var name = keyItemObj.result[0].data.name;
                var nowPic = keyItemObj.result[0].data.increase;
                var dot = keyItemObj.result[0].data.nowPri;
                var rate = keyItemObj.result[0].data.increPer;

                theKeyItemsModel.insert({"gid": gid, "name":name, "nowPic": nowPic, "dot": dot, "rate": rate, "yestodEndPri": yestodEndPri, "nowPri": nowPri});
            }
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: searchResultsDef
            content: SearchResults {}
        },
        
        ComponentDefinition {
            id: stockPage
            StockPage{
                
            }
        },
        GroupDataModel {
            id: theKeyItemsModel
            grouping: ItemGrouping.None
        },
        GroupDataModel {
            id: theStarItemsModel
            grouping: ItemGrouping.None
        },
        GroupDataModel {
            id: theStarItemsBackModel
            grouping: ItemGrouping.None
        },
        GroupDataModel {
            id:simulateModel
            grouping: ItemGrouping.None
        }
    ]
}
