/// A PID controller.
/// Example usage:
/// ```dart
/// PIDController pidController = PIDController<double>(
/// kP: 200.0,
/// kI: 0.5,
/// kD: 100.0,
/// integralLimit: 400.0,
/// add: (a, b) => a + b,
/// subtract: (a, b) => a - b,
/// multiply: (a, b) => a * b,
/// zero: () => 0.0,
/// isSmall: (a) => a.abs() < 1,
/// initialValue: 0.0
/// );
/// ```
class PIDController<T> {
  T integralError;
  T previousError;
  double integralLimit;
  double kP, kI, kD;

  T _output;

  final T Function(T, T) add; // Function to add two values
  final T Function(T, T) subtract; // Function to subtract two values
  final T Function(T, double) multiply; // Function to multiply value by scalar
  final T Function() zero; // Function to return zero value of type T
  final T Function(T, double, double)
      clampLength; // Function to clamp value between two values
  final bool Function(T)
      isSmall; // Function to determine if value is small enough to stop

  PIDController({
    required this.kP,
    required this.kI,
    required this.kD,
    required this.integralLimit,
    required this.add,
    required this.subtract,
    required this.multiply,
    required this.zero,
    required this.clampLength,
    required this.isSmall,
    required T initialValue,
  })  : this.integralError = initialValue,
        this.previousError = initialValue,
        this._output = zero();

  void update(T currentError, double dt) {
    if (this.isSmall(currentError)) {
      // && this.isSmall(this.integralError)
      this.integralError = zero();
      this.previousError = zero();
      this._output = this.zero();
      return;
    }

    // Proportional
    T proportional = this.multiply(currentError, this.kP);

    // Integral
    T integral = this.zero();
    if (this.kI != 0) {
      this.integralError =
          this.add(this.integralError, this.multiply(currentError, dt));
      integral = this.multiply(this.integralError, this.kI);
    }

    // Integral windup limit
    if (this.integralLimit > 0) {
      this.integralError =
          this.clampLength(this.integralError, 0, this.integralLimit);
    }

    // Derivative
    T derivative = this.zero();
    if (this.kD != 0) {
      derivative = this.multiply(
          this.subtract(currentError, this.previousError), this.kD / dt);
    }

    // Update previous error for next iteration
    this.previousError = currentError;

    // Final PID output
    this._output = this.add(this.add(proportional, integral), derivative);
  }

  T get output => this._output;
}
