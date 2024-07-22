
import 'package:finny/src/connections/plaid_item_dto.dart';

class PlaidItemsListDto {
  final List<PlaidItemDto> items;

  PlaidItemsListDto({required this.items});

  factory PlaidItemsListDto.fromJson(Map<String, dynamic> json) {
    return PlaidItemsListDto(
      items: (json['items'] as List)
          .map((item) => PlaidItemDto.fromJson(item))
          .toList(),
    );
  }
}
