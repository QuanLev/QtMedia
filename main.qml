import QtQuick
import QtMultimedia
import QtQuick.Dialogs

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Quan - Player")

    property int video_size_width: 380
    property int video_size_height: 200
    property int video_size_width_min: 200
    property int video_size_height_min: 100

    Rectangle{
        id: control_area
        width: root.width
        height: 50
//        color: "black"


        //Time: milisecond
        Rectangle {
            width: 100
            height: 50
            Text {
                id: text_time
                color: "black"
            }
        }
        Row{
            spacing: 7
            Rectangle{
                id: btn_play
                width: 60
                height: 40
                color: "black"
                Text {
                    anchors.centerIn: parent
                    text: (player.playbackState == MediaPlayer.PlayingState)? "Play" : "Pause"
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        if(player.playbackState == MediaPlayer.PlayingState){
                            player.pause()
                        } else {
                            player.play()
                        }
                    }
                }
            }

            Rectangle{
                id: picker
                width: 100
                height: 40
                color: "black"
                Text {
                    anchors.centerIn: parent
                    text: "Choose Video"
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        fileDialog.open()
                    }
                }
            }

            Rectangle{
                id: zoomIn

                width: 100
                height: 40
                color: "black"
                Text {
                    anchors.centerIn: parent
                    text: "Zoom in"
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(video_size_width < root.width - 20){
                            video_size_width += 20
                            video_size_height += 10
                        }
                    }
                }
            }

            Rectangle{
                id: zoomOut

                width: 100
                height: 40
                color: "black"
                Text {
                    anchors.centerIn: parent
                    text: "Zoom out"
                    color: "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(video_size_width > video_size_width_min)video_size_width -= 20
                        if(video_size_height > video_size_height_min)video_size_height -= 10
                    }
                }
            }
        }
    }

    Column{
        anchors.top: control_area.bottom
        //Slider
        Rectangle {
            id: slider
            width: video_size_width
            height: 10
            color: "gray"

            MouseArea{
                anchors.fill: parent
                onMouseXChanged: {
                    console.log("mouseX changed: " + mouseX)
                    inner_slider.width = mouseX
                }
            }
            Rectangle{
                id: inner_slider
                anchors.top: slider.top
                anchors.topMargin: 3
                width: 0//video_size
                height: 4
                color: "blue"
            }
        }
        Rectangle{
            id: play_area
            anchors.topMargin: 10
            width: video_size_width
            height: video_size_height
            color: "blue"
            MediaPlayer {
                        id: player
                        videoOutput: videoOutput
                        audioOutput: AudioOutput {
                            volume: 0.5
                        }

                        onPositionChanged: {
                            text_time.text = Math.round(player.position/1000)
                            //Update time in slider
                            inner_slider.width = player.position * video_size_width/player.duration
                        }
                    }

                    VideoOutput {
                        id: videoOutput
                        anchors.fill: parent
                    }

        }
    }


    //Open video
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        nameFilters: ["Text files (*.mp4)"]
        onAccepted: {
            player.source = fileDialog.currentFile
            player.play()
        }
        onRejected: {
            console.log("Canceled")
        }

    }
}
