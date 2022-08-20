import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:public_transportation_tracker/login_screen.dart';
import 'package:public_transportation_tracker/model/user_model.dart';
import 'package:public_transportation_tracker/mymap.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
                onPressed: () {
                  _getLocation();
                },
                icon: Icon(Icons.location_history),
                label: Text("Add Location"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
                onPressed: () {
                  _listenLocation();
                },
                icon: Icon(Icons.location_on),
                label: Text("Track Live Location"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
                onPressed: () {
                  _stopListening();
                },
                icon: Icon(Icons.location_off_sharp),
                label: Text("Stop Tracking Location"),
              ),
            ),
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       _getLocation();
          //     },
          //     child: Text('Add My Current Location')),
          // ElevatedButton(
          //     onPressed: () {
          //       _listenLocation();
          //     },
          //     child: Text('Enable Live Location Tracking')),
          // ElevatedButton(
          //     onPressed: () {
          //       _stopListening();
          //     },
          //     child: Text('Stop Live Location Tracking')),
          Expanded(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('location').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Color.fromARGB(186, 255, 119, 7),
                      title: Text(
                        snapshot.data!.docs[index]['name'].toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "Lat: " +
                                snapshot.data!.docs[index]['latitude']
                                    .toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Lon: " +
                                snapshot.data!.docs[index]['longitude']
                                    .toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.directions),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MyMap(snapshot.data!.docs[index].id)));
                        },
                      ),
                    );
                  });
            },
          )),
          InkWell(
            key: Key("logout"),
            onTap: () {
              logout(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 153, 153, 153),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Logout",
                              style: GoogleFonts.poppins(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': '${loggedInUser.firstName} ${loggedInUser.secondName}'
      }, SetOptions(merge: true));
      Fluttertoast.showToast(
        msg: "Location Added",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': '${loggedInUser.firstName} ${loggedInUser.secondName}'
      }, SetOptions(merge: true));
      Fluttertoast.showToast(
        msg: "Live Location Tracking Enabled",
        backgroundColor: Colors.green,
      );
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    Fluttertoast.showToast(
      msg: "Live Location Tracking Disabled",
      backgroundColor: Colors.orange,
    );
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(
      msg: "Logged Out",
      backgroundColor: Color.fromARGB(255, 0, 204, 105),
      fontSize: 16,
      gravity: ToastGravity.TOP,
    );
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
