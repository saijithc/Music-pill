import 'package:flutter/material.dart';
import 'functions/functions.dart';

// ignore: must_be_immutable
class FavCheck extends StatefulWidget {
  FavCheck({Key? key, this.id}) : super(key: key);
  dynamic id;

  @override
  State<FavCheck> createState() => _FavCheckState();
}

class _FavCheckState extends State<FavCheck> {
  @override
  Widget build(BuildContext context) {
    final finalIndex = Dbfunctions.favsongids.indexWhere((element) => element == widget.id);
    final indexCheck = Dbfunctions.favsongids.contains(widget.id);

    if (indexCheck == true) {
      return IconButton(
          onPressed: () async {
            
            await Dbfunctions.deletefav(finalIndex);
            // Dbfunctions.getAllsongs;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Removed from Liked Songs'),
              margin: EdgeInsets.all(30),
              behavior: SnackBarBehavior.floating,
            ));
          },
          icon: const Icon(
            Icons.favorite,
            color: Colors.green,
          ));
    }
    return IconButton(
        onPressed: () async {
          await Dbfunctions.addsong(widget.id);
          // Dbfunctions.getAllsongs();
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('added to Liked Songs'),
            margin: EdgeInsets.all(30),
            behavior: SnackBarBehavior.floating,
           
          ));
        },
        icon: const Icon(
          Icons.favorite,
          color: Colors.white60,
        ));
  }
}
