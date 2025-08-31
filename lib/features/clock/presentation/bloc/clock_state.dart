part of 'clock_cubit.dart';

class ClockState extends Equatable {
  final int hour;
  final int minute;
  final int day;
  final int month;
  final int year;
  final int weekday; 

  const ClockState({
    required this.hour,
    required this.minute,
    required this.day,
    required this.month,
    required this.year,
    required this.weekday, 
  });

  // Estado inicial
  factory ClockState.initial() {
    final now = DateTime.now();
    return ClockState(
      hour: now.hour,
      minute: now.minute,
      day: now.day,
      month: now.month,
      year: now.year,
      weekday: now.weekday, 
    );
  }

  ClockState copyWith({
    int? hour,
    int? minute,
    int? day,
    int? month,
    int? year,
    int? weekday, 
  }) {
    return ClockState(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      weekday: weekday ?? this.weekday,
    );
  }

  @override
  List<Object> get props => [hour, minute, day, month, year, weekday];
}