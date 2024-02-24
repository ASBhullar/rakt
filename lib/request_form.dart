import 'package:donor_community/models/patient.dart';
import 'package:donor_community/repository/patient_repository.dart';
import 'package:donor_community/service/find_donors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'active_request.dart'; // Importing ActiveRequestPage

class FormPage extends StatefulWidget {
  const FormPage();

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final patientRepo = Get.put(PatientRepository());
  final TextEditingController _controllerPatientName = TextEditingController();
  final TextEditingController _controllerPatientId = TextEditingController();
  final TextEditingController _controllerInstitutionName =
      TextEditingController();
  final TextEditingController _controllerRequisitionForm =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final notificationService = NotificationService();

  String? lat;
  String? lng;
  String? _selectedBloodGroup;

  String? _filePath; // Track selected file path

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_controllerPatientId.text == null ||
        _controllerPatientId.text.isEmpty) {
      _showErrorDialog("Error", "Patient Id cannot be empty.");
    } else if (lat == null || lat!.isEmpty || lng == null || lng!.isEmpty) {
      _showErrorDialog("Sign Up Error", "Street address cannot be empty");
    } else if (_selectedBloodGroup == null || _selectedBloodGroup!.isEmpty) {
      _showErrorDialog("Sign Up Error", "Blood group cannot be empty");
    } else if (_controllerPatientName.text == null ||
        _controllerPatientName.text.isEmpty) {
      _showErrorDialog("Sign Up Error", "Patient name cannot be empty");
    } else if (_controllerInstitutionName.text == null ||
        _controllerInstitutionName.text.isEmpty) {
      _showErrorDialog("Sign Up Error", "Institution name cannot be empty");
    } else {
      try {
        Patient patient = new Patient(
            patientId: _controllerPatientId.text,
            patientName: _controllerPatientName.text,
            institutionName: _controllerInstitutionName.text,
            address: _addressController.text,
            isActive: true,
            bgroup: _selectedBloodGroup);
        await patientRepo.createPatient(patient);
        await notificationService.findDonors(_selectedBloodGroup, double.tryParse(lat ?? ""), double.tryParse(lng ?? ""), patient);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActiveRequestPage()),
        );
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(
            "Sign Up Error", e.message ?? "An unknown error occurred");
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        _controllerRequisitionForm.text =
            _filePath ?? ''; // Update text field with file path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Form'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(height: 60.0),
                const Text(
                  "Patient Form",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Enter patient details",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                )
              ],
            ),
            Column(
              children: <Widget>[
                TextField(
                  controller: _controllerPatientName,
                  decoration: InputDecoration(
                      hintText: "Patient Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.purple.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person)),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controllerPatientId,
                  decoration: InputDecoration(
                    hintText: "Patient ID",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.grid_3x3_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controllerInstitutionName,
                  decoration: InputDecoration(
                    hintText: "Institution Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.local_hospital),
                  ),
                ),
                const SizedBox(height: 20),
                GooglePlaceAutoCompleteTextField(
                  textEditingController: _addressController,
                  googleAPIKey: "",
                  inputDecoration: InputDecoration(
                    hintText: 'Enter your street address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    lng = prediction.lng;
                    lat = prediction.lat;
                  },
                  itemClick: (Prediction prediction) {
                    _addressController.text = prediction.description ?? "";
                    _addressController.selection = TextSelection.fromPosition(
                        TextPosition(
                            offset: prediction.description?.length ?? 0));
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controllerRequisitionForm,
                  decoration: InputDecoration(
                    hintText: "Requisition Form (Document)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.attach_file),
                  ),
                  readOnly: true, // Disable manual input
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectFile, // Call method to select file
                  child: Text('Upload File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[200],
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Blood Group Required",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.bloodtype),
                  ),
                  value: _selectedBloodGroup,
                  items: [
                    'A+',
                    'A-',
                    'B+',
                    'B-',
                    'AB+',
                    'AB-',
                    'O+',
                    'O-',
                  ].map((bloodGroup) {
                    return DropdownMenuItem<String>(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBloodGroup = newValue;
                    });
                  },
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              child: ElevatedButton(
                onPressed:
                    _submitForm, // Call method to submit form and navigate
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple[200],
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
