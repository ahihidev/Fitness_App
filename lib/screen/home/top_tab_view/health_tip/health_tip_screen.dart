import 'package:flutter/material.dart';
import 'package:specialized_project_2/common/color_extension.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/health_tip/health_tip_details_screen.dart';
import 'package:specialized_project_2/screen/home/top_tab_view/health_tip/health_tip_row.dart';

class HealthTipScreen extends StatefulWidget {
  const HealthTipScreen({super.key});

  @override
  State<HealthTipScreen> createState() => _HealthTipScreenState();
}

class _HealthTipScreenState extends State<HealthTipScreen> {
  List listArr = [
    {
      "title": "A Diet Without Exercise is Useless.",
      "subtitle":
      "Interval training is a form of exercise in which you alternate between two or more different types of exercises. This method includes short bursts of high-intensity activity followed by a rest period, which helps improve cardiovascular health, burn fat, and increase stamina. It's a great option for those looking to get fit quickly in a time-efficient manner.",
      "image": "assets/img/home_1.jpg",
    },
    {
      "title": "Garlic As fresh and Sweet as baby's Breath.",
      "subtitle":
      "Garlic is a powerful plant in the onion family, packed with numerous health benefits. It's been used for centuries for its medicinal properties, including its ability to lower blood pressure, reduce cholesterol levels, and fight off infections. Eating fresh garlic can help boost your immune system and improve heart health, making it a great addition to your daily diet.",
      "image": "assets/img/home_2.png",
    },
    {
      "title": "Stay Hydrated Throughout the Day",
      "subtitle":
      "Drinking enough water is crucial to maintaining your body's natural balance and supporting overall health. Staying hydrated helps with digestion, nutrient absorption, and detoxification, and is essential for maintaining energy levels throughout the day. It also helps with skin health, reducing the appearance of wrinkles and dryness. Aim for 8 glasses of water per day to stay energized and focused.",
      "image": "assets/img/home_3.jpg",
    },
    {
      "title": "Prioritize Sleep for Better Health",
      "subtitle":
      "Getting quality sleep is one of the most important things you can do for your physical and mental health. Sleep helps the body recover, regenerate cells, and maintain a healthy immune system. Adequate sleep improves mood, focus, and memory, and reduces stress levels. Aim for 7-8 hours of restful sleep each night to feel more refreshed and energized.",
      "image": "assets/img/home_4.jpg",
    },
    {
      "title": "Add More Greens to Your Diet",
      "subtitle":
      "Leafy greens like spinach, kale, and Swiss chard are nutrient-dense foods that provide a variety of vitamins, minerals, and antioxidants. These greens support immune health, improve digestion, and help regulate blood sugar levels. Adding them to your meals can boost your energy levels, support weight management, and provide your body with the essential nutrients it needs for optimal function.",
      "image": "assets/img/home_5.jpg",
    },
    {
      "title": "Take Regular Breaks from Sitting",
      "subtitle":
      "Sitting for prolonged periods can lead to several health issues, including poor posture, reduced circulation, and an increased risk of chronic diseases like heart disease and diabetes. To combat this, it’s essential to take regular breaks from sitting. Stand up, stretch, and walk around every hour to improve blood flow and keep your body moving. Incorporating movement into your day helps increase productivity and overall well-being.",
      "image": "assets/img/home_6.jpg",
    },
    {
      "title": "Plan Balanced Meals",
      "subtitle":
      "A balanced meal includes a healthy mix of protein, carbohydrates, and healthy fats to provide your body with sustained energy. Including a variety of vegetables, whole grains, lean proteins, and healthy fats in each meal helps promote overall health, stabilize blood sugar levels, and reduce cravings. By planning balanced meals, you can ensure you're nourishing your body and maintaining a healthy weight over time.",
      "image": "assets/img/home_7.jpg",
    }
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemBuilder: (context, index) {
            var obj = listArr[index] as Map? ?? {};
            return HealthTipRow(
              obj: obj,
              onPressed: () {
                // Truyền thông tin sang màn hình chi tiết
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthTipDetailScreen(
                      title: obj['title']!,
                      subtitle: obj['subtitle']!,
                      image: obj['image']!,
                    ),
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 20,
          ),
          itemCount: listArr.length),
    );
  }
}
