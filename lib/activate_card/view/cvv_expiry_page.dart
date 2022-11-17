import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/activate_card_cubit.dart';
import 'activate_card_page.dart';

class CvvExpiryPage extends StatelessWidget {
  CvvExpiryPage({
    super.key,
  });

  final bloc = ActivateCardCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 40, 16, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Text(
                //       AppStrings.enterThe,
                //       style: Theme.of(context).textTheme.titleLarge,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //       child: GradientText(
                //         AppStrings.cvv,
                //         gradient: AppColors.primaryGreenGradient,
                //         style: Theme.of(context).textTheme.titleLarge,
                //       ),
                //     ),
                //     Text(
                //       AppStrings.and,
                //       style: Theme.of(context).textTheme.titleLarge,
                //     ),
                //   ],
                // ),
                // GradientText(
                //   AppStrings.expirationDate,
                //   gradient: AppColors.primaryGreenGradient,
                //   style: Theme.of(context).textTheme.titleLarge,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: NativeActivateCardView(
                    bloc: bloc,
                    //TODO: this are the cardBaasToken / cardBaasId
                    token: "dummy",
                    baasId: "dummy",
                  ),
                ),
              ],
            ),
            BlocBuilder<ActivateCardCubit, ActivateCardState>(
              bloc: bloc,
              builder: (context, state) {
                return ElevatedButton(
                  child: const Text("next"),
                  onPressed: () => bloc.onValidate(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
