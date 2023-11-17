import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PopupMenuOption {
  signIn,
  orders,
  account,
  admin,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({
    required this.isAdminUser,
    this.user,
    super.key,
  });

  final bool isAdminUser;
  final AppUser? user;

  static const signInKey = Key('menuSignIn');
  static const ordersKey = Key('menuOrders');
  static const accountKey = Key('menuAccount');
  static const adminKey = Key('menuAdmin');

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
                if (isAdminUser)
                  PopupMenuItem(
                    key: adminKey,
                    value: PopupMenuOption.admin,
                    child: Text('Admin'.hardcoded),
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
              context.pushNamed(AppRoute.signIn.name);
              break;
            case PopupMenuOption.orders:
              context.pushNamed(AppRoute.orders.name);
              break;
            case PopupMenuOption.account:
              context.pushNamed(AppRoute.account.name);
              break;
            case PopupMenuOption.admin:
              context.pushNamed(AppRoute.admin.name);
              break;
          }
        },
      );
}
