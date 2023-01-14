import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Signaling.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallVideo extends StatefulWidget {
  CallVideo({required this.groupid});
  String groupid;
  @override
  State<CallVideo> createState() => _CallVideoState();
}

class _CallVideoState extends State<CallVideo> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    initValue();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
     setState(() {
       
     });
    });

    super.initState();
 setState(() {});
    //  context.read<MakeAVideoCallCubit>().addRemoteStream();
  }

  initValue() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    signaling.openUserMedia(_localRenderer, _remoteRenderer);
    //  setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Video Calling'),
        // ),
        body: BlocBuilder<MakeAVideoCallCubit, MakeAVideoCallState>(
          builder: (context, state) {
            // if (state is MakeAVideoCallLoaded) {
            return Container(
                width: screenwidth,
                height: screenheight,
                // color: Colors.pink,
                child: Stack(
                  children: [
                    GridView.count(
                      crossAxisCount: 1,
                      children: [
                        RTCVideoView(
                          _localRenderer,
                          mirror: true,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                        RTCVideoView(
                          _remoteRenderer,
                          mirror: true,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                        SizedBox(
                          width: screenwidth,
                          child: TextFormField(
                            controller: textEditingController,
                          ),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        )),
                    Positioned(
                      bottom: 20.0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.amber),
                              onPressed: () async {
                                roomId =
                                    await signaling.createRoom(_remoteRenderer);
                                textEditingController.text = roomId!;
                                setState(() {});
                                // context.read<MakeAVideoCallCubit>().joinVideoCall(widget.groupid);
                              },
                              child: Text('offer')),
                          SizedBox(
                            width: 30,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.amber),
                              onPressed: () {
                                signaling.joinRoom(
                                  "CURRENT", // textEditingController.text,
                                  _remoteRenderer,
                                );
                                // context.read<MakeAVideoCallCubit>().joinVideoCall(widget.groupid);
                              },
                              child: Text('answer')),
                               SizedBox(
                            width: 30,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.amber),
                              onPressed: () {
                                  signaling.hangUp(_localRenderer);
                                // context.read<MakeAVideoCallCubit>().joinVideoCall(widget.groupid);
                              },
                              child: Text('hang up')),
                          // itemcall(
                          //     Icon(
                          //       Icons.flip_camera_ios_outlined,
                          //       color: Colors.white,
                          //     ),
                          //     () {}),
                          // SizedBox(
                          //   width: 15,
                          // ),
                          // itemcall(
                          //     Icon(
                          //       Icons.phone_enabled,
                          //       color: Colors.white,
                          //     ),
                          //     () {}),
                          // SizedBox(
                          //   width: 15,
                          // ),
                        ],
                      ),
                    )
                  ],
                ));
            // }
            // return Container(
            //   width: screenwidth,
            //   height: screenheight,
            //   color: Colors.white,
            //   child: Center(
            //     child: Text('Dang thiet lap....'),
            //   ),
            // );
          },
        ),
       
      ),
    );
  }

  Positioned itemcall(Icon icon, VoidCallback ontap) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: InkWell(
        // splashColor: Colors.yellow,
        // highlightColor: Colors.yellowAccent,
        onTap: ontap,
        child: CircleAvatar(
            // backgroundColor: Colors.transparent,
            radius: 30,
            child: icon),
      ),
    );
  }

  @override
  void dispose() {
    print('disposeeeeeee');
    // context.read<MakeAVideoCallCubit>().disposevideocall();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }
}
