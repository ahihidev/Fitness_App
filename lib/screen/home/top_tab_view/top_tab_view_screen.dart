import 'package:flutter/material.dart';
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/common_widget/top_tab_button.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/exercises/exercises_tab_screen.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/health_tip/health_tip_screen.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/trainer/trainer_tab_screen.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/workout_plan/workout_plan_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class TopTabViewScreen extends StatefulWidget {
  const TopTabViewScreen({super.key});

  @override
  State<TopTabViewScreen> createState() => _TopTabViewScreenState();
}

class _TopTabViewScreenState extends State<TopTabViewScreen> with SingleTickerProviderStateMixin {
  var tapArr = [
    "Health Tips",
    "Exercises",
    "Workout Plan",
    "Trainers"
  ];

  int selectTab = 0;
  TabController? controller;

  late final StreamChatClient _client;

  @override
  void initState() {
    super.initState();

    // Initialize StreamChatClient
    _client = StreamChatClient(
      'b67pax5b2wdq',
      logLevel: Level.INFO,
    );

    _client.connectUser(
      User(id: 'tutorial-flutter'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c',
    );

    controller = TabController(length: 5, vsync: this); // Update length to 5 to include Trainer Tab
    controller?.addListener(() {
      setState(() {
        selectTab = controller?.index.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: false,
        leading: Container(),
        leadingWidth: 20,
        title: const Text(
          "Gymify",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Top Tab Bar
          Container(
            margin: const EdgeInsets.only(top: 0.5),
            color: TColor.secondary,
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: tapArr.map((name) {
                    var index = tapArr.indexOf(name);

                    return TopTabButton(
                      title: name,
                      isSelect: selectTab == index,
                      onPressed: () {
                        setState(() {
                          selectTab = index;
                          controller?.animateTo(index);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Tab View
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                const HealthTipScreen(),
                const ExercisesScreen(),
                const WorkoutPlanScreen(),
                TrainerTabScreen(), // Pass the client to TrainerTabScreen
              ],
            ),
          ),
        ],
      ),
    );
  }
}
