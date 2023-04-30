import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:web_date_picker/web_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'controllers/auth_Controller.dart';
import 'mydrawer.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('students');
String temp = "";
class DashBoard extends StatefulWidget {
  DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int percent = 50;
  var _location, _dob, _gender;
  var _locationLast, _dobLast, _genderLast;
  var data;
  Timer? timer;
  final _connect = Dio();
  bool relay1 = false;
  bool relay2 = false;
  bool relay3 = false;
  bool relay4 = false;
  String temperature = "Loading";
  String humidity = "Loading";

  getData() async {
    try{
      final response = await http.get(Uri.parse("https://intellihouse.cyclic.app/api/v1/relayData"));
    
    print(response.body);
    var relayDatas = jsonDecode(response.body);
    print(relayDatas["relay1"]);
    print(relayDatas["relay4"]);setState(() {
    relayDatas["relay1"] == "on" ? relay1 = true : relay1 = false;
    relayDatas["relay2"] == "on" ? relay2 = true : relay2 = false;
    relayDatas["relay3"] == "on" ? relay3 = true : relay3 = false;
    relayDatas["relay4"] == "on" ? relay4 = true : relay4 = false;
    });

       
    }
    catch(error){
      print(error);
    }
  }


  getSensorData() async {
     try{
      final response = await http.get(Uri.parse("https://intellihouse.cyclic.app/api/v1/sensorData"));
    
    print(response.body);
    var sensorData = jsonDecode(response.body);
    print(sensorData["humidity"]);
    print(sensorData["temperature"]);
    setState(() {
     humidity = sensorData["humidity"];
     temperature = sensorData["temperature"];
     temp = sensorData["temperature"];
    });

       
    }
    catch(error){
      print(error);
    }
  }


  sendData() async {
    String r1 ;String r2 ; String r3 ; String r4;
    relay1 == true  ? r1 = "on" : r1 = "off";
    relay2 == true  ? r2 = "on" : r2 = "off";
    relay3 == true  ? r3 = "on" : r3 = "off";
    relay4 == true  ? r4 = "on" : r4 = "off";
    try{
      

    var jsonMap =  {
            "relay1" : r1,
            "relay2" : r2,
            "relay3" : r3,
            "relay4" : r4
        };
    
    Dio().put("https://intellihouse.cyclic.app/api/v1/updateRelay",data:  jsonMap).then((value) => {
          print(value.data)
        });

    
    }
    catch(error){
      print(error);
    }
  }


