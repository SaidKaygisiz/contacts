import 'package:contacts/business/general/general_manager.dart';
import 'package:contacts/business/general/i_general_manager.dart';
import 'package:contacts/core/constants.dart';
import 'package:contacts/core/network/i_network.dart';
import 'package:contacts/core/network/network.dart';
import 'package:contacts/ui/contacts/view_model/add_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/delete_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/get_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/get_contacts_cubit.dart';
import 'package:contacts/ui/contacts/view_model/update_contact_cubit.dart';
import 'package:contacts/ui/contacts/view_model/upload_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';

void main() {
  MyApp.configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter appRouter = AppRouter();

  static INetwork? network;
  static IGeneralManager? generalManager;

  static configure() async {
    network = HttpNetwork();
    generalManager = GeneralManager(network!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (addContactCubitContext) => AddContactCubit(generalManager!)),
        BlocProvider(create: (getContactsCubitContext) => GetContactsCubit(generalManager!)),
        BlocProvider(create: (getContactCubitContext) => GetContactCubit(generalManager!)),
        BlocProvider(create: (deleteContactCubitContext) => DeleteContactCubit(generalManager!)),
        BlocProvider(create: (updateContactCubitContext) => UpdateContactCubit(generalManager!)),
        BlocProvider(create: (uploadImageCubitContext) => UploadImageCubit(generalManager!)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Nunito",
          useMaterial3: false,
          scaffoldBackgroundColor: AppConstants.page_color
        ),
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
