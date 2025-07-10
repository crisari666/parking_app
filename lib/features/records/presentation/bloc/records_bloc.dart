import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';
import 'package:quantum_parking_flutter/core/services/ticket_printer_service.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';

// Bloc
class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  final VehicleRepository _vehicleRepository;
  final TicketPrinterService _ticketPrinterService;
  final SetupLocalDatasource _setupLocalDatasource;

  RecordsBloc({
    required VehicleRepository vehicleRepository,
    required TicketPrinterService ticketPrinterService,
    required SetupLocalDatasource setupLocalDatasource,
  }) : _vehicleRepository = vehicleRepository,
       _ticketPrinterService = ticketPrinterService,
       _setupLocalDatasource = setupLocalDatasource,
       super(RecordsState.initial()) {
    on<SearchPlateNumberChanged>(_searchPlateNumberChanged);
    on<LoadRecordsRequested>(_loadRecords);
    on<GetVehicleLogsRequested>(_getVehicleLogs);
    on<PrintRecordTicketRequested>(_printRecordTicket);
  }

  Future<void> _searchPlateNumberChanged(SearchPlateNumberChanged event, Emitter<RecordsState> emit) async {
    if (event.plateNumber.isEmpty) {
      emit(RecordsState.success(const[]));
      return;
    }

    emit(RecordsState.loading());
    try {
      final vehicle = await _vehicleRepository.getVehicle(event.plateNumber);
      if (vehicle != null) {
        final record = VehicleRecord(
          plateNumber: vehicle.plateNumber,
          vehicleType: vehicle.vehicleType,
          checkIn: vehicle.checkIn,
          checkOut: vehicle.checkOut,
          totalCost: vehicle.totalCost,
          paymentMethod: vehicle.paymentMethod,
        );
        emit(RecordsState.success([record]));
      } else {
        emit(RecordsState.success(const []));
      }
    } catch (e) {
      emit(RecordsState.error('Error searching for vehicle: ${e.toString()}'));
    }
  }

  Future<void> _loadRecords(LoadRecordsRequested event, Emitter<RecordsState> emit) async {
    emit(state.copyWith(isLoadingLogs: true));
    try {
      //final vehicles = await _vehicleRepository.getAllVehicles();
      final activeVehicles = await _vehicleRepository.getActiveVehicles();
      emit(state.copyWith(
        status: RecordsStatus.success,
        logs: activeVehicles,
        isLoadingLogs: false,
      ));
    } catch (e) {
      emit(RecordsState.error(e.toString()));
    }
  }

  Future<void> _getVehicleLogs(GetVehicleLogsRequested event, Emitter<RecordsState> emit) async {
    emit(state.copyWith(status: RecordsStatus.loading));
    
    try {
      final vehicleLogs = await _vehicleRepository.getVehicleLogs(event.plateNumber);      
      emit(state.copyWith(
        status: RecordsStatus.success,
        vehicleLogs: vehicleLogs,
      ));
    } catch (e) {
      emit(RecordsState.error(e.toString()));
    }
  }

  Future<void> _printRecordTicket(PrintRecordTicketRequested event, Emitter<RecordsState> emit) async {
    try {
      // Get business setup
      final businessSetup = await _setupLocalDatasource.getSetup();
      if (businessSetup == null) {
        emit(RecordsState.error('Configuración de negocio no encontrada. Por favor, verifique la configuración primero.'));
        return;
      }

      // Use the centralized ticket printer service
      final success = await _ticketPrinterService.printRecordTicket(
        record: event.record,
        businessSetup: businessSetup,
      );

      if (success) {
        emit(state.copyWith(
          status: RecordsStatus.success,
          errorMessage: 'Ticket de registro impreso correctamente para ${event.record.vehicleId.plateNumber}',
        ));
      } else {
        emit(RecordsState.error('Error al imprimir el ticket: No se pudo conectar con la impresora'));
      }
    } catch (e) {
      emit(RecordsState.error('Error al imprimir el ticket: $e'));
    }
  }
}   