import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/event.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/state.dart';
import 'package:flutter/services.dart';

class OtpWidget extends StatefulWidget {
  final String email;

  const OtpWidget({super.key, required this.email});

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  String otpCode = '';
  bool isComplete = false;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);

    _startResendCountdown();
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 30;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 4) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _updateOtpCode();
  }

  void _updateOtpCode() {
    setState(() {
      otpCode = _controllers.map((c) => c.text).join();
      isComplete = otpCode.length == 5;
    });

    if (isComplete) {
      _submitOtp();
    }
  }

  void _submitOtp() {
    context.read<AuthBloc>().add(OtpSubmitted(widget.email, otpCode));
  }

  void _resendOtp() {
    if (_resendCountdown == 0) {
      // Add resend OTP event to your bloc
      // context.read<AuthBloc>().add(ResendOtp(widget.email));
      _startResendCountdown();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP resent successfully'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    _buildHeader(isDark),
                    const SizedBox(height: 60),
                    _buildOtpForm(isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.security_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.6)
                      : const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
            children: [
              const TextSpan(text: 'We sent a 5-digit code to\n'),
              TextSpan(
                text: widget.email,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpForm(bool isDark) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? otpError;

        if (state is OTPErrorState) {
          otpError = state.message;
        }

        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF374151),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildOtpFields(isDark),
              const SizedBox(height: 24),
              if (otpError != null) _buildErrorMessage(otpError),
              const SizedBox(height: 32),
              _buildVerifyButton(),
              const SizedBox(height: 24),
              _buildResendSection(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtpFields(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return Container(
          width: 56,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  _controllers[index].text.isNotEmpty
                      ? const Color(0xFFF59E0B)
                      : isDark
                      ? Colors.white.withOpacity(0.1)
                      : const Color(0xFFE5E7EB),
              width: _controllers[index].text.isNotEmpty ? 2 : 1,
            ),
            color:
                _controllers[index].text.isNotEmpty
                    ? const Color(0xFFF59E0B).withOpacity(0.1)
                    : Colors.transparent,
          ),
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _onCodeChanged(index, value),
            onTap: () {
              _controllers[index].selection = TextSelection.fromPosition(
                TextPosition(offset: _controllers[index].text.length),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56,
      child: ElevatedButton(
        onPressed: (isComplete) ? _submitOtp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: const Color(0xFF9CA3AF),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFFEF6C00);
            }
            if (states.contains(MaterialState.disabled)) {
              return const Color(0xFF9CA3AF);
            }
            return const Color(0xFFF59E0B);
          }),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_outlined, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Verify Code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendSection(bool isDark) {
    return Column(
      children: [
        if (_resendCountdown > 0)
          Text(
            'Resend code in ${_resendCountdown}s',
            style: TextStyle(
              fontSize: 14,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.5)
                      : const Color(0xFF9CA3AF),
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the code? ",
                style: TextStyle(
                  fontSize: 14,
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF6B7280),
                ),
              ),
              TextButton(
                onPressed: _resendOtp,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 0,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Resend',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            size: 16,
            color:
                isDark
                    ? Colors.white.withOpacity(0.6)
                    : const Color(0xFF6B7280),
          ),
          label: Text(
            'Back to Login',
            style: TextStyle(
              fontSize: 14,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.6)
                      : const Color(0xFF6B7280),
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