  @override
  late final controller;
  void initState() {

    controller = Get.put(AuthController());
    data =
        controller.getDataofStudent(FirebaseAuth.instance.currentUser!.email);
    print(">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<");
    print(data);
    // setState(() {
    //  _location = data[0];
    //  _dob = data[1];
    //  _gender = data[2];
    //     });
        timer = Timer.periodic(const Duration(seconds: 10),(Timer t)  {
            getData();
            getSensorData();
        });

        
    super.initState();
  }
  @override
  void dispose() {
     timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("IntelliHouse"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 20,
                  child: ClipOval(
                      child: Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL!)),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {},
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        FirebaseAuth.instance.currentUser!.displayName!,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )))),
        ],
      ),
      body: StreamBuilderContainer(_size, context),
      // mybody(_size, context),
      drawer: _size.width > 600
          ? null
          : MyDrawer(
              imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
              accountName: FirebaseAuth.instance.currentUser!.displayName!,
              accountEmail: FirebaseAuth.instance.currentUser!.email!,
            ),
    );
  }

  Widget mybody(Size _size, BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: _size.width > 600
              ? Material(
                  elevation: 0.0,
                  child: MyDrawer(
                    imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                    accountName:
                        FirebaseAuth.instance.currentUser!.displayName!,
                    accountEmail: FirebaseAuth.instance.currentUser!.email!,
                  ),
                )
              : null,
        ),
        Expanded(
          child: Column(
            children: [
              firstContainer(_size),
              // secondContainer2(context),
              // TempIndicator(),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image.asset("assets/humi.png",height: 40,width: 40,),
              Text("Humidity \n $humidity",style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              ],),
              SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image.asset("assets/temp.png",height: 50,width: 50,),
              Text("Temperature \n $temperature",style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 18),),
              ],),
          
                Switch(value: relay1, onChanged: (val){
                  setState(() {
                    relay1 = val;
                  });
                  sendData();
                }),
                Text("Device 1",style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 18),),
                Switch(value: relay2, onChanged: (val){
                  setState(() {
                    relay2= val;
                  });
                  sendData();
                }),
                Text("Device 2",style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 18),),
                
                Switch(value: relay3, onChanged: (val){
                  setState(() {
                  relay3 = val;
                  });
                  sendData();
                }),
                Text("Device 3",style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 18),),
                
                Switch(value: relay4, onChanged: (val){
                  setState(() {
                  relay4 = val;
                  });
                  sendData();
                }),
                Text("Device 4",style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 18),),
                
             
            ],
          ),
        ),
      ],
    );
  }

  Widget StreamBuilderContainer(_size, context) {
    return StreamBuilder(
        stream: _mainCollection
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else if (snapshot.hasData) {
            Future.delayed(Duration(seconds: 3));
            _locationLast = _location;
            _genderLast = _gender;
            _dobLast = _dob;
            _location = snapshot.data!.get("location");
            _gender = snapshot.data!.get("gender");
            _dob = snapshot.data!.get("dob");
            print("----> Location =$_location#");
            print("---->Gender =$_gender#");
            print("---->Dob =$_dob#");
            if ((_location == "") &&
                _locationLast != _location &&
                controller.per.value >= 34) {
              print("not location------->");
              controller.per.value = controller.per.value - 33;
            } else if ((_location != "") &&
                _locationLast != _location &&
                controller.per.value <= 67) {
              print("is location------->");
              controller.per.value = controller.per.value + 33;
            }
            if (_gender == "" && controller.per.value >= 34) {
              print("not gender------->");
              controller.per.value = controller.per.value - 33;
            } else if (_gender != "" && controller.per.value <= 67) {
              print("is gender------->");
              percent = percent + 33;
            }
            if (_dob == null && controller.per.value >= 34) {
              print("not dob------->");
              controller.per.value = controller.per.value - 33;
            } else if (_dob != null && controller.per.value <= 67) {
              print("is dob------->");
              controller.per.value = controller.per.value + 33;
            }

            return mybody(_size, context);
          }
          return CircularProgressIndicator();
        });
  }

  Padding secondContainer2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, right: 8, left: 8, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Personal Detailed",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              TextEditingController locationEditigController =
                                  TextEditingController();
                              TextEditingController genderEditigController =
                                  TextEditingController();
                              var dob;
                              locationEditigController.text = _location;
                              genderEditigController.text = _gender;
                              return AlertDialog(
                                content: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Location"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: locationEditigController,
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text("Gender"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: genderEditigController,
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    // WebDatePicker(onChange:(value) {
                                    //   dob = "${value!.year}/${value.month}/${value.day}";
                                    //   _dob =dob;
                                    //   print(">>>>>>>>>>$_dob");
                                    //   Get.back();
                                    //   Get.back();
                                    // },)
                                    // SfDateRangePicker(onSelectionChanged: (agr){
                                    //     if(agr.value is DateTime){
                                    //       dob = "${agr.value!.year}/${agr.value.month}/${agr.value.day}";
                                    //   _dob =dob;
                                    //   print(">>>>>>>>>>$_dob");

                                    //     }
                                    // },)
                                    // getDateRangePicker()
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _location =
                                                locationEditigController.text;
                                            _gender =
                                                genderEditigController.text;
                                            _dob = dob.toString();
                                          });
                                          controller.updateDb(
                                              FirebaseAuth
                                                  .instance.currentUser!.email,
                                              _location,
                                              _dob,
                                              _gender);
                                          Get.back();
                                          _showDatePicker();
                                        },
                                        child: Text("Next"))
                                  ],
                                ),
                              );
                            });
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
            Divider(
              color: Colors.deepPurple[50],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_pin),
                        Text("Location"),
                      ],
                    ),
                    Text(_location ?? "Input Location"),
                    Row(
                      children: [
                        Icon(Icons.group_remove_rounded),
                        Text("Gender"),
                      ],
                    ),
                    Text(_gender ?? "Input Gender")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month),
                        Text("DOB"),
                      ],
                    ),
                    Text(_dob ?? "Input DOB")
                  ],
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2101));
    if (picked != null) {
      print(DateFormat("yyyy-MM-dd").format(picked));
      _dob = DateFormat("yyyy-MM-dd").format(picked);
      controller.updateDb(
          FirebaseAuth.instance.currentUser!.email, _location, _dob, _gender);
    }
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _dob = DateFormat('yyyy-MM-dd').format(args.value);

    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  Widget getDateRangePicker() {
    return Container(
        height: 250,
        child: Card(
            child: SfDateRangePicker(
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: selectionChanged,
        )));
  }

  Widget linearPercentIndicator() {
    return Obx(
      () => LinearPercentIndicator(
        // animation: true,
        // animationDuration: 1000,
        lineHeight: 20.0,
        percent: controller.per.value / 100,
        barRadius: Radius.circular(25),
        center: Text(
          "${controller.per.value}%",
          style: const TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        // linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.blue[400],
        backgroundColor: Colors.grey[300],
      ),
    );
  }

  Widget firstContainer(Size _size) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 40,
                child: ClipOval(
                    child: Image.network(
                        FirebaseAuth.instance.currentUser!.photoURL!)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName!
                        .split(" ")[0],
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Container(
                      width: _size.width * 0.5,
                      child: linearPercentIndicator()),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TempIndicator extends StatelessWidget {
  int val = 21;
  
  TempIndicator({
    // required this.val,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    try {
  var n = double.parse(temp);
  val = n.toInt();
  print(n);
} on FormatException {
  print('Format error!');
}
      return SfRadialGauge(
        animationDuration: 5000,
    axes: <RadialAxis>[
    RadialAxis(
      minimum: -50,
      maximum: 50,
      interval: 10,
      radiusFactor: 0.5,
      showAxisLine: false,
      labelOffset: 5,
      useRangeColorForAxis: true,
      axisLabelStyle: const GaugeTextStyle(fontWeight: FontWeight.bold),
      ranges: <GaugeRange>[
        GaugeRange(
            startValue: -50,
            endValue: -20,
            sizeUnit: GaugeSizeUnit.factor,
            color: Colors.green,
            endWidth: 0.03,
            startWidth: 0.03),
        GaugeRange(
            startValue: -20,
            endValue: 20,
            sizeUnit: GaugeSizeUnit.factor,
            color: Colors.yellow,
            endWidth: 0.03,
            startWidth: 0.03),
        GaugeRange(
            startValue: 20,
            endValue: 50,
            sizeUnit: GaugeSizeUnit.factor,
            color: Colors.red,
            endWidth: 0.03,
            startWidth: 0.03),
      ],
      annotations: const <GaugeAnnotation>[
        GaugeAnnotation(
            widget: Text(
              '°C',
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            positionFactor: 0.8,
            angle: 90)
      ],
    ),
    RadialAxis(
            
      ticksPosition: ElementsPosition.outside,
      labelsPosition: ElementsPosition.outside,
      minorTicksPerInterval: 5,
      axisLineStyle: const AxisLineStyle(
        thicknessUnit: GaugeSizeUnit.factor,
        thickness: 0.1,
      ),
      axisLabelStyle: const GaugeTextStyle(
            
          fontWeight: FontWeight.bold,
          fontSize: 16),
      radiusFactor: 0.97,
      majorTickStyle: const MajorTickStyle(
          length: 0.1,
          thickness: 2,
            
          lengthUnit: GaugeSizeUnit.factor),
      minorTickStyle: const MinorTickStyle(
          length: 0.05,
          thickness: 1.5,
            
          lengthUnit: GaugeSizeUnit.factor),
      minimum: -60,
      maximum: 120,
      interval: 20,
      startAngle: 115,
      endAngle: 65,
      ranges: <GaugeRange>[
        GaugeRange(
            startValue: -60,
            endValue: 120,
            startWidth: 0.1,
            sizeUnit: GaugeSizeUnit.factor,
            endWidth: 0.1,
            gradient: const SweepGradient(stops: <double>[
              0.2,
              0.5,
              0.75
            ], colors: <Color>[
              Colors.green,
              Colors.yellow,
              Colors.red
            ]))
      ],
      pointers:  <GaugePointer>[
        NeedlePointer(
            value: val.toDouble()  ,
             needleColor: Colors.black,
            tailStyle: TailStyle(length: 0.18, width: 8,
                color: Colors.black,
                lengthUnit: GaugeSizeUnit.factor),
            needleLength: 0.68,
            needleStartWidth: 1,
            needleEndWidth: 8,
            knobStyle: KnobStyle(knobRadius: 0.07,
                color: Colors.white, borderWidth: 0.05,
                borderColor: Colors.black),
            lengthUnit: GaugeSizeUnit.factor)
      ],
      annotations: const <GaugeAnnotation>[
        GaugeAnnotation(
            widget: Text(
              '°F',
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            positionFactor: 0.8,
            angle: 90)
      ],
    ),
            ],
          );
  }
}
