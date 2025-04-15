import 'package:us_stock/data/csv/company_listing_parser.dart';
import 'package:us_stock/data/mapper/company_mapper.dart';
import 'package:us_stock/data/source/local/stock_dao.dart';
import 'package:us_stock/domain/model/company_listing.dart';
import 'package:us_stock/domain/repository/stock_repository.dart';
import 'package:us_stock/utils/result.dart';

import '../source/remote/stock_api.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApi _api;
  final StockDao _dao;
  final _parser = CompanyListingParser();

  StockRepositoryImpl(this._api, this._dao);
  @override
  Future<Result<List<CompanyListing>>> getCompanyListings(bool fetchFromRemote, String query
      ) async{
    //캐시에서 찾는다
    final localListings = await _dao.searchCompanyListing(query);

    //없다면 리모트에서 가져옴
    final isDbEmpty = localListings.isEmpty && query.isEmpty;
    final shouldJustLoadFromCahce = !isDbEmpty && !fetchFromRemote;

    //캐시
    if(shouldJustLoadFromCahce) {
      return Result.success(localListings.map((e) => e.toCompanyListing()).toList());
    };

    //리모트
    try{
      final response = await _api.getListings();
      final remoteListings = await _parser.parse(response.body);
      //캐시 비우기
      await _dao.clearCompanyListings();

      //캐시 추가
      await _dao.insertCompanyListing(
        remoteListings.map((e) => e.toCompanyListingEntity()).toList()
      );
      //todo csv 파싱이 필요함
      return Result.success(remoteListings);
    } catch (e) {
      return Result.error(Exception('데이터 로드 실패'));
    }
  }

}