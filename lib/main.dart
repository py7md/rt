import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // On Android, enable hybrid composition for better performance of WebViews
  if (ThemeData().platform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // Lock device orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system navigation/status bar style to match the cinematic dark theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0F0F14),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const GoldenCornerApp());
}

/// The main application configuration wrapper, setting up the premium
/// dark-gold cinematic design system.
class GoldenCornerApp extends StatelessWidget {
  const GoldenCornerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الركن الذهبي',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
        primaryColor: const Color(0xFFFFD700),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFFFC000),
          surface: Color(0xFF181822),
          background: const Color(0xFF0F0F14),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFFA0A0B0),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: const Color(0xFF181822),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0x33FFD700), width: 1.5),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/// A premium animated cinematic Splash Screen.
/// Runs for 3 seconds before transitioning to the HomeScreen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Set up cinematic zoom and fade animations for the logo
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // Navigate to the main home screen after exactly 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1E1E2C),
              Color(0xFF0F0F14),
              Color(0xFF08080C),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              
              // Animated Logo and Typography section
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    // Premium Golden Outer Ring with Placeholder Logo inside
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.15),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 2.0,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFFD700).withOpacity(0.1),
                            const Color(0xFFFF8C00).withOpacity(0.02),
                          ],
                        ),
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_3d.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                            // High-quality fallback design if the logo image is not yet loaded on disk
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                child: const Icon(
                                  Icons.star_rounded,
                                  size: 60,
                                  color: Color(0xFFFFD700),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Arabic Cinematic Typography
                    const Text(
                      'الركن الذهبي',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Color(0xFFFFD700),
                            blurRadius: 15,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'THE GOLDEN CORNER',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFD700),
                        letterSpacing: 4.0,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Custom Golden Progress Indicator
              const SizedBox(
                width: 45,
                height: 45,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                  backgroundColor: Color(0x22FFD700),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'شحن الفخامة والتميز...',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA0A0B0),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

/// The Main Screen hosting the premium WebView and offline handlers.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // WebView controls
  InAppWebViewController? _webViewController;
  PullToRefreshController? _pullToRefreshController;
  
  // Loading progress percentage (0 - 100)
  int _loadingProgress = 0;
  
  // Connection states
  bool _isConnected = true;
  late StreamSubscription _connectivitySubscription;

  // The targeted premium URL
  final String _targetUrl = "https://ai.studio/apps/f787a5a7-87e5-45aa-886d-c11032c0187e?fullscreenApplet=true";

  @override
  void initState() {
    super.initState();

    // Check connectivity status initially
    _checkInitialConnectivity();

    // Set up active connectivity listener supporting both legacy and v6 lists
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((dynamic result) {
      ConnectivityResult singleResult;
      if (result is List) {
        singleResult = result.isNotEmpty ? result.first : ConnectivityResult.none;
      } else {
        singleResult = result as ConnectivityResult;
      }
      _updateConnectionStatus(singleResult);
    });

    // Configure WebView's premium Pull-to-Refresh behavior
    _pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: const Color(0xFFFFD700),
        backgroundColor: const Color(0xFF181822),
      ),
      onRefresh: () async {
        if (_isConnected && _webViewController != null) {
          _webViewController!.reload();
        } else {
          _pullToRefreshController?.endRefreshing();
          _triggerRetry();
        }
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /// Initial network status probe
  Future<void> _checkInitialConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      ConnectivityResult result;
      if (connectivityResult is List) {
        result = connectivityResult.isNotEmpty ? connectivityResult.first : ConnectivityResult.none;
      } else {
        result = connectivityResult as ConnectivityResult;
      }
      _updateConnectionStatus(result);
    } catch (_) {
      // In case platform channel fails during loading
      setState(() {
        _isConnected = false;
      });
    }
  }

  /// Updates connection state and triggers WebView refresh if connection is restored
  void _updateConnectionStatus(ConnectivityResult result) {
    final bool newConnectedState = result != ConnectivityResult.none;
    if (newConnectedState != _isConnected) {
      setState(() {
        _isConnected = newConnectedState;
      });
      // If we just got connection back, reload WebView
      if (_isConnected && _webViewController != null) {
        _webViewController!.loadUrl(
          urlRequest: URLRequest(url: WebUri(_targetUrl)),
        );
      }
    }
  }

  /// Manually checks connection and attempts reload
  Future<void> _triggerRetry() async {
    await _checkInitialConnectivity();
    if (_isConnected && _webViewController != null) {
      _webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(_targetUrl)),
      );
    }
  }

  /// Standard Flutter PopScope Dialog to prompt user before exiting the application.
  Future<bool> _showExitDialog(BuildContext context) async {
    final bool? exitConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            textDirection: TextDirection.rtl,
            children: const [
              Icon(Icons.exit_to_app_rounded, color: Color(0xFFFFD700)),
              SizedBox(width: 10),
              Text(
                'تأكيد الخروج',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من أنك تريد إغلاق تطبيق الركن الذهبي؟',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              color: Color(0xFFA0A0B0),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFA0A0B0),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                elevation: 3,
                shadowColor: const Color(0xFFFFD700).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'خروج',
                style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
    return exitConfirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        
        final controller = _webViewController;
        if (controller != null && await controller.canGoBack()) {
          // If the WebView has backward steps, navigate backward
          await controller.goBack();
        } else {
          // Otherwise, display confirmation exit dialog
          final shouldExit = await _showExitDialog(context);
          if (shouldExit) {
            // Close the app process cleanly
            await SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Online WebView view vs. Offline screen
              _isConnected
                  ? InAppWebView(
                      initialUrlRequest: URLRequest(url: WebUri(_targetUrl)),
                      initialSettings: InAppWebViewSettings(
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                        javaScriptEnabled: true,
                        domStorageEnabled: true,
                        allowFileAccessFromFileURLs: true,
                        allowUniversalAccessFromFileURLs: true,
                        useHybridComposition: true,
                        allowsInlineMediaPlayback: true,
                        supportZoom: false,
                      ),
                      pullToRefreshController: _pullToRefreshController,
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          _loadingProgress = 0;
                        });
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          _loadingProgress = progress;
                        });
                        // End pull-to-refresh spinner when loading completes or is close
                        if (progress >= 95) {
                          _pullToRefreshController?.endRefreshing();
                        }
                      },
                      onLoadStop: (controller, url) async {
                        _pullToRefreshController?.endRefreshing();
                        setState(() {
                          _loadingProgress = 100;
                        });
                      },
                      onReceivedError: (controller, request, error) {
                        _pullToRefreshController?.endRefreshing();
                        // Optional handling for load failure errors
                      },
                    )
                  : NoInternetScreen(onRetry: _triggerRetry),

              // Elegant Gold Linear Progress Bar at the top of the WebView
              if (_isConnected && _loadingProgress < 100)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: PreferredSize(
                    preferredSize: const Size.fromHeight(3.5),
                    child: LinearProgressIndicator(
                      value: _loadingProgress / 100.0,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                      minHeight: 3.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A highly polished NoInternet fallback display screen in dark mode with gold gradients.
class NoInternetScreen extends StatefulWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0F0F14),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Elegant Glowing Disconnected Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF181822),
              border: Border.all(color: const Color(0x22FFD700), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.05),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 50,
              color: Color(0xFFFFD700),
            ),
          ),
          const SizedBox(height: 35),

          // Primary Arabic Header
          const Text(
            'عذراً، انقطع الاتصال بالإنترنت!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Secondary Description
          const Text(
            'يرجى التحقق من اتصال شبكة الواي فاي أو بيانات الهاتف والمحاولة مرة أخرى للوصول إلى الركن الذهبي.',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              color: Color(0xFFA0A0B0),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 45),

          // Glowing premium Gold Action Button with loading state
          SizedBox(
            width: 190,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFB300),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isChecking
                    ? null
                    : () async {
                        setState(() {
                          _isChecking = true;
                        });
                        widget.onRetry();
                        // Add a small artificial delay for premium feeling feedback
                        await Future.delayed(const Duration(milliseconds: 1200));
                        if (mounted) {
                          setState(() {
                            _isChecking = false;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isChecking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.refresh_rounded, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
