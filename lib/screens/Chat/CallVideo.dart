import 'dart:async';
import 'dart:developer';

import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/bloc/countToBuild/count_to_build_cubit.dart';
import 'package:doantotnghiep/bloc/getUserGroup/get_user_group_cubit.dart';
import 'package:doantotnghiep/bloc/onHaveRemoteRender/on_have_remote_render_cubit.dart';
import 'package:doantotnghiep/bloc/toggleCM/toggle_cm_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/main.dart';
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
    context.read<CountToBuildCubit>().init();
    super.initState();
  }

  setTime() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      time += 1;
     if(mounted){
       if (time == 30 &&
          context.read<OnHaveRemoteRenderCubit>().state.addRemote == false) {
        timer.cancel();
        await signaling.hangUp(_localRenderer, widget.groupid, 'video');
        // Navigator.pop(context);
      }
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
                                          return SizedBox();
                                        } else {
                                          return Container(
                                            width: screenwidth,
                                            height: screenheight / 2 - 10,
                                            color: Colors.grey,
                                            child: Stack(
                                              children: [
                                                Userinfo.userSingleton.uid ==
                                                        afterFilter.offer!.id
                                                    ? afterFilter.answer!
                                                            .cameraStatus!
                                                        ? RTCVideoView(
                                                            _remoteRenderer,
                                                            mirror: true,
                                                            objectFit:
                                                                RTCVideoViewObjectFit
                                                                    .RTCVideoViewObjectFitCover,
                                                          )
                                                        : Center(
                                                            child: CircleAvatar(
                                                                radius: 70,
                                                                backgroundImage:
                                                                    Image.network(afterFilter
                                                                            .answer!
                                                                            .profile!)
                                                                        .image),
                                                          )
                                                    : afterFilter.offer!
                                                            .cameraStatus!
                                                        ? RTCVideoView(
                                                            _remoteRenderer,
                                                            mirror: true,
                                                            objectFit:
                                                                RTCVideoViewObjectFit
                                                                    .RTCVideoViewObjectFitCover,
                                                          )
                                                        : Center(
                                                            child: CircleAvatar(
                                                                radius: 70,
                                                                backgroundImage:
                                                                    Image.network(afterFilter
                                                                            .offer!
                                                                            .profile!)
                                                                        .image),
                                                          ),
                                                Positioned(
                                                    right: 0,
                                                    child: Container(
                                                        color: Colors.pink,
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                top: 3,
                                                                bottom: 3,
                                                                left: 10),
                                                        child: Text(
                                                          afterFilter.offer!
                                                                      .id ==
                                                                  Userinfo
                                                                      .userSingleton
                                                                      .uid
                                                              ? '${afterFilter.answer!.name}'
                                                              : '${afterFilter.offer!.name}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )))
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      return SizedBox();
                                    },
                                  )
                                : SizedBox();
                          },
                        ),
                      Container(width: screenwidth,height: 1,color: Colors.black,),
                        BlocBuilder<ToggleCmCubit, ToggleCmState>(
                          builder: (context, state) {
                            return Flexible(
                              child: Container(
                                color: Colors.grey,
                                child: Stack(
                                  children: [
                                    signaling.localStream != null
                                        ? state.openCamera
                                            ? RTCVideoView(
                                                _localRenderer,
                                                mirror: true,
                                                objectFit: RTCVideoViewObjectFit
                                                    .RTCVideoViewObjectFitCover,
                                              )
                                            : Center(
                                                child: CircleAvatar(
                                                    radius: 70,
                                                    backgroundImage:
                                                        Image.network(Userinfo
                                                                .userSingleton
                                                                .profilePic!)
                                                            .image),
                                              )
                                        : Center(
                                            child: CircleAvatar(
                                                radius: 50,
                                                backgroundImage: Image.network(
                                                        Userinfo.userSingleton
                                                            .profilePic!)
                                                    .image),
                                          ),
                                    BlocBuilder<OnHaveRemoteRenderCubit,
                                        OnHaveRemoteRenderState>(
                                      builder: (context, state) {
                                        if (state.addRemote) {
                                          return BlocBuilder<
                                              GroupInfoCubitCubit,
                                              GroupInfoCubitState>(
                                            builder: (context, state) {
                                              if (state
                                                  is GroupInfoCubitLoaded) {
                                                var afterFilter = state
                                                    .groupinfo!
                                                    .where((element) =>
                                                        element.groupId ==
                                                        widget.groupid)
                                                    .first;
                                                if (afterFilter.answer!.id ==
                                                        null ||
                                                    afterFilter.answer!.id
                                                        .toString()
                                                        .isEmpty) {
                                                  return SizedBox();
                                                }
                                                return Positioned(
                                                    right: 0,
                                                    child: Container(
                                                        color: Colors.pink,
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                top: 3,
                                                                bottom: 3,
                                                                left: 10),
                                                        child: Text(
                                                          'Bạn',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )));
                                              }
                                              return SizedBox();
                                            },
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
                            }
                            return 
                            BlocConsumer<GroupInfoCubitCubit,
                                GroupInfoCubitState>(
                                  
                              listener: (context, state) async {
                              
                                if (state is GroupInfoCubitLoaded) {
                                 
                                  var afterFilter = state.groupinfo!
                                      .where((element) =>
                                          element.groupId == widget.groupid)
                                      .first;

                                  if (afterFilter.callStatus == 'call end') {
                                  
                                   if( context.read<CountToBuildCubit>().state ==0){
                                    Navigator.of(navigatorKey.currentState!.context).pop();
                                   }
                                    context.read<CountToBuildCubit>().add();
                                  }
                                }
                              },
                              builder: (context, state) {
                                if (state is GroupInfoCubitLoaded) {
                                  var afterFilter = state.groupinfo!
                                      .where((element) =>
                                          element.groupId == widget.groupid)
                                      .first;
                                  return Positioned(
                                    bottom: 20.0,
                                    left: 0,
                                    right: 0,
                                    child: BlocConsumer<ToggleCmCubit,
                                        ToggleCmState>(
                                      listener: (context, state) {},
                                      builder: (context, toggleCM) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            itemcall(
                                                Icon(
                                                  toggleCM.openCamera
                                                      ? Icons.videocam
                                                      : Icons.videocam_off,
                                                  color: Colors.black,
                                                ), () async {
                                              await context
                                                  .read<ToggleCmCubit>()
                                                  .toggleCamera();
                                              signaling.toggleCamera(
                                                  toggleCM.openCamera,
                                                  widget.groupid,
                                                  (afterFilter.offer!.id ==
                                                          Userinfo
                                                              .userSingleton.uid
                                                      ? afterFilter.offer
                                                      : afterFilter.answer)!);
                                            }, Colors.white),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            itemcall(
                                                Icon(
                                                  toggleCM.enableMic
                                                      ? Icons.mic
                                                      : Icons.mic_off,
                                                  color: Colors.black,
                                                ), () async {
                                              await context
                                                  .read<ToggleCmCubit>()
                                                  .toggleMic();
                                              signaling.toggleMic(
                                                  toggleCM.enableMic);
                                            }, Colors.white),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            itemcall(
                                                SvgPicture.asset(
                                                    'assets/icons/camera-flip.svg'),
                                                () async {
                                              await context
                                                  .read<ToggleCmCubit>()
                                                  .switchCamera();
                                              signaling.switchCamera(
                                                  toggleCM.useFrontCamera);
                                            }, Colors.white),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            itemcall(
                                                SvgPicture.asset(
                                                  'assets/icons/phone-hangup.svg',
                                                  color: Colors.white,
                                                ), () async {
                                              stopTime();
                                              await FlutterCallkitIncoming
                                                  .endCall(
                                                      'video${widget.groupid}');
                                              if (afterFilter.offer!.id ==
                                                  Userinfo.userSingleton.uid) {
                                                await signaling.hangUp(
                                                    _localRenderer,
                                                    widget.groupid,
                                                    'video');
                                              } else {
                                                   Navigator.pop(context);
                                                await signaling.calleeHangup(
                                                    widget.groupid, 'video');
                                                    
                                              }

                                            
                                            }, Colors.red[900]!),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            );
                          });
                    },
                  ),
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
