import 'dart:async';
import 'package:chat_flutter/models/chat_model.dart';
import 'package:chat_flutter/pages/widgets/build_avatar.dart';
import 'package:chat_flutter/pages/widgets/build_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scollController = ScrollController();
  bool isSwitch = false;
  bool isReply = false;
  ChatModel? chatReply;
  List<SvgPicture> iconList1 = [
    SvgPicture.asset('assets/icons/like.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/love.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/haha.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/sad.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/angry.svg', height: 30.0, width: 30.0),
  ];

  List<SvgPicture> iconList2 = [
    SvgPicture.asset('assets/icons/like.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/love.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/haha.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/sad.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/angry.svg', height: 30.0, width: 30.0),
    SvgPicture.asset('assets/icons/cancel.svg', height: 30.0, width: 30.0),
  ];

  void _sendMessage(String message) {
    if (message.isEmpty) {
      return;
    }

    final user = UserModel.fromJson({
      'id': '2',
      'name': 'Bibliothèque 2',
      'image': 'https://picsum.photos/250?image=202',
    });
    final newChat = ChatModel()
      ..id = '${int.parse(FakeChats.chats.last.id ?? '') + 1}'
      // ..id = Util.getID()
      ..message = message
      ..user = user
      ..chatReply = chatReply;

    isReply = false;
    FakeChats.chats.add(newChat);

    messageController.clear();
    _scrollScreen();
    setState(() {});
  }

  void _deleteMessage(String id) {
    FakeChats.chats.removeWhere((element) => element.id == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        for (ChatModel chat in FakeChats.chats) {
          chat.isShowFeeling = false;
        }
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: !isSwitch ? const Color(0xff191970) : Colors.blue,
        body: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SlidableAutoCloseBehavior(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0)
                      .copyWith(top: 16.0, bottom: 20.0),
                  controller: scollController,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14.0),
                  itemBuilder: (context, index) {
                    final chat = FakeChats.chats[index];
                    bool isMe = ((chat.user ?? UserModel()).id ?? '') == '2';
                    bool isRecall = chat.isRecall ?? false;
                    return GestureDetector(
                      onLongPress: () {
                        chat.isShowFeeling = true;
                        for (ChatModel chat1 in FakeChats.chats) {
                          if (chat1 != chat) {
                            chat1.isShowFeeling = false;
                          }
                        }
                        if (FakeChats.chats.length - 1 == index) {
                          Timer(const Duration(milliseconds: 20),
                              () => _scollController());
                          //cach2
                          // WidgetsBinding.instance.scheduleFrameCallback((_) {
                          //   _scrollScreen();
                          // });
                        }
                        setState(() {});
                      },
                      child: Slidable(
                        key: ValueKey(chat.id),
                        startActionPane:
                            isMe ? null : _buildActionPaneOne(chat),
                        endActionPane: isMe
                            ? (chat.isRecall ?? false)
                                ? _buildActionPaneThree(chat, isRecall)
                                : _buildActionPaneTwo(chat, isRecall)
                            : null,
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (chat.chatReply != null)
                              Container(
                                margin: const EdgeInsets.only(right: 38.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: const Color(0xff383D3F)
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10.0)),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.6),
                                child: Text(
                                  chat.chatReply?.message ?? '',
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isMe) ...[
                                  BuildAvatar(chat),
                                  const SizedBox(width: 6.0),
                                ],
                                Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: chat.iconSvg == null
                                              ? 4.0
                                              : 18.0),
                                      child: _buildMessageBox(
                                          isMe, isRecall, context, chat),
                                    ),
                                    if (chat.iconSvg != null)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: CircleAvatar(
                                          radius: 14.0,
                                          backgroundColor: Colors.grey,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: chat.iconSvg,
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 6.0),
                                  BuildAvatar(chat),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2.0),
                            if (chat.isShowFeeling == true)
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                                height: 30.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ...List.generate(
                                      chat.iconSvg == null
                                          ? iconList1.length
                                          : iconList2.length,
                                      (index) => GestureDetector(
                                        onTap: () {
                                          chat.iconSvg = iconList2[index];
                                          if (chat.iconSvg != null) {
                                            if (index == iconList2.length - 1) {
                                              chat.iconSvg = null;
                                            }
                                          }
                                          chat.isShowFeeling = false;
                                          setState(() {});
                                        },
                                        child: chat.iconSvg == null
                                            ? iconList1[index]
                                            : iconList2[index],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            const SizedBox(height: 2.0),
                            if (chat.isShowFeeling ?? false)
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  children: [
                                    if (!(chat.isRecall ?? false))
                                      BuildSelect(
                                          onPressed: () {
                                            isReply = true;
                                            chatReply = chat;
                                            chat.isShowFeeling = false;
                                            setState(() {});
                                          },
                                          text: 'Trả lời',
                                          icon: const Icon(Icons.reply)),
                                    if (!(chat.isRecall ?? false))
                                      const Divider(color: Colors.grey),
                                    if (isMe)
                                      BuildSelect(
                                          onPressed: () {
                                            chat.isRecall =
                                                !(chat.isRecall ?? false);
                                            chat.isShowFeeling = false;
                                            setState(() {});
                                          },
                                          text: !(chat.isRecall ?? false)
                                              ? 'Thu hồi'
                                              : 'Phục hồi',
                                          icon: const Icon(Icons.replay)),
                                    if (isMe) const Divider(color: Colors.grey),
                                    BuildSelect(
                                        onPressed: () {
                                          _deleteMessage(chat.id ?? '');
                                          chat.isShowFeeling = false;
                                        },
                                        text: 'Xóa',
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: FakeChats.chats.length,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24.0),
          child: _buildWriteMessageBox(),
        ),
      ),
    );
  }

  void _scollController() {
    scollController.animateTo(scollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10), curve: Curves.bounceIn);
  }

  Widget _buildWriteMessageBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isReply)
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xff383D3F).withOpacity(0.4)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ((chatReply?.user ?? UserModel()).id ?? '') != '2'
                            ? 'Đang trả lời ${chatReply?.user?.name ?? ''}'
                            : 'Đang trả lời chính mình ',
                        style: const TextStyle(
                            color: Colors.orange, fontSize: 12.0),
                      ),
                      Text(
                        chatReply?.message ?? '-.-',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    isReply = false;
                    chatReply = null;
                    setState(() {});
                  },
                  child: const CircleAvatar(
                    radius: 8.0,
                    child: Icon(
                      Icons.close,
                      size: 16.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        Container(
          decoration: BoxDecoration(
              color: isReply ? const Color(0xff383D3F).withOpacity(0.4) : null,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0))),
          child: TextField(
            controller: messageController,
            onTap: () {
              Timer(
                const Duration(milliseconds: 600),
                () => _scrollScreen(),
              );
            },
            style: const TextStyle(color: Colors.orange),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff383D3F).withOpacity(0.4),
              hintStyle:
                  const TextStyle(color: Color(0xffB7B8BA), fontSize: 14.0),
              hintText: 'Nhập tin nhắn...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              suffixIcon: GestureDetector(
                onTap: () => _sendMessage(messageController.text.trim()),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ActionPane _buildActionPaneOne(ChatModel chat) {
    return ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (_) => _deleteMessage(chat.id ?? ''),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
        SlidableAction(
          onPressed: (_) {},
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }

  ActionPane _buildActionPaneTwo(ChatModel chat, bool isRecall) {
    return ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (_) => _deleteMessage(chat.id ?? ''),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
        SlidableAction(
          onPressed: (_) {
            chat.isRecall = true;
            setState(() {});
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.beach_access,
        ),
        SlidableAction(
          onPressed: (_) {},
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }

  ActionPane _buildActionPaneThree(ChatModel chat, bool isRecall) {
    return ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (_) => _deleteMessage(chat.id ?? ''),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
        SlidableAction(
          onPressed: (_) {
            chat.isRecall = false;
            setState(() {});
          },
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.white,
          icon: Icons.replay,
        ),
        SlidableAction(
          onPressed: (_) {},
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }

  Padding _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
        top: MediaQuery.of(context).padding.top + 6.0,
        bottom: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/avt.png', width: 44.0),
          const Text(
            'Virtusl Coach',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          Container(
            width: 122.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: const Color(0xffFFFFFF).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 7.6, horizontal: 16.0),
                  child: Image.asset('assets/images/bird.png',
                      width: 42.0, height: 36.0),
                ),
                GestureDetector(
                  onTap: () => setState(() => isSwitch = !isSwitch),
                  child: Container(
                    width: 38.0,
                    height: 22.0,
                    padding: const EdgeInsets.all(2.4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(11.6),
                    ),
                    child: Align(
                      alignment: !isSwitch
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        width: 18.0,
                        decoration: BoxDecoration(
                          color: isSwitch ? Colors.pink : Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageBox(
      bool isMe, bool isRecalled, BuildContext context, ChatModel chat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: isMe ? Colors.grey.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? 16.0 : 2.0),
          topRight: Radius.circular(isMe ? 2.0 : 16.0),
          bottomLeft: const Radius.circular(16.0),
          bottomRight: const Radius.circular(16.0),
        ),
      ),
      // width: MediaQuery.of(context).size.width * 0.8,

      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
      child: Text(
        (chat.isRecall ?? false)
            ? 'Bạn đã thu hồi tin nhắn'
            : chat.message ?? '-.-',
        style: TextStyle(
          color: isMe
              ? !isSwitch
                  ? isRecalled
                      ? Colors.grey
                      : Colors.orange
                  : Colors.red
              : Colors.grey,
          fontSize: 14.0,
        ),
      ),
    );
  }

  void _scrollScreen() {
    scollController.animateTo(
      scollController.position.maxScrollExtent + 80.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
