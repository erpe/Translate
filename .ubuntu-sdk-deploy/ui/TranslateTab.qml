import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.0 as ListItem
import QtQuick.LocalStorage 2.0
import "../components"
import "../js/scripts.js" as Scripts

Tab {
    Component.onCompleted: {
        var fromIndex = Scripts.getKey("from");
        var toIndex = Scripts.getKey("to");

        from.selectedIndex = fromIndex;
        dest.selectedIndex = toIndex;
    }

    title: i18n.tr("Phrase Translation")

    page: Page {
        id: translatetab

        Item {
            anchors {
                margins: units.gu(2)
                fill: parent
            }

            Item {
                id: langSelector
                height: dest.height > units.gu(6) ? dest.height : from.height
                width: parent.width

                ListItem.ItemSelector {
                    id: from
                    model: languagesModel
                    expanded: false
                    colourImage: false
                    delegate: selectorDelegate
                    width: parent.width/2 - units.gu(3)
                    containerHeight: units.gu(25)
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                }

                Icon {
                    name: "retweet"
                    anchors {
                        top: parent.top
                        topMargin: units.gu(1)
                        left: from.right
                        leftMargin: units.gu(1.5)
                        rightMargin: units.gu(1.5)
                    }
                    width: units.gu(3)
                    height: width
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var fr = from.selectedIndex;
                            var ds = dest.selectedIndex;

                            from.selectedIndex = ds;
                            dest.selectedIndex = fr;
                        }
                    }
                }

                ListItem.ItemSelector {
                    id: dest
                    model: languagesModel
                    expanded: false
                    colourImage: false
                    delegate: selectorDelegate
                    width: parent.width/2 - units.gu(3)
                    containerHeight: units.gu(25)
                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                }

                ListModel {
                    id: languagesModel
                    ListElement { name: "Albanian"; image: "sq.png" }
                    ListElement { name: "Arabic"; image: "ar.png" }
                    ListElement { name: "Armenian"; image: "hy.png" }
                    ListElement { name: "Azerbaijani"; image: "az.png" }
                    ListElement { name: "Belarusian"; image: "be.png" }
                    ListElement { name: "Bosnian"; image: "bs.png" }
                    ListElement { name: "Bulgarian"; image: "bg.png" }
                    ListElement { name: "Catalan"; image: "ca.png" }
                    ListElement { name: "Croatian"; image: "hr.png" }
                    ListElement { name: "Czech"; image: "cs.png" }
                    ListElement { name: "Danish"; image: "da.png" }
                    ListElement { name: "Dutch"; image: "nl.png" }
                    ListElement { name: "English"; image: "en.png" }
                    ListElement { name: "Estonian"; image: "et.png" }
                    ListElement { name: "Finnish"; image: "fi.png" }
                    ListElement { name: "French"; image: "fr.png" }
                    ListElement { name: "Georgian"; image: "ka.png" }
                    ListElement { name: "German"; image: "de.png" }
                    ListElement { name: "Greek"; image: "el.png" }
                    ListElement { name: "Hebrew"; image: "he.png" }
                    ListElement { name: "Hungarian"; image: "hu.png" }
                    ListElement { name: "Icelandic"; image: "is.png" }
                    ListElement { name: "Indonesian"; image: "id.png" }
                    ListElement { name: "Italian"; image: "it.png" }
                    ListElement { name: "Latvian"; image: "lv.png" }
                    ListElement { name: "Lithuanian"; image: "lt.png" }
                    ListElement { name: "Macedonian"; image: "mk.png" }
                    ListElement { name: "Malay"; image: "ms.png" }
                    ListElement { name: "Maltese"; image: "mt.png" }
                    ListElement { name: "Norwegian"; image: "no.png" }
                    ListElement { name: "Polish"; image: "pl.png" }
                    ListElement { name: "Portuguese"; image: "pt.png" }
                    ListElement { name: "Romanian"; image: "ro.png" }
                    ListElement { name: "Russian"; image: "ru.png" }
                    ListElement { name: "Serbian"; image: "sr.png" }
                    ListElement { name: "Slovak"; image: "sk.png" }
                    ListElement { name: "Slovenian"; image: "sl.png" }
                    ListElement { name: "Spanish"; image: "es.png" }
                    ListElement { name: "Swedish"; image: "sv.png" }
                    ListElement { name: "Turkish"; image: "tr.png" }
                    ListElement { name: "Ukrainian"; image: "uk.png" }
                    ListElement { name: "Vietnamese"; image: "vi.png" }
                }
                Component {
                    id: selectorDelegate
                    OptionSelectorDelegate { text: name; iconSource: "../graphics/flags/" + image }
                }
            }

            TextField {
                id: text
                width: parent.width - units.gu(11)
                placeholderText: "Phrase"
                hasClearButton: true
                anchors {
                    top: langSelector.bottom
                    topMargin: units.gu(1)
                    left: parent.left
                }
            }

            Button {
                id: button
                objectName: "button"
                width: units.gu(10)
                text: i18n.tr("Translate")
                anchors {
                    top: langSelector.bottom
                    topMargin: units.gu(1)
                    right: parent.right
                }
                onClicked: {
                    translatetab.dotranslation()
                }
            }

            TextArea {
                id: translateRes
                text: "<i>Translations</i>"
                textFormat : TextEdit.RichText
                readOnly: true
                anchors {
                    top: button.bottom
                    topMargin: units.gu(1)
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }
        }

        function dotranslation() {
            Scripts.translate(text.text, from.selectedIndex, dest.selectedIndex);
        }
    }
}

