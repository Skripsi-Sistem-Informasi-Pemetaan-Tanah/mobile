import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/util/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Todo: Add Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  // Todo: Init Local Storage
  await GetStorage.init();
  // Todo: Awoit Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Todo: Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  // Todo: Initialize Authentication

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: DAppTheme.lightTheme,
      darkTheme: DAppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Picker Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   // List<File> _images = [];

//   // Future<void> _pickImage() async {
//   //   final picker = ImagePicker();
//   //   final pickedImage = await picker.pickImage(source: ImageSource.camera);
//   //   if (pickedImage != null) {
//   //     setState(() {
//   //       _images.add(File(pickedImage.path));
//   //     });
//   //   }
//   // }

//   final imagePicker = ImagePicker();
//   List<File> _images = [];

//   Future<void> getFromCamera() async {
//     final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _images.add(File(pickedFile.path));
//       });
//     }
//   }

//   void _deleteImage(int index) {
//     setState(() {
//       _images.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker Demo'),
//       ),
//       body:
      
//       Container(
//         height: 80,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: _images.length + 1,
//           itemBuilder: (context, index) {
//             if (index == 0) {
//               return GestureDetector(
//                 onTap: getFromCamera,
//                 child: Container(
//                   // margin: EdgeInsets.symmetric(horizontal: 8.0),
//                   width: 80,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                     color: Colors.grey[200],
//                   ),
//                   child: Icon(
//                     Icons.camera_alt,
//                     size: 40,
//                     color: Colors.grey,
//                   ),
//                 ),
//               );
//             } else {
//               return Stack(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(left: 8.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                       color: Colors.grey[200],
//                     ),
//                     width: 80,
//                     height: 150,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12.0),
//                       child: Image.file(
//                         _images[index - 1],
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 5,
//                     right: 5,
//                     child: GestureDetector(
//                       onTap: () => _deleteImage(index - 1),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey[800],
//                         ),
//                         padding: EdgeInsets.all(4),
//                         child: Icon(
//                           Icons.close,
//                           color: Colors.white,
//                           size: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
