import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/home/model/message_entity.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sp_util/sp_util.dart';
import 'package:flutter_yizhi/res/constant.dart';

import '../../widget/load_image.dart';

class Message extends StatefulWidget {
  const Message(this.id, {Key? key}) : super(key: key);

  final int id;

  @override
  MessageState createState() {
    return MessageState();
  }
}

class MessageState extends State<Message> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageNodeText = FocusNode();
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();
  double _draggableScrollableSize = 0.7;

  final ScrollController _listScrollController = ScrollController();
  late IO.Socket socket;

  String _count = '0';

  bool _isLoading = true;

  List<MessageEntity> _messageList = [];

  bool displayNewMessage = false;

  void _init() async {
    setState(() {
      _isLoading = true;
    });
    try {
      BaseEntity<List<MessageEntity>> res =
          await HomeRepository.getRecentMessage(widget.id);
      if (res.code == 1000) {
        setState(() {
          _messageList = res.data ?? [];
        });
      } else {
        Toast.show(res.message);
      }
      final String? accessToken = SpUtil.getString(Constant.accessToken);
      socket = IO.io(
          '${Constant.socketUrl}chat',
          OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
              .setAuth({"token": accessToken}) // optional
              .setExtraHeaders({
            "client-type": "app",
            "room-id": widget.id,
          }).build());
      socket.onError((data) => {
            print('onError'),
            print(data),
          });
      socket.onConnect((_) {
        print('connect');
      });
      socket.on('message', (data) {
        print(data);
        // 添加到首位
        _messageList.insert(
            0,
            MessageEntity(
                id: data['id'],
                userId: data['userId'],
                message: data['message'],
                nickName: data['nickName'],
                avatarUrl: data['avatarUrl'] ?? '',
                dataId: data['dataId']));
        setState(() {});
      });
      socket.on('users', (data) {
        int count = data;
        // 如何count大于10000，显示count/10000万
        if (count > 10000) {
          count = count ~/ 10000;
          _count = '$count 万';
        } else {
          _count = '$count';
        }
        print('----users----');
        print(count);
        print('----users----');
        setState(() {});
      });
      socket.onDisconnect((_) {
        print('disconnect');
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('-----------------');
      print(e);
      print('-----------------');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _draggableScrollableController.addListener(() {
      setState(() {
        _draggableScrollableSize = _draggableScrollableController.size;
      });
    });
    _listScrollController.addListener(() {
      if (_listScrollController.position.pixels >
          _listScrollController.position.minScrollExtent + 100) {
        // 是否显示新消息按钮
        setState(() {
          displayNewMessage = true;
        });
      } else {
        setState(() {
          displayNewMessage = false;
        });
      }
    });
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
    _messageController.dispose();
    _messageNodeText.dispose();
    _draggableScrollableController.dispose();
    _listScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context); // 点击关闭模态底部页面
            },
            child: DraggableScrollableSheet(
                controller: _draggableScrollableController,
                expand: true,
                initialChildSize: 0.7,
                maxChildSize: 1,
                minChildSize: 0.7,
                builder: (builder, scrollController) => GestureDetector(
                    onTap: () {},
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            _draggableScrollableSize,
                        decoration: const BoxDecoration(
                            color: Color(0xffF9F9F9),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(4))),
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffE3E6ED),
                                      offset: Offset(7, 7),
                                      blurRadius: 8.0,
                                      spreadRadius: 0.0),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 5,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffF5F5F5),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '实时聊天',
                                        style: TextStyle(
                                            color: Colours.app_main,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            color: Color(0xff616161),
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _count,
                                            style: const TextStyle(
                                                color: Color(0xff616161),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    _isLoading
                                        ? const SpinKitDoubleBounce(
                                            size: 24,
                                            color: Colours.app_main,
                                          )
                                        : ListView.builder(
                                            controller: _listScrollController,
                                            reverse: true,
                                            itemCount: _messageList.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index ==
                                                  _messageList.length) {
                                                return Container(
                                                  margin:
                                                      const EdgeInsets.all(20),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffe4e4e7),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: const Column(
                                                    children: [
                                                      Text(
                                                        '系统提示:一枝分享内容及实时聊天严禁传播违法违规、低俗血暴、吸烟酗酒、造谣诈骗等不良有害信息。',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                              MessageEntity item =
                                                  _messageList[index];
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10,
                                                    index + 1 ==
                                                            _messageList.length
                                                        ? 10
                                                        : 5,
                                                    10,
                                                    index + 1 ==
                                                            _messageList.length
                                                        ? 10
                                                        : 5),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  15)),
                                                      child: LoadImage(
                                                          item.avatarUrl
                                                                  .isNotEmpty
                                                              ? item.avatarUrl
                                                              : 'default-avatar',
                                                          height: 25.0,
                                                          width: 25.0,
                                                          fit: BoxFit.fill),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: item.nickName,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff717179),
                                                              fontSize: 12),
                                                          children: <TextSpan>[
                                                            const TextSpan(
                                                                text: '  '),
                                                            TextSpan(
                                                                text: item
                                                                    .message,
                                                                style: const TextStyle(
                                                                    color: Colours
                                                                        .app_main,
                                                                    fontSize:
                                                                        12)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                    displayNewMessage
                                        ? Positioned(
                                            bottom: 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                _listScrollController.animateTo(
                                                    _listScrollController
                                                        .position
                                                        .minScrollExtent,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeIn);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 15),
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: Colours.app_main,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                                child: const Text(
                                                  '新消息',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontFamily: "KaiTi",
                                                  ),
                                                ),
                                              ),
                                            ))
                                        : SizedBox()
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xffEAEAEA),
                                        offset: Offset(0.0, -1),
                                        blurRadius: 8.0,
                                        spreadRadius: 0.0),
                                  ],
                                ),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Container(
                                        // height: 37,
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 5, 15, 5),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffF5F5F5),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: TextField(
                                          style: const TextStyle(
                                            height: 1,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            fontSize: 16,
                                          ),
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          cursorColor: Colours.app_main,
                                          focusNode: _messageNodeText,
                                          controller: _messageController,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                          minLines: 1,
                                          decoration: const InputDecoration(
                                            // contentPadding: EdgeInsets.all(1),
                                            hintText: '聊天...',
                                            counterText: '',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          socket.emit('message', {
                                            'message': _messageController.text
                                          });
                                          _messageController.clear();
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: Colours.app_main,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: const Text(
                                            '发送',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              decoration: TextDecoration.none,
                                              fontFamily: "KaiTi",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]))
                          ],
                        ),
                      ),
                    )))));
  }
}
