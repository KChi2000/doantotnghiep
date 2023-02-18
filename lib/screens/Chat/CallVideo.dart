import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
      setState(() {});
    });

    super.initState();
   
    // setState(() {});
    //  context.read<MakeAVideoCallCubit>().addRemoteStream();
  }

  initValue() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    signaling.openUserMedia(_localRenderer, _remoteRenderer);
    await signaling.createRoom(_remoteRenderer, widget.groupid);
    //  setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Video Calling'),
        // ),
        body: 
        // BlocBuilder<MakeAVideoCallCubit, MakeAVideoCallState>(
        //   builder: (context, state) {
        //     if (state is MakeAVideoCallLoaded) {
        //     return 
            LoaderOverlay(
              useDefaultLoading: false,
              overlayWidget: Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  itemImage('A'),
                  Text("Abcs",style: TextStyle(color: Colors.white,fontSize: 22),),
                  Text("đang gọi...",style: TextStyle(color: Colors.black)),
                ],
              )),
              overlayColor: Colors.grey,
              child: Container(
                  width: screenwidth,
                  height: screenheight,
                  color: Colors.black,
                  child: 
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      Column(
                        // shrinkWrap: true,
                        // crossAxisCount: 1,
                        children: [
                          Container(
                            // color: Colors.amber,
                            width: screenwidth,
                            height: screenheight/2-10,
                            // child: RTCVideoView(
                            //  _remoteRenderer,
                            //   mirror: true,
                            //   objectFit:
                            //       RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                            // ),
                          ),
                            Flexible(
                            child: Container()
                            // RTCVideoView(
                            //  _localRenderer,
                            //   mirror: true,
                            //   objectFit:
                            //       RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                            // ),
                          ),
                          
                        
                          
                        ],
                      ),
                      // Positioned(
                      //   top: 0,
                      //   left: 0,
                      //   child: IconButton(
                      //       onPressed: () {
                      //         Navigator.pop(context);
                      //       },
                      //       icon: Icon(
                      //         Icons.arrow_back,
                      //         color: Colors.white,
                      //         size: 28,
                      //       )),
                      // ),
                      Positioned(
                        bottom: 20.0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //  itemcall(
                            //     'assets/icons/camera-flip.svg', () async {
                            //        context.loaderOverlay.show();
                            //       // signaling.joinRoom(widget.groupid, _remoteRenderer);
                            //   // context.read<MakeAVideoCallCubit>().joinVideoCall(widget.groupid);
                            // }, Colors.white),
                            // SizedBox(
                            //   width: 30,
                            // ),
                            itemcall(
                               'assets/icons/phone-hangup.svg', () async {
                              await signaling.hangUp(
                                  _localRenderer, widget.groupid);
                              Navigator.pop(context);
                            }, Colors.red[900]!),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            )
        //     }
        //     return Container(
        //       width: screenwidth,
        //       height: screenheight,
        //       color: Colors.white,
        //       child: Center(
        //         child: Text('Dang thiet lap....'),
        //       ),
        //     );
        //   },
        // ),
      ),
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
  Widget itemcall(String icon, VoidCallback ontap, Color color) {
    return InkWell(
      // splashColor: Colors.yellow,
      // highlightColor: Colors.yellowAccent,
      onTap: ontap,
      child: CircleAvatar(backgroundColor: color, radius: 30, child: SvgPicture.asset('$icon')),
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
