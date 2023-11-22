import 'dart:async';

import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/data/user_metadata_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_token_refresh_service.g.dart';

class UserTokenRefreshService {
  UserTokenRefreshService(this.ref) {
    _init();
  }

  final Ref ref;
  StreamSubscription<DateTime?>? _subscription;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(
      authStateChangesProvider,
      (previous, next) {
        final user = next.value;
        _subscription?.cancel();

        if (user != null) {
          _subscription = ref.read(userMetadataRepositoryProvider).watchUserMetadata(user.uid).listen(
            (refreshTime) async {
              final user = ref.read(authRepositoryProvider).currentUser;

              if (refreshTime != null && user != null) {
                await user.forceRefreshIdToken();
              }
            },
          );
        }
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}

@Riverpod(keepAlive: true)
UserTokenRefreshService userTokenRefreshService(UserTokenRefreshServiceRef ref) {
  final service = UserTokenRefreshService(ref);
  ref.onDispose(service.dispose);
  return service;
}
