import 'package:hive/hive.dart';
import 'package:us_stock/data/source/local/company_listing_entity.dart';

class StockDao {
  static const companyListing = 'companyListing';

  //hive 에서 데이터 저장하는걸 대부분 box라고 칭함
  final box = Hive.box('stock_db');

  // 추가할 데이터 로직
  Future<void> insertCompanyListing(
    List<CompanyListingEntity> CompanyListingEntity,
  ) async {
    await box.put(companyListing, CompanyListingEntity);
  }

  // clear 할 데이터 로직
  Future clearCompanyListings() async {
    await box.clear();
  }

  Future<List<CompanyListingEntity>> searchCompanyListing(String query) async {
    final List<CompanyListingEntity> companyListing = box.get(
      StockDao.companyListing,
      defaultValue: [],
    );

    return companyListing
        .where(
          (e) =>
              e.name.toLowerCase().contains(query.toLowerCase()) ||
              query.toUpperCase() == e.symbol,
        )
        .toList();
  }
}
