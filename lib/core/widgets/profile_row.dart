import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../themes/colors.dart';
import '../utils/constants.dart';

class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
    required this.user,
  });

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 24,
          foregroundImage:
              user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              user.name,
              style: const TextStyle(
                color: black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            if (!user.roles.contains(superAdminRole))
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.location_pin,
                    color: grayTertiary,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Warehouse Location',
                    style: const TextStyle(
                      color: grayTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
          ],
        ),
      ],
    );
  }
}
