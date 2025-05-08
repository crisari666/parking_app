import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/setup_local_datasource.dart';
import '../../data/models/business_setup_model.dart';
import 'setup_event.dart';
import 'setup_state.dart';  

// Bloc
class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final SetupLocalDatasource localDatasource;
  String _businessName = '';
  String _businessBrand = '';
  double _carHourCost = 0.0;
  double _motorcycleHourCost = 0.0;
  double _carMonthlyCost = 0.0;
  double _motorcycleMonthlyCost = 0.0;
  double _carDayCost = 0.0;
  double _motorcycleDayCost = 0.0;

  SetupBloc({required this.localDatasource}) : super(SetupInitial()) {
    // Load initial data
    on<SetupStarted>((event, emit) async {
      emit(SetupLoading());
      try {
        final setup = await localDatasource.getSetup();
        if (setup != null) {
          _businessName = setup.businessName;
          _businessBrand = setup.businessBrand;
          _carHourCost = setup.carHourCost;
          _motorcycleHourCost = setup.motorcycleHourCost;
          _carMonthlyCost = setup.carMonthlyCost;
          _motorcycleMonthlyCost = setup.motorcycleMonthlyCost;
          _carDayCost = setup.carDayCost;
          _motorcycleDayCost = setup.motorcycleDayCost;
          emit(SetupSuccess(setup, isFromSave: false));
        } else {
          emit(const SetupSuccess(null, isFromSave: false));
        }
      } catch (e) {
        emit(SetupError(e.toString()));
      }
    });

    on<SetupBusinessNameChanged>((event, emit) {
      _businessName = event.name;
    });

    on<SetupBusinessBrandChanged>((event, emit) {
      _businessBrand = event.brand;
    });

    on<SetupCarHourCostChanged>((event, emit) {
      _carHourCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<SetupMotorcycleHourCostChanged>((event, emit) {
      _motorcycleHourCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<SetupCarMonthlyCostChanged>((event, emit) {
      _carMonthlyCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<SetupMotorcycleMonthlyCostChanged>((event, emit) {
      _motorcycleMonthlyCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<SetupCarDayCostChanged>((event, emit) {
      _carDayCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<SetupMotorcycleDayCostChanged>((event, emit) {
      _motorcycleDayCost = double.tryParse(event.cost) ?? 0.0;
    });

    on<SetupSubmitted>((event, emit) async {
      emit(SetupLoading());
      try {
        final setup = BusinessSetupModel(
          businessName: _businessName,
          businessBrand: _businessBrand,
          carHourCost: _carHourCost,
          motorcycleHourCost: _motorcycleHourCost,
          carMonthlyCost: _carMonthlyCost,
          motorcycleMonthlyCost: _motorcycleMonthlyCost,
          carDayCost: _carDayCost,
          motorcycleDayCost: _motorcycleDayCost
        );
        await localDatasource.saveSetup(setup);
        emit(SetupSuccess(setup, isFromSave: true));
      } catch (e) {
        emit(SetupError(e.toString()));
      }
    });
  }
} 