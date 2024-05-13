import 'dart:io';
import 'package:contacts/core/constants.dart';
import 'package:contacts/ui/contacts/model/register_user_body_model.dart';
import 'package:contacts/ui/contacts/model/update_user_body_model.dart';
import 'package:contacts/ui/contacts/model/user_result_model.dart';
import 'package:contacts/ui/contacts/view_model/delete_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/get_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/update_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/upload_image_cubit.dart';
import 'package:contacts/ui/widgets/custom_sized_box.dart';
import 'package:contacts/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class ContactEditScreen extends StatefulWidget {
  const ContactEditScreen({super.key});

  @override
  State<ContactEditScreen> createState() => _ContactEditScreenState();
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  TextEditingController? firstNameController, lastNameController, phoneNumberController;
  bool isAllFieldsValid = false;
  bool editMode = false;
  final ImagePicker picker = ImagePicker();
  File? image = null;
  late UpdateUserBodyModel bodyModel;
  UserResultModel? userResultModel;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    bodyModel = UpdateUserBodyModel();
    super.initState();
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        updateButtonState();
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        updateButtonState();
      }
    });
  }

  doneButtonControl() {
    if (firstNameController?.text != userResultModel?.data?.firstName ||
        lastNameController?.text != userResultModel?.data?.lastName ||
        phoneNumberController?.text != userResultModel?.data?.phoneNumber || image!=null) {
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
      body: editMode
          ? BlocConsumer<UploadImageCubit, UploadImageState>(builder: (context, state) {
              return BlocConsumer<UpdateContactCubit, UpdateContactState>(builder: (context, state) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.blue),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Text(
                                "New Contact",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor: isAllFieldsValid
                                      ? MaterialStateProperty.all(AppConstants.blue)
                                      : MaterialStateProperty.all(AppConstants.grey_color),
                                ),
                                child: const Text(
                                  "Done",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                onPressed: isAllFieldsValid
                                    ? () {
                                        if (image != null) {
                                          context.read<UploadImageCubit>().uploadImage(file: image!);
                                        } else {
                                          context.read<UploadImageCubit>().emit(ImageNotChange());
                                        }
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 40.5,
                          ),
                          image == null
                              ? Center(
                                  child: SizedBox(
                                    width: 196,
                                    height: 196,
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage('${userResultModel?.data?.profileImageUrl}'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
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
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              )),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                                                    minimumSize: const Size(double.maxFinite, 54),
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
                                                      const Text(
                                                        "Camera",
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black),
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
                                                    minimumSize: const Size(double.maxFinite, 54),
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
                                                      const Text(
                                                        "Gallery",
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black),
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
                                                    minimumSize: const Size(double.maxFinite, 54),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  child: const Row(
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
                              child: const Text(
                                "Change Photo",
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
                if (state is UpdateContactComplete) {
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
                              "Changes have been applied !",
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
            }, listener: (context, state) {
              if (state is UploadImageComplete) {
                bodyModel.firstName = firstNameController?.text;
                bodyModel.lastName = lastNameController?.text;
                bodyModel.phoneNumber = phoneNumberController?.text;
                bodyModel.profileImageUrl = state.model?.data?.imageUrl;
                context
                    .read<UpdateContactCubit>()
                    .updateContact(bodyModel: bodyModel, id: userResultModel!.data!.id.toString());
              } else if (state is ImageNotChange) {
                bodyModel.firstName = firstNameController?.text;
                bodyModel.lastName = lastNameController?.text;
                bodyModel.phoneNumber = phoneNumberController?.text;
                bodyModel.profileImageUrl = userResultModel?.data?.profileImageUrl;
                context
                    .read<UpdateContactCubit>()
                    .updateContact(bodyModel: bodyModel, id: userResultModel!.data!.id.toString());
              } else if (state is UploadImageError) {
                print(state.message);
              }
            })
          : BlocBuilder<GetContactCubit, GetContactState>(
              builder: (context, state) {
                if (state is GetContactComplete) {
                  userResultModel = state.model;
                  firstNameController = TextEditingController(text: userResultModel?.data?.firstName);
                  lastNameController = TextEditingController(text: userResultModel?.data?.lastName);
                  phoneNumberController = TextEditingController(text: userResultModel?.data?.phoneNumber);
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.blue),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Text(
                                "New Contact",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextButton(
                                style: ButtonStyle(foregroundColor: MaterialStateProperty.all(AppConstants.blue)),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                onPressed: () {
                                  setState(() {
                                    editMode = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 40.5,
                          ),
                          image == null
                              ? Center(
                                  child: SizedBox(
                                    width: 196,
                                    height: 196,
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage('${state.model?.data?.profileImageUrl}'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 196,
                                  width: 196,
                                  child: CircleAvatar(
                                    backgroundImage: FileImage(image!),
                                  ),
                                ),
                          CustomSizedBox(
                            height: 20,
                          ),
                          Text('${state.model?.data?.firstName}'),
                          const Divider(thickness: 0.5,color: Colors.black,),
                          CustomSizedBox(
                            height: 15,
                          ),
                          Text('${state.model?.data?.lastName}'),
                          const Divider(thickness: 0.5,color: Colors.black,),
                          CustomSizedBox(
                            height: 15,
                          ),
                          Text('${state.model?.data?.phoneNumber}'),
                          const Divider(thickness: 0.5,color: Colors.black,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(builder: (context, setState) {
                                          return BlocConsumer<DeleteContactCubit, DeleteContactState>(
                                              builder: (context, stateDelete) {
                                            if (stateDelete is DeleteContactLoading) {
                                              return Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25),
                                                      topRight: Radius.circular(25),
                                                    )),
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const CircularProgressIndicator(),
                                                      CustomSizedBox(),
                                                      const Text("Siliniyor,lütfen bekleyiniz..")
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(25),
                                                    topRight: Radius.circular(25),
                                                  )),
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Delete Account?",
                                                      style: TextStyle(
                                                          color: AppConstants.red,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    CustomSizedBox(
                                                      height: 15,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        context
                                                            .read<DeleteContactCubit>()
                                                            .deleteContact(id: state.model!.data!.id.toString());
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppConstants.page_color,
                                                        minimumSize: const Size(double.maxFinite, 54),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black),
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
                                                        minimumSize: const Size(double.maxFinite, 54),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "No",
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }, listener: (context, stateDelete) {
                                            if (stateDelete is DeleteContactComplete) {
                                              Navigator.pushNamedAndRemoveUntil(context, '/contacts', (route) => false);
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                padding: EdgeInsets.zero,
                                                content: Container(
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15),
                                                        topRight: Radius.circular(15),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: AppConstants.grey_color,
                                                            spreadRadius: 1,
                                                            blurRadius: 15)
                                                      ]),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset('assets/images/success.svg'),
                                                        CustomSizedBox(
                                                          width: 24,
                                                        ),
                                                        const Text(
                                                          "Account deleted !",
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
                                        });
                                      });
                                },
                                child: const Text(
                                  "Delete contact",
                                  style: TextStyle(color: AppConstants.red, fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                } else if (state is GetContactLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        CustomSizedBox(),
                        const Text("Bilgiler getiriliyor,lütfen bekleyiniz..")
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
    );
  }
}
