import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            const ListTile(
              leading: Text(
                'Developed by ',
                style: TextStyle(color: Colors.amber),
              ),
              trailing: Text(
                'Saijith',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const ListTile(
              leading: Text(
                'Version',
                style: TextStyle(color: Colors.amber),
              ),
              trailing: Text(
                '1.0.1',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04),
                  child: InkWell(
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                Column(
                                  children: [
                                    ListTile(
                                      title: const Text(
                                        'LinkedIn',
                                      ),
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                            'https://www.linkedin.com/in/saijith-c-855495226/'));
                                      },
                                    ),
                                    const Divider(height: 1),
                                    ListTile(
                                      title: const Text('instagram'),
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                            'https://www.instagram.com/_saijithsai/'));
                                      },
                                    )
                                  ],
                                )
                              ],
                            );
                          });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
