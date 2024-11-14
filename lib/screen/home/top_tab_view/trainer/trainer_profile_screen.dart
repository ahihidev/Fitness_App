import 'package:flutter/material.dart';
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/common_widget/round_button.dart';
import 'package:specialized_project_2/common_widget/title_subtitle_button.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/trainer/message_detail.dart';

class TrainerProfileScreen extends StatefulWidget {
  final bool isTrainer;
  const TrainerProfileScreen({super.key, this.isTrainer = true});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 18,
              height: 18,
            )),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // Phần thông tin của Trainer
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/img/t_profile.png",
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ashish Chutake",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Specialization in Fitness",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: RoundButton(
                              title: "Follow",
                              height: 35,
                              radius: 10,
                              isPadding: false,
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: RoundButton(
                              title: "Contact",
                              height: 35,
                              radius: 10,
                              isPadding: false,
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/img/location.png",
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Viet Nam",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Thông tin thêm của Trainer
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                _buildInfoColumn("4/5", "Ratings"),
                _buildDivider(),
                _buildInfoColumn("78", "Following"),
                _buildDivider(),
                _buildInfoColumn("5667", "Follower"),
              ],
            ),
          ),
          // Các nút mạng xã hội
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildSocialIcons(),
            ),
          ),
          Divider(color: TColor.board, height: 1),
          // Các thông tin về Certification, Awards, etc.
          TitleSubtitleButton(
              title: "Certifications",
              subtitle: "Advance Trainer Certification ISSA",
              onPressed: () {}),
          TitleSubtitleButton(
              title: "Awards",
              subtitle: "Best in Muscle Building",
              onPressed: () {}),
          TitleSubtitleButton(
              title: "Publish Articles",
              subtitle: "Why Breathing is necessary while Gyming",
              onPressed: () {}),
          TitleSubtitleButton(
              title: "Conferences and Expos Attended",
              subtitle: "ISSA 2019",
              onPressed: () {}),
          TitleSubtitleButton(
              title: widget.isTrainer
                  ? "Personal Training Client and Feedback"
                  : "Feedback",
              subtitle: "Strict, Calm in Nature",
              onPressed: () {}),
          // Nút Chat with Trainer
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RoundButton(
              title: "Chat with Trainer",
              height: 50,
              radius: 12,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageDetails(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo Column hiển thị thông tin ratings, following, followers
  Widget _buildInfoColumn(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo Divider giữa các phần thông tin
  Widget _buildDivider() {
    return Container(
      width: 2,
      height: 45,
      color: TColor.board,
    );
  }

  // Hàm tạo các Icon cho các mạng xã hội
  List<Widget> _buildSocialIcons() {
    return [
      "color_fb.png",
      "tw.png",
      "in.png",
      "yt.png",
    ].map((img) {
      return InkWell(
        onTap: () {},
        child: Image.asset(
          "assets/img/$img",
          width: 25,
          height: 25,
        ),
      );
    }).toList();
  }
}
