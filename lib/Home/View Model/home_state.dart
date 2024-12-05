part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class GetCurrentLocation extends HomeState {}
final class GetAddressFromCoordinates extends HomeState {}
final class GetAddressFromMapLink extends HomeState {}
