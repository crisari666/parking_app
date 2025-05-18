import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_event.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_state.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/daily_summary_card.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/financial_summary_card.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/widgets/current_closure_details.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';

@RoutePage()
class ClosurePage extends StatelessWidget {
  const ClosurePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => ClosureBloc(
        vehicleRepository: getIt(),
      )..add(GenerateDailyClosureRequested()),
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
            if (state is ClosureLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClosureSuccess) {
              // Get current day's logs
              final now = DateTime.now();
              final startOfDay = DateTime(now.year, now.month, now.day);
              final endOfDay = startOfDay.add(const Duration(days: 1));
              
              final currentDayLogs = state.closure.vehicleLogs.where((log) => 
                log.checkIn.isAfter(startOfDay) && 
                log.checkIn.isBefore(endOfDay)
              ).toList();

              return TabBarView(
                children: [
                  // Summary Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DailySummaryCard(closure: state.closure, l10n: l10n),
                        const SizedBox(height: 16),
                        FinancialSummaryCard(closure: state.closure, l10n: l10n),
                      ],
                    ),
                  ),
                  // Details Tab
                  CurrentClosureDetails(vehicleLogs: currentDayLogs, l10n: l10n),
                ],
              );
            } else if (state is ClosureError) {
              return Center(
                child: Text(
                  state.message,
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
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    ));
  }
} 