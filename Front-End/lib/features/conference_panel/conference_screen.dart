import 'package:flutter/material.dart';
import 'package:conference_system/server/services/hall_service.dart';
import 'package:conference_system/utils/app_texts.dart';

class HallScreen extends StatefulWidget {
  const HallScreen({super.key});

  @override
  State<HallScreen> createState() => _HallScreenState();
}

class _HallScreenState extends State<HallScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 800;

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            HallLists(),
            SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: AddButton(),
    );
  }
}

class HallLists extends StatelessWidget {
  const HallLists({super.key});

  @override
  Widget build(BuildContext context) {
    final hallService = HallService();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: hallService.getHallLists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(AppTexts.noData);
        } else {
          final halls = snapshot.data!;
          return ListView.builder(
            itemCount: halls.length,
            itemBuilder: (context, index) {
              final hall = halls[index];
              return ListTile(
                title: Text(hall['name'] ?? ''),
                subtitle: Text(hall['date'] ?? ''),
              );
            },
          );
        }
      },
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {

        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: CircleBorder(

          )
        ),
        child: SizedBox(
            width: 60,
            height: 60,
            child: Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
            ),
        )
    );
  }
}
