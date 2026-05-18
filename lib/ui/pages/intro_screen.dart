import 'package:flutter/material.dart';
import 'package:medicine_tracker/ui/ui_config.dart';
import 'package:medicine_tracker/ui/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_tracker/bloc/medicine_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1500),
    );

    _fadeAnim =
        Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.easeIn),
    );

    _scaleAnim =
        Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3),
        () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<MedicineBloc>(),
              child: const HomePage(),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                                alpha: 0.15),
                        blurRadius: 20,
                        offset:
                            const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // App name
                const Text(
                  'MediTrack',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your daily medicine companion',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                        .withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 60),
                // Loading indicator
                SizedBox(
                  width: 32,
                  height: 32,
                  child:
                      CircularProgressIndicator(
                    color: Colors.white
                        .withValues(alpha: 0.7),
                    strokeWidth: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
