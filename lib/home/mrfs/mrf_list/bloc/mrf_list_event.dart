part of 'mrf_list_bloc.dart';

@immutable
abstract class MrfListEvent {
  const MrfListEvent();

  List<Object> get props => [];
}

class FetchMRFs extends MrfListEvent{
  final bool isApprovedMrf;

  const FetchMRFs({@required this.isApprovedMrf});
  @override
  List<Object> get props => [ isApprovedMrf];
}

class SearchMRFEvent extends MrfListEvent{
  final String query;

  const SearchMRFEvent({@required this.query});
  @override
  List<Object> get props => [ query];
}