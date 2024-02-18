import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResponderCard extends StatelessWidget {
  final String responderName;
  final String contactNumber;

  const ResponderCard({
    required this.responderName,
    required this.contactNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(responderName),
        subtitle: Text(contactNumber),
        trailing: IconButton(
          icon: Icon(Icons.phone),
          onPressed: () => _launchPhoneDialer(contactNumber),
        ),
      ),
    );
  }
  // Method to launch the phone dialer with the contact number
  Future<void> _launchPhoneDialer(String contactNumber) async {
    final String url = 'tel:$contactNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


class ActiveRequestPage extends StatefulWidget {
  const ActiveRequestPage();

  @override
  _ActiveRequestPageState createState() => _ActiveRequestPageState();
}

class _ActiveRequestPageState extends State<ActiveRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Active Requests'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRequestDetailsCard(),
            SizedBox(height: 20),
            _buildRespondersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestDetailsCard() {
    // Replace these values with actual request details from form submission
    String patientName = 'Alex Kirk';
    String patientId = '002233';
    String institutionName = 'San Francisco';
    String address = '2147 Newhall Street, Santa Clara, CA 95050';
    String bloodGroup = 'AB+';

    return Card(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Active Request',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Patient Name: $patientName'),
            Text('Patient ID: $patientId'),
            Text('Institution Name: $institutionName'),
            Text('Address: $address'),
            SizedBox(height: 10),
            Text(
              'Blood Group Requested: $bloodGroup',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         // Handle edit request button tap
            //       },
            //       child: Text('Edit'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         // Handle delete request button tap
            //       },
            //       child: Text('Delete'),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.red,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRespondersSection() {
    // Replace these with actual data of responders
    List<Map<String, String>> responders = [
      {
        'name': 'Amarjot Singh Bhullar',
        'location': '500 El Camino Street',
        'contact': '6693691841'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Responders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: responders.length,
          itemBuilder: (context, index) {
            //String contact = responders[index]['contact'];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${responders[index]['name']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Location: ${responders[index]['location']}'),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () async {
                          final call = Uri.parse('tel:6693691841');
                          if (await canLaunchUrl(call)) {
                            launchUrl(call);
                          } else {
                            throw 'Could not launch $call';
                          }
                        },// Add phone icon
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}