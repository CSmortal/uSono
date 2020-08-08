import 'package:flutter/material.dart';
import 'package:orbital_2020_usono_my_ver/Settings/ChatRoomSettings.dart';
import 'package:orbital_2020_usono_my_ver/Settings/QuestionSettings.dart';

enum SettingsPanel { chatRoom, question }

class AllSettingsPanel {
  final String roomName;
  final String roomID;

  AllSettingsPanel([this.roomName, this.roomID]);

  void showSettingsPanel(BuildContext context, SettingsPanel selection) {
//    assert(roomID != null);

//    print("roomID in AllSettingsPanel: ")

    switch (selection) {
      case SettingsPanel.chatRoom:
        {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: ChatRoomSettingsForm(),
                );
              });
        }
        break;

      case SettingsPanel.question:
        {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: QuestionSettingsForm(roomName, roomID),
                );
              });
        }

        break;
    }
  }
}
