import 'package:conference_system/bloc/users/users_event.dart';
import 'package:conference_system/data/DTOs/update_user_dto.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/widgets/custom_text_fields/text_form_field.dart';
import 'package:conference_system/widgets/custom_text_fields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/bloc/users/users_bloc.dart';
import 'package:conference_system/bloc/users/users_state.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key});

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repaidPasswordController = TextEditingController();
  bool userFieldDisabled = false;
  late String initialFullName;
  late String initialPhone;
  late String initialBio;

  bool get hasChanges {
    if (userFieldDisabled) {
      return true;
    } else {
      return fullNameController.text != initialFullName ||
          phoneController.text != initialPhone ||
          bioController.text != initialBio;
    }
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<UsersBloc>().state as UserLoaded;
    initialFullName = user.user.fullName;
    initialPhone = user.user.phone ?? '';
    initialBio = user.user.bio ?? '';

    fullNameController.text = initialFullName;
    phoneController.text = initialPhone;
    bioController.text = initialBio;

    fullNameController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
    bioController.addListener(() => setState(() {}));
    repaidPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    fullNameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    repaidPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state){
        if (state is UsersActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UsersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is UsersLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          final user = state.user;
          final actionButtons = [
            PasswordPanelButton(
                isOpenPanel: !userFieldDisabled,
                onPressed: (){
                  setState(() {
                    userFieldDisabled = !userFieldDisabled;
                  });
                }
            ),
            ApplyButton(
              title: userFieldDisabled ? AppTexts.changePassword : AppTexts.editInfo,
              enabled: hasChanges,
              onPressed: () {
                if (userFieldDisabled) {
                  if (newPasswordController.text != repaidPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('رمز عبور جدید و تکرار آن یکسان نیست'),
                      ),
                    );
                    return;
                  }

                  context.read<UsersBloc>().add(
                    UpdateUserEvent(
                      userId: user.id,
                      dto: UpdateUserDto(
                        oldPassword: passwordController.text,
                        newPassword: newPasswordController.text,
                      ),
                    ),
                  );
                } else {
                  context.read<UsersBloc>().add(
                    UpdateUserEvent(
                      userId: user.id,
                      dto: UpdateUserDto(
                        fullName: fullNameController.text,
                        bio: bioController.text,
                        phone: phoneController.text,
                      ),
                    ),
                  );
                }
              },
            )
          ];

          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isDesktop
                      ? Column(
                    textDirection: TextDirection.rtl,
                    spacing: 25,
                    children: [
                      ClipRect(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/default_avatar.png',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        textDirection: TextDirection.rtl,
                        spacing: 10,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            spacing: 30,
                            children: [
                              CustomTextFormField(
                                controller: fullNameController,
                                labelText: AppTexts.fullName,
                                textDirection: TextDirection.rtl,
                                width: 200,
                                readOnly: userFieldDisabled,
                              ),
                              CustomTextFormField(
                                controller: phoneController,
                                labelText: AppTexts.phoneNumber,
                                textDirection: TextDirection.rtl,
                                width: 200,
                                readOnly: userFieldDisabled,
                              ),
                            ],
                          ),
                          CustomTextFormField(
                            controller: bioController,
                            labelText: AppTexts.bio,
                            textDirection: TextDirection.rtl,
                            width: 430,
                            maxLines: 3,
                            readOnly: userFieldDisabled,
                          ),
                        ],
                      ),
                      if(userFieldDisabled)...[
                        ChangePasswordPanel(
                          oldPasswordController: passwordController,
                          newPasswordController: newPasswordController,
                          repaidPasswordController: repaidPasswordController,
                        )
                      ],
                      Row(spacing: 10, mainAxisAlignment: MainAxisAlignment.center, children: actionButtons),
                      SizedBox(height: 10,),
                    ],
                  )
                  // for mobile screen
                      : Column(
                    textDirection: TextDirection.rtl,
                    spacing: 20,
                    children: [
                      ClipRect(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/default_avatar.png',
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomTextFormField(
                        controller: fullNameController,
                        labelText: AppTexts.fullName,
                        textDirection: TextDirection.rtl,
                        readOnly: userFieldDisabled,
                      ),
                      CustomTextFormField(
                        controller: bioController,
                        labelText: AppTexts.bio,
                        textDirection: TextDirection.rtl,
                        readOnly: userFieldDisabled,
                      ),
                      CustomTextFormField(
                        controller: phoneController,
                        labelText: AppTexts.phoneNumber,
                        textDirection: TextDirection.rtl,
                        readOnly: userFieldDisabled,
                      ),
                      if(userFieldDisabled)...[
                        ChangePasswordPanel(
                          oldPasswordController: passwordController,
                          newPasswordController: newPasswordController,
                          repaidPasswordController: repaidPasswordController,
                        )
                      ],
                      SizedBox(height: 5),
                      Row(spacing: 10, mainAxisAlignment: MainAxisAlignment.center, children: actionButtons),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: Text(AppTexts.initialize));
      },
    );
  }
}

class ApplyButton extends StatelessWidget {
  const ApplyButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.enabled
  });

  final VoidCallback onPressed;
  final String title;
  final bool enabled;

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
      onPressed: enabled ? onPressed: null,
      child: Text(title),
    );
  }
}

class PasswordPanelButton extends StatelessWidget {
  const PasswordPanelButton({super.key,
    required this.onPressed, required this.isOpenPanel});

  final VoidCallback onPressed;
  final bool isOpenPanel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(isOpenPanel ? AppTexts.changePassword : AppTexts.cancel),
    );
  }
}

class ChangePasswordPanel extends StatelessWidget {
  const ChangePasswordPanel({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.repaidPasswordController,
  });

  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController repaidPasswordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextField(
              controller: oldPasswordController,
              labelText: AppTexts.password,
              textDirection: TextDirection.rtl,
              isPassword: true,
              width: 200,
              height: 38,
            ),
            CustomTextField(
              controller: newPasswordController,
              labelText: AppTexts.newPassword,
              textDirection: TextDirection.rtl,
              isPassword: true,
              width: 200,
              height: 38,
            ),
            CustomTextField(
              controller: repaidPasswordController,
              labelText: AppTexts.repaidPassword,
              textDirection: TextDirection.rtl,
              isPassword: true,
              width: 200,
              height: 38,
            ),
          ],
        ),
      ),
    );
  }
}
