import 'package:donor_community/about_us.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'login_page.dart';
import 'request_form.dart';

class LoggedInPage extends StatefulWidget {
  LoggedInPage({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  final User? user = Auth().currentUser;
  final List<Responder> responders = [
    Responder(name: 'Qweey099', patientName: 'John Doe', location: '30 N Rivercount'),
    // Add more responders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rakt', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.deepPurple[100],
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Auth().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRespondersSection(context),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Past Requests',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _buildRequestDetailsCard(context),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRequestDetailsCard(BuildContext context) {
    String patientName = 'Ron Miller';
    String patientId = '123456';
    String institutionName = 'Santa Clara County Hospital';
    String address = '50 Washington St., Santa Clara';

    return Card(
      margin: EdgeInsets.all(20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Text('Patient Name: $patientName', style: Theme.of(context).textTheme.subtitle1),
            Text('Patient ID: $patientId', style: Theme.of(context).textTheme.subtitle1),
            Text('Inst. Name: $institutionName', style: Theme.of(context).textTheme.subtitle1),
            Text('Address: $address', style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget _buildRespondersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Active Requests',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: responders.length,
          itemBuilder: (context, index) {
            return _responderCard(responders[index], context);
          },
        ),
      ],
    );
  }

  Widget _responderCard(Responder responder, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient ID: ${responder.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Patient Name: ${responder.patientName}',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  'Location: ${responder.location}',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: responder.status == 'none'
                ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      responder.status = 'accepted';
                    });
                  },
                  child: Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      responder.status = 'declined';
                    });
                  },
                  child: Text('Decline'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            )
                : Text(
              responder.status == 'accepted'
                  ? 'Thank you for accepting!'
                  : 'Thank you, we will contact you later.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: responder.status == 'accepted' ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Responder {
  final String name;
  final String patientName;
  final String location;
  String status;

  Responder({
    required this.name,
    required this.patientName,
    required this.location,
    this.status = 'none',
  });
}