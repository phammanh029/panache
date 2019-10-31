import 'package:flutter/material.dart';
import 'package:panache_core/panache_core.dart';

class WebPanacheEditorTopbar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isMobileInPortrait;
  final ThemeModel model;
  final bool showCode;
  final ValueChanged<bool> onShowCodeChanged;

  WebPanacheEditorTopbar(
      {this.isMobileInPortrait,
      this.model,
      this.showCode,
      this.onShowCodeChanged});

  Future<String> _asyncInputDialog(BuildContext context) async {
    String data = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Past your theme data'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Theme data', hintText: 'eg. {}'),
                onChanged: (value) {
                  data = value;
                }
              ))
            ]
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(data);
              }
            )
          ]
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final title = Text.rich(TextSpan(text: 'Panache', children: [
      TextSpan(
          text: ' alpha',
          style: textTheme.caption.copyWith(color: Colors.blueGrey.shade900))
    ]));

    if (isMobileInPortrait) {
      return AppBar(
        title: title,
        leading: IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () => Scaffold.of(context).openDrawer()),
        actions: [
          IconButton(
            icon: Icon(showCode ? Icons.mobile_screen_share : Icons.keyboard),
            onPressed: () => onShowCodeChanged(!showCode),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          IconButton(icon: Icon(Icons.file_download), onPressed: saveTheme)
        ],
      );
    }

    return AppBar(
      title: title,
      actions: <Widget>[
        FlatButton.icon(
          textColor: Colors.blueGrey.shade50,
          icon: Icon(Icons.import_export),
          label: Text('Import'),
          onPressed: () async {
            String data = await _asyncInputDialog(context);
            if(data != null){
              importTheme(data);
            }
          },
        ),
        FlatButton.icon(
          textColor: Colors.blueGrey.shade50,
          icon: Icon(Icons.save),
          label: Text('Save'),
          onPressed: null,
        ),
        FlatButton.icon(
          textColor: Colors.blueGrey.shade50,
          icon: Icon(Icons.mobile_screen_share),
          label: Text('App preview'),
          onPressed: showCode ? () => onShowCodeChanged(false) : null,
        ),
        FlatButton.icon(
          textColor: Colors.blueGrey.shade50,
          icon: Icon(Icons.keyboard),
          label: Text('Code preview'),
          onPressed: showCode ? null : () => onShowCodeChanged(true),
        ),
        IconButton(icon: Icon(Icons.file_download), onPressed: saveTheme)
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void saveTheme() {
    model.exportTheme(name: 'theme.dart');
  }

  void importTheme(String data) {
    model.importTheme(data);
  }
}
