import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sabas.sabasplugin 1.0

Page {
    function isLocalCover(url) {
        var pre = "file://";
        return (url.substring(0, pre.length) === pre);
    }
    property var book
    property int selectedIndex
    property bool coverSelected: false
    id: page
    PageHeader {
        id: header
        title: qsTr("Select cover")
    }
    Item {
        id: searchRow
        width: parent.width
        anchors.top: header.bottom
        height: searchButton.height
        TextField {
            id: searchField
            anchors {
                right: searchButton.left
                left: parent.left
            }
            onTextChanged: searchButton.enabled = true
        }
        IconButton {
            id: searchButton
            icon.source: "image://theme/icon-m-search"
            anchors {
                right: parent.right
            }
            onClicked: {
                SabasLibrary.searchCover(book, searchField.text, false)
                enabled = false
            }
            visible: !SabasLibrary.searchingCover
        }
        BusyIndicator {
            anchors {
                right: parent.right
                rightMargin: Theme.paddingLarge
            }
            visible: SabasLibrary.searchingCover
            running: SabasLibrary.searchingCover
        }
    }
    SilicaGridView {
        id: grid
        model: book.possibleCovers
        width: parent.width
        cellHeight: 200
        cellWidth: parent.width / 3
        boundsBehavior: Flickable.DragOverBounds
        clip: true
        anchors {
            bottom: parent.bottom
            top: searchRow.bottom
        }
        delegate: Image {
            id: image
            source: modelData
            fillMode: Image.PreserveAspectCrop
            width: grid.cellWidth
            height: grid.cellHeight
            Label {
                text: qsTr("Local")
                font.bold: true
                color: Theme.highlightColor
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                }
                visible: isLocalCover(image.source.toString())
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("UseCoverDialog.qml", {"url":image.source})
                    dialog.accepted.connect(function () {
                        if (isLocalCover(image.source.toString()))
                            book.setCoverPath(image.source)
                        else
                            SabasLibrary.downloadCover(image.source, book)
                        coverSelected = true
                    })
                }
            }
        }
        ScrollDecorator {}
    }
    Component.onCompleted: {
        searchField.text = book.name
    }
    onStatusChanged: {
        if (status === PageStatus.Active && coverSelected) {
            pageStack.pop()
        }
    }
}
