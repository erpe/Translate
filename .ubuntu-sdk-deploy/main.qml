import QtQuick 2.0
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import "ui"
import "js/scripts.js" as Scripts

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.turan.mahmudov.translationapp"

    // Rotation
    automaticOrientation: true

    width: units.gu(50)
    height: units.gu(75)

    PageStack {
        id: pageStack
        Component.onCompleted: {
            pageStack.push(tabs);
            Scripts.initializeUser();
        }
    }

    Tabs {
        id: tabs

        TranslateTab {
            objectName: "translateTab"
        }

        StringTranslateTab {
            objectName: "stringTranslateTab"
        }

        AboutPage {
            objectName: "aboutTab"
        }
    }
}

