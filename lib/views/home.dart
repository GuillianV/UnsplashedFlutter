import 'package:flutter/material.dart';
import 'package:unsplashed/models/photo.dart';
import 'package:unsplashed/models/http';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(1, (index) {
            return Center(
                child: FutureBuilder<Photo>(
              future: http_get_random_Photo(), // async work
              builder: (BuildContext context,
                  AsyncSnapshot<Photo> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  default:
                    if (snapshot.hasError && snapshot.data != null)
                      return Text('Error');
                    else {
                      return Image.network(snapshot.data!.fullUrl); 
                    }
                }
              },
            ));
          }),
        ),
      ),
    );
  }
}
