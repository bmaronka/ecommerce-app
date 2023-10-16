import 'package:ecommerce_app/src/features/account/account_screen.dart';
import 'package:ecommerce_app/src/features/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/models/app_user.dart';
import 'package:flutter/material.dart';

enum PopupMenuOption {
  signIn,
  orders,
  account,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({
    this.user,
    super.key,
  });
  final AppUser? user;

  static const signInKey = Key('menuSignIn');
  static const ordersKey = Key('menuOrders');
  static const accountKey = Key('menuAccount');

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: ordersKey,
                  child: Text('Orders'.hardcoded),
                  value: PopupMenuOption.orders,
                ),
                PopupMenuItem(
                  key: accountKey,
                  child: Text('Account'.hardcoded),
                  value: PopupMenuOption.account,
                ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: signInKey,
                  child: Text('Sign In'.hardcoded),
                  value: PopupMenuOption.signIn,
                ),
              ],
        onSelected: (option) {
          switch (option) {
            case PopupMenuOption.signIn:
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const EmailPasswordSignInScreen(
                    formType: EmailPasswordSignInFormType.signIn,
                  ),
                ),
              );
              break;
            case PopupMenuOption.orders:
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const OrdersListScreen(),
                ),
              );
              break;
            case PopupMenuOption.account:
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const AccountScreen(),
                ),
              );
              break;
          }
        },
      );
}
