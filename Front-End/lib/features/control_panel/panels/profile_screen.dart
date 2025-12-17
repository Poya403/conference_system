import 'package:flutter/material.dart';
import 'package:conference_system/server/services/profile_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/utils/date_converter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.editButtonOnPressed
  });

  final Function(int) editButtonOnPressed;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 700;
    final labelStyle = TextStyle(color: Colors.blueGrey, fontSize: isDesktop ? 15 : 12);
    final responseStyle = TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.w700,
      fontSize: isDesktop ? 17 : 13.5,
    );
    final iconSize = 17.0;

    ProfileService profileService = ProfileService();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: profileService.getProfileInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(AppTexts.noData);
        } else {
          final info = snapshot.data![0];
          return SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              elevation: 4,
              color: Colors.white,
              child: Column(
                textDirection: TextDirection.rtl,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 1500,
                        height: isDesktop ? 120 : 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)
                          ),
                          color: Colors.deepPurpleAccent,
                        ),
                      ),

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -40,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/default_avatar.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  Text(info['fullname'] ?? '', style: responseStyle),

                  Text(info['role'] ?? '', style: responseStyle),
                  SizedBox(height: 20),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19.5),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.article_outlined, size: iconSize),
                        SizedBox(width: 6),
                        Text(': ${AppTexts.bio}', style: labelStyle),
                        SizedBox(width: 6),
                        Text(info['bio'] ?? '', style: responseStyle),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19.5),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.email_outlined, size: iconSize),
                        SizedBox(width: 6),
                        Text(': ${AppTexts.email}', style: labelStyle),
                        SizedBox(width: 6),
                        Text(info['email'] ?? '', style: responseStyle),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19.5),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.phone_outlined, size: iconSize),
                        SizedBox(width: 6),
                        Text(': ${AppTexts.phoneNumber}', style: labelStyle),
                        SizedBox(width: 6),
                        Text(
                          info['phone_number'] ?? '',
                          style: responseStyle,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19.5),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: iconSize),
                        SizedBox(width: 6),
                        Text(': ${AppTexts.createdAt}', style: labelStyle),
                        SizedBox(width: 6),
                        Text(
                          formatToJalali(info['user_created_at'] ?? ''),
                          style: responseStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  EditButton(onPanelChanged: widget.editButtonOnPressed),
                  SizedBox(height: 16,),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.onPanelChanged});
  final Function(int) onPanelChanged;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      onPressed: () => onPanelChanged(5),
      child: SizedBox(
        width: 70,
        height: 30,
        child: Row(
          children: [Text(AppTexts.edit), SizedBox(width: 6), Icon(Icons.edit)],
        ),
      ),
    );
  }
}
