import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _slides = <_WelcomeSlideData>[
    _WelcomeSlideData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBqwzSjyJvBa3KHt3KHBoU-DKXWYVPMVLL8bG3-PqjhYD093tYik9NfJUPJyw4JJ5NAIadF6bmdYVHwBUKZeN9vRAX2hJRa8xTy3fBeX1haTgz0pHbpFx3yLw0CVFRoKPpnDzeUG3YzHNkk92ENVNvn7nqgwVwtlGR9wBowFw9pKlas1QpLql0KZuQfLRfV4WEfMKKM2F7eR_oODy6gR0XNiPH1Hh6nDlMCzYelcAhUUV3F68DIbbIe4eQWltbDYn_Hl1lu7FbJJyNO',
      title: 'Track Your Carbon Footprint',
      subtitle:
          'Monitor your daily impact and visualize your carbon reduction in real-time.',
    ),
    _WelcomeSlideData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCoXFtNu1jAs3PHZSK6kWAyWGX_ZamLTN8pH8qlGI45g09kMkX-vxzKq2gLHsrlScQURukGC9QY9lXmUNDjuwfFZW2BZuTSnCUJ9FyOw3zJWDhgTQh7AlXedPY7xVIp1WJNsZiqdWvTys99prY0fDY-84zzltHZK1eAEsK_WpIc43SLfrUyxhag2nTWNqlwSrY_c7hiWA0iE6-2VPKvQwLNXf3ie1ScTpL-UKHAZceoFbnEdmhDV-egECiLhLP5VWBYQfGEqBF-eCXa',
      title: 'Complete Quests, Earn EcoCoins',
      subtitle:
          'Gamify your life. Collect EcoCoins for every sustainable choice you make.',
    ),
    _WelcomeSlideData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDYGHOtDcCG2PzNg2keNoqI5DrIYYmeH0gGf1MAJGdkcCEgNfLUOo69T5LEI2hu63r_Gj6f0P6CL41JSZj8JrWGrKn2kdVBBUg81R-P85Se-J7WpWgXGXZXRTxZU03UT0ehWzJUX1a8wQqQDUmaSVCbi6cfGcDj2FvmeEDCyR6CvZNu0E6fBxqNAQr93_oglyTQQoHfww3A_dK5Skaop4axwmw-dwR2YPohnmZShh1MWMDTpfuz_mIKTOZHySRtB7wxIX_iDLfBS943',
      title: 'Join the Local Eco-Revolution',
      subtitle:
          'Connect with your community and compete with neighbors in local challenges.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.eco, color: AppColors.primary, size: 32),
                          const SizedBox(width: 8),
                          Text(
                            'EcoVerseX',
                            style: AppTheme.headlineSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(999),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.public,
                                color: AppColors.primary, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '10k+ Actions taken today',
                              style: AppTheme.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: _slides.length,
                          onPageChanged: (i) => setState(() => _page = i),
                          itemBuilder: (context, index) {
                            final slide = _slides[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                              child: _WelcomeSlide(slide: slide),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: i == _page ? 22 : 6,
                            decoration: BoxDecoration(
                              color: i == _page
                                  ? AppColors.primary
                                  : Colors.white.withOpacity(0.28),
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: i == _page
                                  ? [
                                      BoxShadow(
                                        color:
                                            AppColors.primary.withOpacity(0.35),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.backgroundDark,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Create Account',
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Already a member? Log In',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeSlideData {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _WelcomeSlideData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

class _WelcomeSlide extends StatelessWidget {
  final _WelcomeSlideData slide;

  const _WelcomeSlide({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(slide.imageUrl, fit: BoxFit.cover),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.backgroundDark.withOpacity(0.92),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: AppTheme.displaySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: AppTheme.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.70),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
