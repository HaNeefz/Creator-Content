// import 'package:flutter/foundation.dart';

import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/utils/constant_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:get/route_manager.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class HtmlEditorExample extends StatefulWidget {
  HtmlEditorExample(
      {Key? key, this.data = "", this.isEdit = false, required this.index})
      : super(key: key);

  final String data;
  final bool isEdit;
  final int index;

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  String result = '';
  late HtmlEditorController controller;

  @override
  void initState() {
    controller = HtmlEditorController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (!kIsWeb) {
        //   controller.clearFocus();
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Editor Text"),
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () async {
              // Get.back(result: await controller.getText());
              Get.back(result: result != '' ? result : '');
            },
          ),
          actions: [
            // IconButton(
            //     icon: Icon(Icons.undo),
            //     onPressed: () {
            //       controller.undo();
            //     }),
            // IconButton(
            //     icon: Icon(Icons.redo),
            //     onPressed: () {
            //       controller.redo();
            //     }),
            IconButton(
                icon: Icon(Icons.done_sharp),
                onPressed: () async {
                  if (widget.isEdit) {
                    final controllerContent = ControllerContent.to;
                    controllerContent.onUpdateTextHtml(widget.index, result);
                    // widget.index, await controller.getText());
                  }
                  // Get.back(result: await controller.getText());
                  // debugPrint(
                  //     'content : ${await _keyEditor.currentState?.getText() ?? defaultTextHtml}');
                  Get.back(
                      result: await _keyEditor.currentState?.getText() ??
                          await _keyEditor.currentState?.getText() ??
                          defaultTextHtml);

                  //     .then((value) => Get.back(result: value));
                }),
          ],
        ),
        body:
            // FlutterSummernote(
            //   hint: widget.data == '' ? "Your text here..." : '',
            //   key: _keyEditor,
            //   showBottomToolbar: false,
            //   value: widget.data == defaultTextHtml ? '' : widget.data,
            //   customToolbar: """
            //   [
            //     ['fontsize', ['fontsize']],
            //     ['fontname', ['fontname']],
            //     ['color', ['color']],
            //     ['style', ['bold', 'italic', 'underline', 'clear']],
            //     ['para', ['ul', 'ol', 'paragraph']],
            //     ['font', ['strikethrough', 'superscript', 'subscript']],
            //     ['insert', ['link', 'table', 'hr']],
            //     ['misc', ['undo', 'redo']],
            //   ]
            // """,
            //   returnContent: (content) {
            //     result = content;
            //     setState(() {});
            //   },
            // ),
            SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: 'Your text here...',
                    shouldEnsureVisible: true,
                    initialText:
                        widget.data == defaultTextHtml ? '' : widget.data,
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.belowEditor, //by default
                    // toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    // toolbarType: ToolbarType.nativeGrid, //by default
                    defaultToolbarButtons: [
                      InsertButtons(
                        audio: false,
                        otherFile: false,
                        picture: false,
                        video: false,
                        hr: false,
                      ),
                      StyleButtons(),
                      // FontSettingButtons(fontName: false, fontSizeUnit: false),
                      FontSettingButtons(fontSizeUnit: false),
                      FontButtons(clearAll: false),
                      ColorButtons(),
                      ListButtons(listStyles: false),
                      ParagraphButtons(
                          caseConverter: false,
                          lineHeight: false,
                          textDirection: false),
                      OtherButtons(
                          fullscreen: false,
                          codeview: false,
                          help: false,
                          undo: false,
                          redo: false),
                    ],
                    customToolbarButtons: [
                      //your widgets here
                      // Button1(),
                      // Icon(Icons.home),
                      // Icon(Icons.settings),
                      // Button2(),
                    ],

                    onButtonPressed: (ButtonType type, bool? status,
                        Function()? updateStatus) {
                      print(
                          "button '${describeEnum(type)}' pressed, the current selected status is $status");
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      print(
                          "dropdown '${describeEnum(type)}' changed to $changed");
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      print(url);
                      return true;
                    },
                    mediaUploadInterceptor: (file, InsertFileType type) async {
                      print(file.name); //filename
                      print(file.size); //size in bytes
                      print(file.extension); //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  otherOptions: OtherOptions(
                      height: MediaQuery.of(context).size.height / 2 + 100),
                  callbacks: Callbacks(
                    onBeforeCommand: (String? currentHtml) {
                      print('html before change is $currentHtml');
                    },
                    onChangeContent: (String? changed) {
                      print('content changed to $changed');
                    },
                    onChangeCodeview: (String? changed) {
                      print('code changed to $changed');
                    },
                    onChangeSelection: (EditorSettings settings) {
                      print('parent element is ${settings.parentElement}');
                      print('font name is ${settings.fontName}');
                    },
                    onDialogShown: () {
                      print('dialog shown');
                    },
                    onEnter: () {
                      print('enter/return pressed');
                    },
                    onFocus: () {
                      print('editor focused');
                    },
                    onBlur: () {
                      print('editor unfocused');
                    },
                    onBlurCodeview: () {
                      print('codeview either focused or unfocused');
                    },
                    onInit: () {
                      print('init');
                    },
                    //this is commented because it overrides the default Summernote handlers
                    /*onImageLinkInsert: (String? url) {
                      print(url ?? "unknown url");
                    },
                    onImageUpload: (FileUpload file) async {
                      print(file.name);
                      print(file.size);
                      print(file.type);
                      print(file.base64);
                    },*/
                    onImageUploadError: (FileUpload? file, String? base64Str,
                        UploadError error) {
                      print(describeEnum(error));
                      print(base64Str ?? '');
                      if (file != null) {
                        print(file.name);
                        print(file.size);
                        print(file.type);
                      }
                    },
                    onKeyDown: (int? keyCode) {
                      print('$keyCode key downed');
                    },
                    onKeyUp: (int? keyCode) {
                      print('$keyCode key released');
                    },
                    onMouseDown: () {
                      print('mouse downed');
                    },
                    onMouseUp: () {
                      print('mouse released');
                    },
                    onPaste: () {
                      print('pasted into editor');
                    },
                    onScroll: () {
                      print('editor scrolled');
                    },
                  ),
                  plugins: [
                    SummernoteAtMention(
                        getSuggestionsMobile: (String value) {
                          var mentions = <String>['test1', 'test2', 'test3'];
                          return mentions
                              .where((element) => element.contains(value))
                              .toList();
                        },
                        mentionsWeb: ['test1', 'test2', 'test3'],
                        onSelect: (String value) {
                          print(value);
                        }),
                  ],
                ),
                //         // Padding(
                //         //   padding: const EdgeInsets.all(8.0),
                //         //   child: Row(
                //         //     mainAxisAlignment: MainAxisAlignment.center,
                //         //     children: <Widget>[
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Colors.blueGrey),
                //         //         onPressed: () {
                //         //           controller.undo();
                //         //         },
                //         //         child:
                //         //             Text('Undo', style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Colors.blueGrey),
                //         //         onPressed: () {
                //         //           controller.clear();
                //         //         },
                //         //         child:
                //         //             Text('Reset', style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () async {
                //         //           var txt = await controller.getText();
                //         //           if (txt.contains('src=\"data:')) {
                //         //             txt =
                //         //                 '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                //         //           }
                //         //           setState(() {
                //         //             result = txt;
                //         //           });
                //         //         },
                //         //         child: Text(
                //         //           'Submit',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () {
                //         //           controller.redo();
                //         //         },
                //         //         child: Text(
                //         //           'Redo',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //         // Padding(
                //         //   padding: const EdgeInsets.all(8.0),
                //         //   child: Text(result),
                //         // ),
                //         // Padding(
                //         //   padding: const EdgeInsets.all(8.0),
                //         //   child: Row(
                //         //     mainAxisAlignment: MainAxisAlignment.center,
                //         //     children: <Widget>[
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Colors.blueGrey),
                //         //         onPressed: () {
                //         //           controller.disable();
                //         //         },
                //         //         child: Text('Disable',
                //         //             style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () async {
                //         //           controller.enable();
                //         //         },
                //         //         child: Text(
                //         //           'Enable',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //         // SizedBox(height: 16),
                //         // Padding(
                //         //   padding: const EdgeInsets.all(8.0),
                //         //   child: Row(
                //         //     mainAxisAlignment: MainAxisAlignment.center,
                //         //     children: <Widget>[
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () {
                //         //           controller.insertText('Google');
                //         //         },
                //         //         child: Text('Insert Text',
                //         //             style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () {
                //         //           controller.insertHtml(
                //         //               '''<p style="color: blue">Google in blue</p>''');
                //         //         },
                //         //         child: Text('Insert HTML',
                //         //             style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //         // Padding(
                //         //   padding: const EdgeInsets.all(8.0),
                //         //   child: Row(
                //         //     mainAxisAlignment: MainAxisAlignment.center,
                //         //     children: <Widget>[
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () async {
                //         //           controller.insertLink(
                //         //               'Google linked', 'https://google.com', true);
                //         //         },
                //         //         child: Text(
                //         //           'Insert Link',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () {
                //         //           controller.insertNetworkImage(
                //         //               'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png',
                //         //               filename: 'Google network image');
                //         //         },
                //         //         child: Text(
                //         //           'Insert network image',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //         // SizedBox(height: 16),
                //         // Padding(
                //         //   padding: const EdgeInsets.all(8.0),
                //         //   child: Row(
                //         //     mainAxisAlignment: MainAxisAlignment.center,
                //         //     children: <Widget>[
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Colors.blueGrey),
                //         //         onPressed: () {
                //         //           controller.addNotification(
                //         //               'Info notification', NotificationType.info);
                //         //         },
                //         //         child:
                //         //             Text('Info', style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Colors.blueGrey),
                //         //         onPressed: () {
                //         //           controller.addNotification(
                //         //               'Warning notification', NotificationType.warning);
                //         //         },
                //         //         child: Text('Warning',
                //         //             style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () async {
                //         //           controller.addNotification(
                //         //               'Success notification', NotificationType.success);
                //         //         },
                //         //         child: Text(
                //         //           'Success',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () {
                //         //           controller.addNotification(
                //         //               'Danger notification', NotificationType.danger);
                //         //         },
                //         //         child: Text(
                //         //           'Danger',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //         // SizedBox(height: 16),
                //         // Padding(
                //         //   padding: const EdgeInsets.all(8.0),
                //         //   child: Row(
                //         //     mainAxisAlignment: MainAxisAlignment.center,
                //         //     children: <Widget>[
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Colors.blueGrey),
                //         //         onPressed: () {
                //         //           controller.addNotification('Plaintext notification',
                //         //               NotificationType.plaintext);
                //         //         },
                //         //         child: Text('Plaintext',
                //         //             style: TextStyle(color: Colors.white)),
                //         //       ),
                //         //       SizedBox(
                //         //         width: 16,
                //         //       ),
                //         //       TextButton(
                //         //         style: TextButton.styleFrom(
                //         //             backgroundColor: Theme.of(context).accentColor),
                //         //         onPressed: () async {
                //         //           controller.removeNotification();
                //         //         },
                //         //         child: Text(
                //         //           'Remove',
                //         //           style: TextStyle(color: Colors.white),
                //         //         ),
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlutterSummernoteWidget extends StatefulWidget {
  FlutterSummernoteWidget();

  @override
  _FlutterSummernoteWidgetState createState() =>
      _FlutterSummernoteWidgetState();
}

class _FlutterSummernoteWidgetState extends State<FlutterSummernoteWidget> {
  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final value = await _keyEditor.currentState?.getText();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: Text(value ?? "-"),
              ));
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: FlutterSummernote(
        hint: "Your text here...",
        key: _keyEditor,
        hasAttachment: true,
        customToolbar: """
          [
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['insert', ['link', 'table', 'hr']],
          ]
        """,
      ),
    );
  }
}
