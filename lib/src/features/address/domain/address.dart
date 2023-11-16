import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  @override
  List<Object?> get props => [
        address,
        city,
        state,
        postalCode,
        country,
      ];
}
