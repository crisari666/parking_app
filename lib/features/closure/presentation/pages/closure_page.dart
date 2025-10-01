import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_event.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_state.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/closure_date_selector.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/daily_summary_card.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/financial_summary_card.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/current_closure_details.dart';
// esimport 'package:quantum_parking_flutter/features/closure/presentation/widgets/closure_date_selector.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/core/utils/date_time_service.dart';
import 'package:quantum_parking_flutter/core/utils/date_time_extensions.dart';

@RoutePage()
class ClosurePage extends StatefulWidget {
  const ClosurePage({super.key});

  @override
  State<ClosurePage> createState() => _ClosurePageState();
}

class _ClosurePageState extends State<ClosurePage> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTimeService.now();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => ClosureBloc(
        vehicleRepository: getIt(),
      )..add(GenerateDailyClosureRequested())..add(GetFinancialResumeByDate(selectedDate)),
      child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.dailyClosure),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.summary),
              Tab(text: l10n.details),
            ],
          ),
        ),
        body: BlocBuilder<ClosureBloc, ClosureState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status.isSuccess) {
              // Get selected day's logs
              final startOfDay = selectedDate.startOfDay;
              final endOfDay = startOfDay.add(const Duration(days: 1));
              
              final selectedDayLogs = state.closure?.vehicleLogs.where((log) => 
                log.checkIn.isAfter(startOfDay) && 
                log.checkIn.isBefore(endOfDay)
              ).toList();

              return Column(
                children: [
                  ClosureDateSelector(
                    selectedDate: selectedDate,
                    onDateChanged: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                      context.read<ClosureBloc>().add(GetClosureDataByDate(date));
                      context.read<ClosureBloc>().add(GetFinancialResumeByDate(date));
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Summary Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DailySummaryCard(
                                closure: state.closure, 
                                financialResume: state.financialResume,
                                l10n: l10n
                              ),
                              const SizedBox(height: 16),
                              FinancialSummaryCard(
                                closure: state.closure, 
                                financialResume: state.financialResume,
                                l10n: l10n
                              ),
                            ],
                          ),
                        ),
                        // Details Tab
                        CurrentClosureDetails(vehicleLogs: selectedDayLogs!, l10n: l10n),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state.status.isError) {
              return Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return Center(
              child: Text(l10n.noData),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<ClosureBloc>().add(GenerateDailyClosureRequested());
            context.read<ClosureBloc>().add(GetFinancialResumeByDate(selectedDate));
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    ));
  }
} 