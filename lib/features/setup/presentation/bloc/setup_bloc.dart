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
  double _carNightCost = 0.0;
  double _motorcycleNightCost = 0.0;
  double _studentMotorcycleHourCost = 0.0;

  SetupBloc({required this.localDatasource}) : super(SetupInitial()) {
    on<SetupStarted>(_onSetupStarted);
    on<SetupBusinessNameChanged>(_onBusinessNameChanged);
    on<SetupBusinessBrandChanged>(_onBusinessBrandChanged);
    on<SetupCarHourCostChanged>(_onCarHourCostChanged);
    on<SetupMotorcycleHourCostChanged>(_onMotorcycleHourCostChanged);
    on<SetupCarMonthlyCostChanged>(_onCarMonthlyCostChanged);
    on<SetupMotorcycleMonthlyCostChanged>(_onMotorcycleMonthlyCostChanged);
    on<SetupCarDayCostChanged>(_onCarDayCostChanged);
    on<SetupMotorcycleDayCostChanged>(_onMotorcycleDayCostChanged);
    on<SetupSubmitted>(_onSetupSubmitted);
  }

  Future<void> _onSetupStarted(SetupStarted event, Emitter<SetupState> emit) async {
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
  }

  void _onBusinessNameChanged(SetupBusinessNameChanged event, Emitter<SetupState> emit) {
    _businessName = event.name;
  }

  void _onBusinessBrandChanged(SetupBusinessBrandChanged event, Emitter<SetupState> emit) {
    _businessBrand = event.brand;
  }

  void _onCarHourCostChanged(SetupCarHourCostChanged event, Emitter<SetupState> emit) {
    _carHourCost = double.tryParse(event.cost) ?? 0.0;
  }

  void _onMotorcycleHourCostChanged(SetupMotorcycleHourCostChanged event, Emitter<SetupState> emit) {
    _motorcycleHourCost = double.tryParse(event.cost) ?? 0.0;
  }

  void _onCarMonthlyCostChanged(SetupCarMonthlyCostChanged event, Emitter<SetupState> emit) {
    _carMonthlyCost = double.tryParse(event.cost) ?? 0.0;
  }

  void _onMotorcycleMonthlyCostChanged(SetupMotorcycleMonthlyCostChanged event, Emitter<SetupState> emit) {
    _motorcycleMonthlyCost = double.tryParse(event.cost) ?? 0.0;
  }

  void _onCarDayCostChanged(SetupCarDayCostChanged event, Emitter<SetupState> emit) {
    _carDayCost = double.tryParse(event.cost) ?? 0.0;
  }

  void _onMotorcycleDayCostChanged(SetupMotorcycleDayCostChanged event, Emitter<SetupState> emit) {
    _motorcycleDayCost = double.tryParse(event.cost) ?? 0.0;
  }

  Future<void> _onSetupSubmitted(SetupSubmitted event, Emitter<SetupState> emit) async {
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
        motorcycleDayCost: _motorcycleDayCost,
        carNightCost: _carNightCost,
        motorcycleNightCost: _motorcycleNightCost,
        studentMotorcycleHourCost: _studentMotorcycleHourCost
      );
      await localDatasource.saveSetup(setup);
      emit(SetupSuccess(setup, isFromSave: true));
    } catch (e) {
      emit(SetupError(e.toString()));
    }
  }
} 