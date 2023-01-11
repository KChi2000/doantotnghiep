import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallVideo extends StatefulWidget {
  CallVideo({super.key});

  @override
  State<CallVideo> createState() => _CallVideoState();
}

class _CallVideoState extends State<CallVideo> {
  Singaling signaling = Singaling();

  @override
  void initState() {
    super.initState();

    context.read<MakeAVideoCallCubit>().getusermedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Calling'),
      ),
      body: BlocBuilder<MakeAVideoCallCubit, MakeAVideoCallState>(
        builder: (context, state) {
          if (state is MakeAVideoCallLoaded) {
            return Container(
                width: screenwidth,
                height: screenheight,
                color: Colors.pink,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0.0,
                        right: 0.0,
                        left: 0.0,
                        bottom: 0.0,
                        child: RTCVideoView(
                          state.renderer,
                          mirror: true,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        )),
                    itemcall(
                        Icon(
                          Icons.phone_enabled,
                          color: Colors.white,
                        ),
                        () {}),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.pink,
                    )
                  ],
                ));
          }
          return Container(
            width: screenwidth,
            height: screenheight,
            color: Colors.white,
            child: Center(
              child: Text('Dang thiet lap....'),
            ),
          );
        },
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
    // context.read<MakeAVideoCallCubit>().disposevideocall();
    super.dispose();
  }
}
