
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String uid, urlImage;
  const ServiceCard({Key? key, required this.uid, required this.urlImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(urlImage),
                fit: BoxFit.cover,
                alignment: const Alignment(-0.3, 0),
              ),
            ),
            child: Center(
                child: Column(
              children:[
                const Text(
                  '{Hi Im Sean, I can work out with you :D}',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                      backgroundColor: Colors.black),
                ),
                Text(uid)
              ],
            )),
          ),
        ),
      ),
    );
  }
}
