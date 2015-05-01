import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"

Page {
    title: i18n.tr("About")

    Flickable {
        id: flickable
        anchors.fill: parent
        clip: true
        contentHeight: aboutColumn.height + aboutColumn.marginTop

        Column {
            id: aboutColumn
            width: parent.width
            property real marginTop: units.gu(3)
            y: marginTop

            UbuntuShape {
                property real maxWidth: units.gu(30)
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width, maxWidth)/2
                height: Math.min(parent.width, maxWidth)/2
                image: Image {
                    source: "../translate.png"
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                }
            }

            Item {
                id: spacer
                width: parent.width
                height: units.gu(2)
            }

            ListItem.Header {
                text: i18n.tr("Info:")
            }
            ListItem.Standard {
                text: i18n.tr("Version:")
                control: Label {
                    text: "4.6.2"
                }
            }

            ListItem.Header {
                text: i18n.tr("Development:")
            }
            ListItem.Standard {
                text: i18n.tr("License:")
                control: Label {
                    text: "GPL v3"
                }
                progression: true
                onClicked: Qt.openUrlExternally("http://www.gnu.org/licenses/gpl-3.0.txt")
            }
            ListItem.Standard {
                text: i18n.tr("Phrase translation:")
                control: Label {
                    text: "Glosbe"
                }
                progression: true
                onClicked: Qt.openUrlExternally("http://glosbe.com/")
            }
            ListItem.Standard {
                text: i18n.tr("String translation:")
                control: Label {
                    text: "Yandex"
                }
                progression: true
                onClicked: Qt.openUrlExternally("http://yandex.ru/")
            }

            ListItem.Header {
                text: i18n.tr("Author:")
            }
            ListItem.Standard {
                text: i18n.tr("Turan Mahmudov")
                progression: true
                onClicked: Qt.openUrlExternally("http://turanmahmudov.net/")
            }
        }
    }
}

