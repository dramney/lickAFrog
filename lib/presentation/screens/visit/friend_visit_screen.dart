import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/visit/visit_bloc.dart';
import 'package:frog/domain/blocs/visit/visit_event.dart';
import 'package:frog/domain/blocs/visit/visit_state.dart';
import 'package:frog/presentation/screens/visit/widgets/frog_lick.dart';
import 'package:frog/presentation/screens/visit/widgets/frog_rainbow.dart';
import 'package:frog/presentation/screens/visit/widgets/frog_rainbow_reversed.dart';
import 'package:frog/presentation/screens/visit/widgets/frog_reversed.dart';
import 'package:frog/presentation/screens/visit/widgets/grass_tea.dart';
import 'package:frog/presentation/widgets/frog_logo.dart';


class FriendVisitScreen extends StatefulWidget {
  final String friendId;
  final String friendName;

  const FriendVisitScreen({
    super.key,
    required this.friendId,
    required this.friendName,
  });

  @override
  _FriendVisitScreenState createState() => _FriendVisitScreenState();
}

class _FriendVisitScreenState extends State<FriendVisitScreen> with TickerProviderStateMixin {
  bool _isLicking = false;
  bool _showRainbow = false;
  bool _isLickButtonEnabled = true;
  bool _showLickedMessage = false;
  Timer? _lickTimer;
  Timer? _rainbowTimer;
  Timer? _messageTimer;

  // Animation controllers
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Your frog name (to be loaded from auth state)
  String _myFrogName = 'Mio'; // Default value, should be replaced with actual user's frog name

  @override
  void initState() {
    super.initState();
    // Load friend visit data when screen opens
    context.read<VisitBloc>().add(LoadVisitData(widget.friendId, widget.friendName));

    // Initialize animation controllers
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _lickTimer?.cancel();
    _rainbowTimer?.cancel();
    _messageTimer?.cancel();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleLick() {
    if (!_isLickButtonEnabled) return;

    setState(() {
      _isLicking = true;
      _isLickButtonEnabled = false;
    });

    // Show rainbow effect after short delay
    _rainbowTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _showRainbow = true;
      });
    });

    // Send lick event to backend
    context.read<VisitBloc>().add(LickFriend(widget.friendId));

    // Show licked message after animation (for 4th screen)
    _messageTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLickedMessage = true;
          _showRainbow = false;
        });
      }
    });

    // Reset state after animation completes
    _lickTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isLicking = false;
          _showRainbow = false;
          _showLickedMessage = false;
          _isLickButtonEnabled = true;
        });
      }
    });
  }

  void _startLick() {
    _bounceController.forward();
    setState(() {
      _isLicking = true;
    });
  }

  void _finishLick() {
    _bounceController.reverse();
    _handleLick();
  }

  void _cancelLick() {
    _bounceController.reverse();
    setState(() {
      _isLicking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitBloc, VisitState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFB5D99C),
          appBar: AppBar(
            backgroundColor: Color(0xFFB5D99C),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'В гостях у ${widget.friendName}',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Stack(
            children: [
              // Background rainbow overlay when showing rainbow effect
              if (_showRainbow)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red,
                          Colors.orange,
                          Colors.yellow,
                          Colors.green,
                          Colors.blue,
                          Colors.purple,
                        ],
                      ),
                    ),
                  ),
                ),

              // Main content
              _buildMainContent(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(VisitState state) {
    if (state is VisitLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is VisitError) {
      return Center(child: Text(state.message));
    } else if (state is VisitLoaded) {
      return Column(
        children: [
          // Visit counter or licked message
          if (_showLickedMessage)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Ви лизнули жабу ${widget.friendName}!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Було дружніх ${state.visitCount} візитів',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

          // Frogs container
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // GrassLogo background - only when not showing rainbow effect
                if (!_showRainbow)
                  const Center(
                    child: GrassLogoT(size: 300),
                  ),

                // "Now you're gay!" text
                if (_showRainbow)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    child: Text(
                      "Now you're gay!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 4, color: Colors.black),
                          Shadow(blurRadius: 10, color: Colors.black45),
                        ],
                      ),
                    ),
                  ),

                // Frogs side by side
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left frog (friend)
                      if (!_showRainbow || _showRainbow)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Only show name when not in rainbow effect
                            if (!_showRainbow)
                              Text(
                                widget.friendName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            SizedBox(height: 8),
                            _showRainbow
                                ? FrogRainbowRev(size: 80)
                                : FrogLogoRev(size: 80),
                          ],
                        ),
                      SizedBox(width: 60),

                      // Right frog (me)
                      if (!_showRainbow || _showRainbow)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Only show name when not in rainbow effect
                            if (!_showRainbow)
                              Text(
                                _myFrogName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onPanStart: (_) => _startLick(),
                              onPanEnd: (_) => _finishLick(),
                              onPanCancel: () => _cancelLick(),
                              child: AnimatedBuilder(
                                animation: _bounceAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _bounceAnimation.value,
                                    child: child,
                                  );
                                },
                                child: _showRainbow
                                    ? FrogRainbow(size: 80)
                                    : (_isLicking ? FrogLick(size: 80) : FrogLogo(size: 80)),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lick button
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
              onPressed: _isLickButtonEnabled ? _handleLick : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF79A666),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text('Лизнути!', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      );
    }

    // Default empty state
    return Center(child: Text('Немає даних'));
  }
}