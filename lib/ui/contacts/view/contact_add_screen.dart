import 'dart:io';
import 'package:contacts/core/constants.dart';
import 'package:contacts/ui/contacts/model/register_user_body_model.dart';
import 'package:contacts/ui/contacts/view_model/add_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/upload_image_cubit.dart';
import 'package:contacts/ui/widgets/custom_sized_box.dart';
import 'package:contacts/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ContactAddScreen extends StatefulWidget {
  const ContactAddScreen({super.key});

  @override
  State<ContactAddScreen> createState() => _ContactAddScreenState();
}

class _ContactAddScreenState extends State<ContactAddScreen> {
  TextEditingController? firstNameController, lastNameController, phoneNumberController;
  bool isAllFieldsValid = false;
  final ImagePicker picker = ImagePicker();
  File? image = null;
  late RegisterUserBodyModel bodyModel;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    bodyModel = RegisterUserBodyModel();
    super.initState();
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        if (pickedFile.path.toLowerCase().endsWith(".jpg") || pickedFile.path.toLowerCase().endsWith(".png")) {
          image = File(pickedFile.path);
          updateButtonState();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            padding: EdgeInsets.zero,
            content: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [BoxShadow(color: AppConstants.grey_color, spreadRadius: 1, blurRadius: 15)]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.error,color: Colors.red,),
                    CustomSizedBox(
                      width: 24,
                    ),
                    Text(
                      "Lütfen png veya jpg formatında seçiniz..",
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ));
        }
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        if (pickedFile.path.toLowerCase().endsWith(".jpg") || pickedFile.path.toLowerCase().endsWith(".png")) {
          image = File(pickedFile.path);
          updateButtonState();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            padding: EdgeInsets.zero,
            content: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [BoxShadow(color: AppConstants.grey_color, spreadRadius: 1, blurRadius: 15)]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.error,color: Colors.red,),
                    CustomSizedBox(
                      width: 24,
                    ),
                    Text(
                      "Lütfen png veya jpg formatında seçiniz..",
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ));
        }
      }
    });
  }

  doneButtonControl() {
    if (firstNameController?.text != "" && lastNameController?.text != "" && phoneNumberController?.text != "" &&
        image!=null) {
      return true;
    } else {
      return false;
    }
  }

  void updateButtonState() {
    setState(() {
      isAllFieldsValid = doneButtonControl();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.page_color,
      body: BlocConsumer<UploadImageCubit, UploadImageState>(
        builder: (context, state) {
          if (state is UploadImageLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  CustomSizedBox(),
                  Text("Ekleniyor,lütfen bekleyiniz.."),
                ],
              ),
            );
          }
          return BlocConsumer<AddContactCubit, AddContactState>(builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(vertical: 50),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.blue),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "New Contact",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: isAllFieldsValid
                                  ? MaterialStateProperty.all(AppConstants.blue)
                                  : MaterialStateProperty.all(AppConstants.grey_color),
                            ),
                            child: Text(
                              "Done",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: isAllFieldsValid
                                ? () {
                                    context.read<UploadImageCubit>().uploadImage(file: image!);
                                  }
                                : null,
                          ),
                        ],
                      ),
                      CustomSizedBox(
                        height: 40.5,
                      ),
                      image == null
                          ? SvgPicture.asset(
                              'assets/images/contact_add.svg',
                            )
                          : SizedBox(
                              height: 196,
                              width: 196,
                              child: CircleAvatar(
                                backgroundImage: FileImage(image!),
                              ),
                            ),
                      TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (context, setState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                          )),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                getImageFromCamera();
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppConstants.page_color,
                                                minimumSize: Size(double.maxFinite, 54),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/camera.svg',
                                                  ),
                                                  CustomSizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    "Camera",
                                                    style: TextStyle(
                                                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                getImageFromGallery();
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppConstants.page_color,
                                                minimumSize: Size(double.maxFinite, 54),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/gallery.svg',
                                                  ),
                                                  CustomSizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    "Gallery",
                                                    style: TextStyle(
                                                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppConstants.page_color,
                                                minimumSize: Size(double.maxFinite, 54),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppConstants.blue),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Text(
                            "Add Photo",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          )),
                      CustomTextFormField(
                        controller: firstNameController,
                        onChanged: (c) {
                          updateButtonState();
                        },
                        hintText: "First Name",
                      ),
                      CustomSizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: lastNameController,
                        onChanged: (c) {
                          updateButtonState();
                        },
                        hintText: "Last Name",
                      ),
                      CustomSizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: phoneNumberController,
                        onChanged: (c) {
                          updateButtonState();
                        },
                        hintText: "Phone Number",
                      ),
                    ],
                  ),
                ),
              ),
            );
          }, listener: (context, state) {
            if (state is AddContactComplete) {
              Navigator.pushNamedAndRemoveUntil(context, '/contacts', (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                padding: EdgeInsets.zero,
                content: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      boxShadow: [BoxShadow(color: AppConstants.grey_color, spreadRadius: 1, blurRadius: 15)]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/success.svg'),
                        CustomSizedBox(
                          width: 24,
                        ),
                        Text(
                          "User added !",
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
              ));
            }
          });
        },
        listener: (context, state) {
          if (state is UploadImageComplete) {
            bodyModel.firstName = firstNameController?.text;
            bodyModel.lastName = lastNameController?.text;
            bodyModel.phoneNumber = phoneNumberController?.text;
            bodyModel.profileImageUrl = state.model?.data?.imageUrl;
            context.read<AddContactCubit>().addContact(bodyModel: bodyModel);
          } else if (state is UploadImageError) {
            print(state.message);
          }
        },
      ),
    );
  }
}
