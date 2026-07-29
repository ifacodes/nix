pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property bool notifCenterOpen: false
    function toggleNotifCenter() { notifCenterOpen = !notifCenterOpen }
    function closeNotifCenter() { notifCenterOpen = false }

    property bool flakePanelOpen: false
    function toggleFlakePanel() { flakePanelOpen = !flakePanelOpen }
    function closeFlakePanel() { flakePanelOpen = false }
}
