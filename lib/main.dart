import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vgs_collect_flutter_demo/activate_card/controller/activate_card_cubit.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_show_data.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_show_tab_page.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_tokenization/collect_tokenization_page.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/custom_card_data/custom_card_data.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';

import 'activate_card/view/cvv_expiry_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CollectShowData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.activateCard,
      routes: {
        RouteNames.customCardData: (context) => CustomCardDataPage(),
        RouteNames.collectShowCardData: (context) => CollectShowTabPage(),
        RouteNames.tokenizeCardData: ((context) => CollectTokenizeCardPage()),
        RouteNames.activateCard: ((context) => BlocProvider<ActivateCardCubit>(
              create: (context) => ActivateCardCubit(),
              child: CvvExpiryPage(),
            )),
      },
    );
  }
}
