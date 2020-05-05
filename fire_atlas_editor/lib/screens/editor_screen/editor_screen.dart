import 'package:flutter/material.dart';

import './widgets/toolbar.dart';
import './widgets/selection_canvas/selection_canvas.dart';
import './widgets/selection_list.dart';
import './widgets/preview.dart';

class EditorScreen extends StatelessWidget {
  @override
  Widget build(_) {
    return Scaffold(
        body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Body
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Toolbar(),
                        Expanded(
                            child: SelectionCanvas(),
                        ),
                      ],
                  ),
              ),
              Container(
                  width: 400,
                  child: Column(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Preview(),
                        ),
                        Expanded(
                            flex: 6,
                            child: SelectionList(),
                        ),
                      ],
                  ),
              ),
            ],
        ),
    );
  }
}
