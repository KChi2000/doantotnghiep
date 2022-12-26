import 'package:doantotnghiep/screens/Profile.dart';
import 'package:doantotnghiep/screens/Tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/Changetab/changetab_cubit.dart';

class DisplayPage extends StatelessWidget {
  DisplayPage({super.key});
  List<Widget> listPage = [Tracking(), Profile()];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangetabCubit, ChangetabState>(
      builder: (context, state) {
        return Scaffold(
            body: listPage.elementAt(state.index),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 0.05
            ),
          ],
        ),
              child: BottomNavigationBar(
                elevation: 10,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map_outlined),
                    label: 'Map',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                    backgroundColor: Colors.green,
                  ),
                ],
                currentIndex: state.index,
                // selectedItemColor: Colors.amber[800],
                onTap: (value) {
                  context.read<ChangetabCubit>().change(value);
                },
              ),
            ));
      },
    );
  }
}
