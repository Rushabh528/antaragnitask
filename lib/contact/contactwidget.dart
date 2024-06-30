// import 'dart:io';

// import 'package:flutter/material.dart';

// class contactwidget extends StatefulWidget {
//   final String name;
//   final String email;
//   final String phone;
//   final File image;
//   const contactwidget(
//       {super.key,
//       required this.name,
//       required this.email,
//       required this.phone,
//       required this.image});

//   @override
//   State<contactwidget> createState() => _contactwidgetState();
// }

// class _contactwidgetState extends State<contactwidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListTile(
//         title: Text(widget.name),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [Text(widget.email), Text(widget.phone)],
//         ),
//         leading: CircleAvatar(
//           backgroundImage: FileImage(widget.image),
//         ),
//         shape: RoundedRectangleBorder(
//             side: BorderSide(color: Color(0xFF00203F)),
//             borderRadius: BorderRadius.circular(6)),
//       ),
//     );
//   }
// }
