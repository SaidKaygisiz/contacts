import 'package:contacts/core/constants.dart';
import 'package:contacts/ui/contacts/model/get_user_result_model.dart';
import 'package:contacts/ui/contacts/view_model/get_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/get_contacts_cubit.dart';
import 'package:contacts/ui/widgets/custom_sized_box.dart';
import 'package:contacts/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<GetContactsResultModelDataUsers?>? list=[];
  List<GetContactsResultModelDataUsers?>? filteredList=[];
  TextEditingController? searchController;
  List<GetContactsResultModelDataUsers?>? result=[];
  @override
  void initState() {
    context.read<GetContactsCubit>().getContacts();
    searchController = TextEditingController();
    super.initState();
  }

  void filterList(String query) {
    setState(() {
      if(query.isEmpty){
        result=list;
      }else{
        result = list!.where((item) {
          return item!.firstName!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 57),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contacts",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    backgroundColor: AppConstants.blue,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/contact_add');
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              CustomSizedBox(),
              CustomTextFormField(
                hintText: "Search by name",
                prefixIcon: Icon(Icons.search),
                controller: searchController,
                fillColor: Colors.white,
                onChanged: (val) {
                  filterList(val??"");
                },
              ),
              BlocConsumer<GetContactsCubit, GetContactsState>(
                      builder: (context, state) {
                        if (state is GetContactsComplete) {
                          list = state.model!.data!.users!;
                      if(searchController?.text==""){
                            result=list;
                          }
                          return result!.isNotEmpty
                              ? Expanded(
                                child: ListView.builder(
                                    itemCount: result?.length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                                        margin: const EdgeInsets.symmetric(vertical: 10),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                          tileColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.pushNamed(context, '/contact_edit');
                                            context.read<GetContactCubit>().getContact(id: result![index]!.id.toString());
                                          },
                                          leading:SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundImage:
                                              NetworkImage('${result?[index]?.profileImageUrl}'),
                                              backgroundColor: Colors.transparent,
                                            ),
                                          ),
                                          title: Text(
                                            '${result?[index]?.firstName} ${result?[index]?.lastName}',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            '${result?[index]?.phoneNumber}',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              )
                              : list!.isEmpty?Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/contact_add.svg",
                                        width: 60,
                                        height: 60,
                                      ),
                                      CustomSizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "No Contacts",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      CustomSizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "Contacts you’ve added will appear here.",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      CustomSizedBox(
                                        height: 7,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/contact_add');
                                          },
                                          child: Text(
                                            "Create New Contact",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.blue),
                                          ))
                                    ],
                                  ),
                                ):Expanded(child: Center(child: Text("Search Not Found..",style: TextStyle
                            (fontWeight: FontWeight.bold,fontSize: 16),),),);
                        } else if (state is GetContactsLoading) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                CustomSizedBox(),
                                Text("Liste getiriliyor,lütfen bekleyiniz..")
                              ],
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                      listener: (context, state) {})

            ],
          ),
        ),
      ),
    );
  }
}
