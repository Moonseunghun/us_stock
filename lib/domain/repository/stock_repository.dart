import 'package:us_stock/domain/model/company_listing.dart';
import 'package:us_stock/utils/result.dart';

abstract class StockRepository {
  Future<Result<List<CompanyListing>>> getCompanyListings(
      bool fetchFromRemote,
      String query,
  );
}