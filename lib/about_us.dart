import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';
class AboutUsPage extends StatefulWidget {
  AboutUsPage();
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int bloodNeedsCounter = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to update the counter every two seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        bloodNeedsCounter++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rakt'),
        backgroundColor: Colors.deepPurple[100],
        actions: [
          GestureDetector(
            onTap: () async {
              final call = Uri.parse('tel:4086404309');
              if (await canLaunchUrl(call)) {
                launchUrl(call);
              } else {
                throw 'Could not launch $call';
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 4), // Add spacing between icon and text
                  Text('Contact Us'),
                ],
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSlideshow(), // Add the image slideshow here
            SizedBox(height: 20),
            _buildBloodNeedsSection(),
            SizedBox(height: 20),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideshow() {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 12 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 400),
          viewportFraction: 1.0,
        ),
        items: [
          'assets/Pic1.jpg',
          'assets/Pic2.jpg',
          'assets/Pic3.jpg',
        ].map((assetPath) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }


  Widget _buildBloodNeedsSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 20),
      color: Color(0xFFAA90EC), // Lavender color for card background
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Give Blood, Give Life',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD2EC90), // Dark purple color for section titles
              ),
            ),
            SizedBox(height: 10),
            Text(
              'About every two seconds, someone in the U.S. needs blood.\nThat means, this many people have needed blood since you arrived here:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '$bloodNeedsCounter',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple[700]), // Dark purple color for counter
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to Login Page
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: Text('Login/Register'),
      ),
    );
  }
}
