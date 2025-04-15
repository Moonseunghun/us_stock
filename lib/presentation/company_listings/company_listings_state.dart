import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/company_listing.dart';

part 'company_listings_state.freezed.dart';
part 'company_listings_state.g.dart';

@freezed
class CompanyListingsState with _$CompanyListingsState {
  const factory CompanyListingsState({
    //Default freezed 에서 제공하는것 null  값 허용
    @Default([])List<CompanyListing> compaines,
    @Default(false)bool isLoading,
    @Default(false)bool isRefreshing,
    @Default('')String searchQuery,
  }) = _CompanyListingsState;
  
  factory CompanyListingsState.fromJson(Map<String, Object?> json) => _$CompanyListingsStateFromJson(json);
}