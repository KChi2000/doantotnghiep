import 'dart:async';
import 'dart:developer';

import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/bloc/getUserGroup/get_user_group_cubit.dart';
import 'package:doantotnghiep/bloc/onHaveRemoteRender/on_have_remote_render_cubit.dart';
import 'package:doantotnghiep/bloc/toggleCM/toggle_cm_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/User.dart';
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
import '../../components/navigate.dart';
import '../DisplayPage.dart';

class CallVideo extends StatefulWidget {
  CallVideo({required this.groupid, required this.grname, this.answere});
  String groupid;
  String grname;
  bool? answere;
  @override
  State<CallVideo> createState() => _CallVideoState();
}

class _CallVideoState extends State<CallVideo> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  int time = 0;
  TextEditingController textEditingController = TextEditingController(text: '');
  Timer? timer;
  bool isFrontCameraSelected = true;
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

  stopTime() {
    timer!.cancel();
  }

  onAddRemote() {
    signaling.onAddRemoteStream = ((stream) {
      context.read<OnHaveRemoteRenderCubit>().haveRemote(true);
      _remoteRenderer.srcObject = stream;
      timer!.cancel();
      setState(() {});
    });
  }

  createRoom() {
    if (widget.answere == false) {
      signaling.createRoom(_remoteRenderer, widget.groupid, 'video');
    }
  }

  initValue() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await signaling.openUserMedia(
        _localRenderer,
        _remoteRenderer,
        context.read<ToggleCmCubit>().state.openCamera,
        context.read<ToggleCmCubit>().state.enableMic,
        isFrontCameraSelected);
    setState(() {});
    if (widget.answere!) {
      print(
          'VS Local Render: ${_localRenderer}  Remote Render: ${_remoteRenderer}');
      signaling.joinRoom(widget.groupid, _remoteRenderer, 'video');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      // shrinkWrap: true,
                      // crossAxisCount: 1,
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
                                ? Container(
                                    // color: Colors.amber,
                                    width: screenwidth,
                                    height: screenheight / 2 - 10,
                                    child: Stack(
                                      children: [
                                        RTCVideoView(
                                          _remoteRenderer,
                                          mirror: true,
                                          objectFit: RTCVideoViewObjectFit
                                              .RTCVideoViewObjectFitCover,
                                        ),
                                        // Positioned(
                                        //   top: 0,
                                        //   left: 0,
                                        //   child: Text(
                                        //     '${_remoteRenderer.muted}',
                                        //     style:
                                        //         TextStyle(color: Colors.pink),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  )
                                : SizedBox();
                          },
                        ),
                        Flexible(
                          child: RTCVideoView(
                            _localRenderer,
                            mirror: true,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
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
                                  state.openCamera
                                      ? Icons.videocam
                                      : Icons.videocam_off,
                                  color: Colors.black,
                                ), () async {
                              await context
                                  .read<ToggleCmCubit>()
                                  .toggleCamera();
                              signaling.toggleCamera(state.openCamera);
                            }, Colors.white),
                            SizedBox(
                              width: 30,
                            ),
                            itemcall(
                                Icon(
                                  state.enableMic ? Icons.mic : Icons.mic_off,
                                  color: Colors.black,
                                ), () async {
                              await context.read<ToggleCmCubit>().toggleMic();
                              signaling.toggleMic(state.enableMic);
                            }, Colors.white),
                            SizedBox(
                              width: 30,
                            ),
                            itemcall(
                                SvgPicture.asset(
                                    'assets/icons/camera-flip.svg'), () async {
                              await context
                                  .read<ToggleCmCubit>()
                                  .switchCamera();
                              signaling.switchCamera(state.useFrontCamera);
                            }, Colors.white),
                            SizedBox(
                              width: 30,
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
                                                var data1 = await signaling
                                                    .peerConnection!
                                                    .getLocalDescription();
                                                if (context
                                                    .read<
                                                        OnHaveRemoteRenderCubit>()
                                                    .state
                                                    .addRemote) {
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
                                                        'video');
                                                  } else {
                                                    await signaling
                                                        .calleeHangup(
                                                            widget.groupid,
                                                            'video');
                                                  }
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
                  // BlocListener<GroupInfoCubitCubit, GroupInfoCubitState>(
                  //   listener: (context, state) {
                  //     if (state is GroupInfoCubitLoaded) {
                  //       var afterFilter = state.groupinfo!
                  //           .where(
                  //               (element) => element.groupId == widget.groupid)
                  //           .first;
                  //       print('AFTER ${afterFilter.offer!.id} ${afterFilter.offer!.id != null}');
                  //       if (afterFilter.offer!.id != null
                  //          ) {
                  //         if (afterFilter.callStatus == 'call end' && afterFilter.offer!.id != Userinfo.userSingleton.uid) {
                  //           Navigator.pop(context);
                  //           Fluttertoast.showToast(
                  //               msg: "Kết thúc cuộc gọi",
                  //               toastLength: Toast.LENGTH_SHORT,
                  //               gravity: ToastGravity.BOTTOM,
                  //               timeInSecForIosWeb: 1,
                  //               textColor: Colors.white,
                  //               backgroundColor: Colors.pink,
                  //               fontSize: 16.0);
                  //         }
                  //       }
                  //     }
                  //   },
                  //   child: SizedBox(),
                  // ),
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
