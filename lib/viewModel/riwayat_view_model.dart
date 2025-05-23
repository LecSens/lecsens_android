import 'package:flutter/cupertino.dart';
import 'package:lecsens/data/response/status.dart';
import 'package:lecsens/data/response/query_response.dart';
import 'package:lecsens/repository/riwayat_repository.dart';
import 'package:lecsens/models/lecsens_data_model.dart';
import 'package:lecsens/repository/home_repository.dart';
import 'package:lecsens/utils/utils.dart';
import 'package:lecsens/viewModel/user_view_model.dart';

class RiwayatViewModel with ChangeNotifier {
  final _riwayatRepository = RiwayatRepository();
  final _homeRepository = HomeRepository();
  bool _fetchingData = false;
  final String _macAddress = '00:00:00:00:00:00';
  int _page = 1;
  QueryResponse<LecsensDataList> voltametryDataListResponse = QueryResponse.loading();
  List<LecsensData> _voltametryDataList = <LecsensData>[];

  get fetchingData => _fetchingData;
  get dataList => _voltametryDataList;

  void setFetchingData(bool value) {
    _fetchingData = value;
    notifyListeners();
  }

  void setPage(int page) {
    _page = page;
    notifyListeners();
  }

  void setLecsensDataList(QueryResponse response) {
    if (response.status == Status.completed && response.data != null) {
      _voltametryDataList = response.data;
    } else {
      _voltametryDataList = <LecsensData>[];
    }
    notifyListeners();
  }

  void setLecsensDataListQuery(BuildContext context, String filter) async {
    setLecsensDataList(QueryResponse.loading());
    final userViewModel = UserViewModel();
    final user = await userViewModel.getCurrentUser();

    if (user != null) {
      setFetchingData(true);
    _homeRepository.fetchAllLecsensData().then((value) {
        setFetchingData(false);
        try {
          List<LecsensData> lecsensDataList = <LecsensData>[];

          switch(filter.toLowerCase()) {
            case 'mikroplastik':
              lecsensDataList = value.getMikroplastikData();
              break;
            case 'timbal':
              lecsensDataList = value.getTimbalData();
              break;
            case 'merkuri':
              lecsensDataList = value.getMerkuriData();
              break;
            case 'kadmium':
              lecsensDataList = value.getKadmiumData();
              break;
            case 'arsen':
              lecsensDataList = value.getArsenData();
              break;
            default:
              break;
          }

          setLecsensDataList(QueryResponse.completed(lecsensDataList));
          notifyListeners();
        } catch (e) {
          Utils.showSnackBar(context, 'Failed to parse voltametry data.');
          print(e.toString());
          setLecsensDataList(QueryResponse.error('Failed to parse voltametry data.'));
        }
      }).onError((error, stackTrace) {
        setFetchingData(false);
        Utils.showSnackBar(context, error.toString());
        setLecsensDataList(QueryResponse.error(error.toString()));
      });
    }
  }
}
