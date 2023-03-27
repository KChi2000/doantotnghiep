import 'dart:async';
import 'dart:ui';

import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/bloc/onHaveRemoteRender/on_have_remote_render_cubit.dart';
import 'package:doantotnghiep/bloc/toggleCM/toggle_cm_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../bloc/Changetab/changetab_cubit.dart';
import '../../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../../bloc/getUserGroup/get_user_group_cubit.dart';
import '../../components/navigate.dart';
import '../../model/User.dart';
import '../DisplayPage.dart';

class CallAudio extends StatefulWidget {
  CallAudio({required this.groupid, required this.grname, this.answere});
  String groupid;
  String grname;
  bool? answere;
  @override
  State<CallAudio> createState() => _CallAudioState();
}

class _CallAudioState extends State<CallAudio> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  // bool isAudioOn = true, isVideoOn = true,
  bool isFrontCameraSelected = true;
  int time = 0;
  Timer? timer;
  @override
  void initState() {
    context.read<OnHaveRemoteRenderCubit>().haveRemote(widget.answere!);
    setTime();
    createRoom();
    initValue();
    onAddRemote();
    super.initState();
  }

  setTime() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      time += 1;
      if (time == 30 &&
          context.read<OnHaveRemoteRenderCubit>().state.addRemote == false) {
        timer.cancel();
        await signaling.hangUp(_localRenderer, widget.groupid, 'video');
        Navigator.pop(context);
      }
    });
  }

  onAddRemote() {
    signaling.onAddRemoteStream = ((stream) {
      print('Vao on add remote stream');
      context.read<OnHaveRemoteRenderCubit>().haveRemote(true);
      _remoteRenderer.srcObject = stream;
      timer!.cancel();
      setState(() {});
    });
  }

  stopTime() {
    timer!.cancel();
  }

  createRoom() {
    signaling.createRoom(_remoteRenderer, widget.groupid, 'audio');
  }

  initValue() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await signaling.openUserMedia(_localRenderer, _remoteRenderer, false,
        context.read<ToggleCmCubit>().state.enableMic, isFrontCameraSelected);
    setState(() {});
    if (widget.answere! == true) {
      await context.read<OnHaveRemoteRenderCubit>().haveRemote(true);
      signaling.joinRoom(widget.groupid, _remoteRenderer, 'audio');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext ct) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              width: screenwidth,
              height: screenheight,
              color: Colors.black,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LoaderOverlay(
                    useDefaultLoading: false,
                    overlayOpacity: 0.1,
                    overlayWidget: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.pink,
                          child: Text(
                            '${widget.grname.substring(0, 1)}',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Text(
                          widget.grname,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'robotomedium'),
                        ),
                        Text(
                          'Đang gọi...',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<OnHaveRemoteRenderCubit,
                            OnHaveRemoteRenderState>(
                          builder: (context, state) {
                            if (!state.addRemote) {
                              context.loaderOverlay.show();
                            } else {
                              context.loaderOverlay.hide();
                            }
                            return state.addRemote
                                ? BlocBuilder<GroupInfoCubitCubit,
                                    GroupInfoCubitState>(
                                    builder: (context, state) {
                                      if (state is GroupInfoCubitLoaded) {
                                        var afterFilter = state.groupinfo!
                                            .where((element) =>
                                                element.groupId ==
                                                widget.groupid)
                                            .first;
                                        if (afterFilter.answer!.id == null ||
                                            afterFilter.answer!.id
                                                .toString()
                                                .isEmpty) {
                                          return Container(
                                            width: screenwidth,
                                            height: screenheight / 2 - 10,
                                            padding: EdgeInsets.only(
                                                bottom: 100,
                                                right: 40,
                                                left: 40),
                                            color: Colors.black,
                                            child: ClipRect(
                                              child: BackdropFilter(
                                                filter: new ImageFilter.blur(
                                                    sigmaX: 10.0, sigmaY: 10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .grey.shade200
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30))),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CircleAvatar(
                                                          radius: 50,
                                                          backgroundImage: Image
                                                                  .network(Userinfo
                                                                      .userSingleton
                                                                      .profilePic!)
                                                              .image),
                                                      Text(
                                                        'Bạn',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                              width: screenwidth,
                                              height: screenheight / 2 - 10,
                                              color: Colors.black,
                                              padding: EdgeInsets.only(
                                                  top: 60,
                                                  right: 40,
                                                  left: 40,
                                                  bottom: 40),
                                              child: ClipRect(
                                                child: BackdropFilter(
                                                  filter: new ImageFilter.blur(
                                                      sigmaX: 10.0,
                                                      sigmaY: 10.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade200
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30))),
                                                    child: Center(
                                                        child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CircleAvatar(
                                                            radius: 50,
                                                            backgroundImage: afterFilter
                                                                        .offer!
                                                                        .id ==
                                                                    Userinfo
                                                                        .userSingleton
                                                                        .uid
                                                                ? Image.network(afterFilter
                                                                        .answer!
                                                                        .profile!)
                                                                    .image
                                                                : Image.network(
                                                                        afterFilter
                                                                            .offer!
                                                                            .profile!)
                                                                    .image
                                                            // Text(
                                                            //   afterFilter.offer!
                                                            //               .id ==
                                                            //           Userinfo
                                                            //               .userSingleton
                                                            //               .uid
                                                            //       ? '${afterFilter.answer!.name}'
                                                            //       : '${afterFilter.offer!.name}',
                                                            //   style: TextStyle(
                                                            //       color: Colors
                                                            //           .white),
                                                            // ),
                                                            ),
                                                        Text(
                                                          afterFilter.offer!
                                                                      .id ==
                                                                  Userinfo
                                                                      .userSingleton
                                                                      .uid
                                                              ? '${afterFilter.answer!.name}'
                                                              : '${afterFilter.offer!.name}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                ),
                                              ));
                                        }
                                      }
                                      return SizedBox();
                                    },
                                  )
                                : SizedBox();
                          },
                        ),
                        Flexible(
                          child: BlocBuilder<OnHaveRemoteRenderCubit,
                              OnHaveRemoteRenderState>(
                            builder: (context, state) {
                              if (state.addRemote) {
                                return BlocBuilder<GroupInfoCubitCubit,
                                    GroupInfoCubitState>(
                                  builder: (context, state) {
                                    if (state is GroupInfoCubitLoaded) {
                                      var afterFilter = state.groupinfo!
                                          .where((element) =>
                                              element.groupId == widget.groupid)
                                          .first;
                                      if (afterFilter.answer!.id == null ||
                                          afterFilter.answer!.id
                                              .toString()
                                              .isEmpty) {
                                        return SizedBox();
                                      }
                                      return Container(
                                        padding: EdgeInsets.only(
                                            bottom: 100, right: 40, left: 40),
                                        color: Colors.black,
                                        child: ClipRect(
                                          child: BackdropFilter(
                                            filter: new ImageFilter.blur(
                                                sigmaX: 10.0, sigmaY: 10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              child: Center(
                                                  child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage:
                                                          Image.network(Userinfo
                                                                  .userSingleton
                                                                  .profilePic!)
                                                              .image),
                                                  Text(
                                                    'Bạn',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  },
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 0,
                    right: 0,
                    child: BlocConsumer<ToggleCmCubit, ToggleCmState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            itemcall(
                                Icon(
                                  state.enableMic ? Icons.mic : Icons.mic_off,
                                  color: Colors.black,
                                ), () async {
                              await context.read<ToggleCmCubit>().toggleMic();
                              signaling.toggleMic(state.enableMic);
                            }, Colors.white),
                            SizedBox(
                              width: 60,
                            ),
                            BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
                              builder: (context, state) {
                                return StreamBuilder<dynamic>(
                                    stream: state.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        context
                                            .read<GroupInfoCubitCubit>()
                                            .updateGroup(snapshot.data);
                                        return BlocBuilder<GroupInfoCubitCubit,
                                            GroupInfoCubitState>(
                                          builder: (context, state) {
                                            return itemcall(
                                                SvgPicture.asset(
                                                  'assets/icons/phone-hangup.svg',
                                                  color: Colors.white,
                                                ), () async {
                                              stopTime();

                                              if (state
                                                  is GroupInfoCubitLoaded) {
                                                var afterFilter = state
                                                    .groupinfo!
                                                    .where((element) =>
                                                        element.groupId ==
                                                        widget.groupid)
                                                    .first;

                                                if (afterFilter.offer!.id ==
                                                    Userinfo
                                                        .userSingleton.uid) {
                                                  await signaling.hangUp(
                                                      _localRenderer,
                                                      widget.groupid,
                                                      'audio');
                                                } else {
                                                  await signaling.calleeHangup(
                                                      widget.groupid, 'audio');
                                                }
                                              }

                                              Navigator.pop(context);
                                            }, Colors.red[900]!);
                                          },
                                        );
                                      }
                                      return itemcall(
                                          SvgPicture.asset(
                                            'assets/icons/phone-hangup.svg',
                                            color: Colors.white,
                                          ), () async {
                                        stopTime();
                                        await signaling.hangUp(_localRenderer,
                                            widget.groupid, 'video');

                                        Navigator.pop(context);
                                      }, Colors.red[900]!);
                                    });
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocListener<GroupInfoCubitCubit, GroupInfoCubitState>(
                    listener: (context, state) {
                      if (state is GroupInfoCubitLoaded) {
                        state.groupinfo!.forEach((element) async {
                          if (element.groupId.toString() == widget.groupid) {
                            if (element.callStatus == 'call end') {
                              // Navigator.pop(ct);
                              // ct.read<ChangetabCubit>().change(1);
                              // navigateReplacement(ct, DisplayPage());
                              // Fluttertoast.showToast(
                              //     msg: "Kết thúc cuộc gọi",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.BOTTOM,
                              //     timeInSecForIosWeb: 1,
                              //     textColor: Colors.white,
                              //     backgroundColor: Colors.pink,
                              //     fontSize: 16.0);
                            }
                          }
                        });
                      }
                    },
                    child: SizedBox(),
                  )
                ],
              ))),
    );
  }

  Widget itemImage(String name) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).primaryColor),
      child: Center(
          child: Text(
        '${name}',
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  @override
  void dispose() {
    // context.read<MakeAVideoCallCubit>().disposevideocall();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }
}

Widget itemcall(Widget icon, VoidCallback ontap, Color color) {
  return InkWell(
    // splashColor: Colors.yellow,
    // highlightColor: Colors.yellowAccent,
    onTap: ontap,
    child: CircleAvatar(backgroundColor: color, radius: 30, child: icon),
  );
}
