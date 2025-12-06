import 'package:conference_system/server/services/profile_service.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/widgets/text_field.dart';
import 'package:flutter/material.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key});

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  final profileService = ProfileService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfileInfo();
  }
  Future<void> _loadProfileInfo() async {
    final data = await profileService.getProfileInfo();
    fullNameController.text = data[0]['fullname'] ?? '';
    bioController.text = data[0]['bio'] ?? '';
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRect(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Column(
                      children: [
                        Image.asset('assets/images/default_avatar.png'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                CustomTextField(
                  controller: fullNameController,
                  labelText: AppTexts.fullName,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 15,),
                CustomTextField(
                  controller: bioController,
                  labelText: AppTexts.bio,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 15,),
                ApplyButton(
                  onPressed: () async {
                    await profileService.updateProfileInfo(
                        context,
                        fullNameController.text.trim(),
                        bioController.text.trim()
                    );
                    Navigator.popAndPushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplyButton extends StatelessWidget {
  const ApplyButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
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
      onPressed: onPressed,
      child: Text(AppTexts.apply)
    );
  }
}
