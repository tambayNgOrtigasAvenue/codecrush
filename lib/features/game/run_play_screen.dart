import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/database/database_helper.dart';
import '../../app/database/player_progress.dart';
import '../../app/settings/app_settings.dart';
import '../../app/theme/app_colors.dart';

// ── Word pool ─────────────────────────────────────────────────────────────────
const _targets = <String>[
  'capsule', 'runner', 'speed', 'forest', 'jump', 'galaxy', 'pixel',
  'orbit', 'signal', 'rocket', 'trail', 'energy', 'planet', 'crystal',
  'charge', 'meter', 'boost', 'shield', 'combo', 'victory', 'binary',
  'syntax', 'widget', 'buffer', 'compile', 'deploy', 'matrix', 'vector',
  'server', 'client', 'router', 'stream', 'socket', 'thread', 'memory',
  'packet', 'engine', 'script', 'plugin', 'module', 'layout', 'canvas',
  'render', 'shader', 'sprite', 'object', 'method', 'string', 'number',
  'boolean', 'array', 'queue', 'stack', 'graph', 'domain', 'network',
  'cloud', 'system', 'kernel', 'device', 'launch', 'portal', 'cipher',
  'agent', 'token', 'cache', 'proxy', 'fiber', 'delta', 'alpha',
];

// ── Character definitions ─────────────────────────────────────────────────────
class _Character {
  const _Character({required this.emoji, required this.color});
  final String emoji;
  final Color color;
}

const _characters = [
  _Character(emoji: '🐝', color: Color(0xFFF5DA7E)),
  _Character(emoji: '🌸', color: Color(0xFFF694BB)),
  _Character(emoji: '🐟', color: Color(0xFF5CD6FF)),
  _Character(emoji: '🐸', color: Color(0xFF7AE582)),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class RunPlayScreen extends StatefulWidget {
  const RunPlayScreen({super.key});

  @override
  State<RunPlayScreen> createState() => _RunPlayScreenState();
}

class _RunPlayScreenState extends State<RunPlayScreen>
    with TickerProviderStateMixin {
  static const _durationSeconds = 60;

  final _inputCtrl = TextEditingController();
  final _focusNode = FocusNode();
  final _rng = Random();

  // Game state
  Timer? _gameTimer;
  int _secondsLeft = _durationSeconds;
  bool _running = false;
  int _correct = 0;
  int _incorrect = 0;
  String _currentTarget = '';
  bool _submitting = false;
  Color _wordColor = Colors.white;

  // Animations
  late final AnimationController _bgCtrl;
  late final AnimationController _bounceCtrl;
  late final AnimationController _flashCtrl;
  late final Animation<double> _bounceAnim;
  late final Animation<double> _flashAnim;

  @override
  void initState() {
    super.initState();
    _pickTarget();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );

    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flashAnim = Tween<double>(begin: 0, end: 1).animate(_flashCtrl);
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _inputCtrl.dispose();
    _focusNode.dispose();
    _bgCtrl.dispose();
    _bounceCtrl.dispose();
    _flashCtrl.dispose();
    super.dispose();
  }

  void _pickTarget() {
    _currentTarget = _targets[_rng.nextInt(_targets.length)];
  }

  void _startTimer() {
    if (_running) return;
    _running = true;
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
        _focusNode.unfocus();
        _saveHistory();
        _showGameOverDialog();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  void _resetGame() {
    _gameTimer?.cancel();
    setState(() {
      _secondsLeft = _durationSeconds;
      _running = false;
      _correct = 0;
      _incorrect = 0;
      _submitting = false;
      _wordColor = Colors.white;
      _inputCtrl.clear();
      _pickTarget();
    });
  }

  void _onChanged(String value) {
    if (_submitting || _secondsLeft == 0) return;
    if (value.isNotEmpty && !_running) _startTimer();

    final trimmed = value.trimRight();
    final exactMatch = trimmed == _currentTarget;
    final spaceSubmit = value.endsWith(' ');

    if (exactMatch || spaceSubmit) {
      _submitWord(exactMatch ? trimmed : value.trim());
    }
  }

  void _submitWord(String word) {
    if (_submitting || _secondsLeft == 0) return;
    _submitting = true;

    final isCorrect = word.trim() == _currentTarget;

    // Flash feedback
    _wordColor = isCorrect ? Colors.greenAccent : Colors.redAccent;
    _flashCtrl.forward(from: 0).then((_) {
      if (mounted) {
        _flashCtrl.reverse().then((_) {
          if (mounted) setState(() => _wordColor = Colors.white);
        });
      }
    });

    setState(() {
      if (isCorrect) {
        _correct++;
      } else {
        _incorrect++;
      }
      _pickTarget();
    });

    _inputCtrl.clear();
    Future.microtask(() => _submitting = false);
  }

  int _wpm() {
    final elapsed = _durationSeconds - _secondsLeft;
    if (elapsed <= 0) return 0;
    return (_correct / (elapsed / 60)).floor();
  }

  int _accuracy() {
    final total = _correct + _incorrect;
    if (total == 0) return 100;
    return ((_correct / total) * 100).round();
  }

  Future<void> _saveHistory() async {
    final speed = _wpm();
    if (speed == 0) return;
    final existing = await DatabaseHelper.instance.getProgress('run_mode');
    if (existing == null || speed > existing.score) {
      await DatabaseHelper.instance.insertOrUpdateProgress(
        PlayerProgress(
          lessonId: 'run_mode',
          score: speed,
          isCompleted: true,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _GameOverDialog(
        speed: _wpm(),
        accuracy: _accuracy(),
        correct: _correct,
        incorrect: _incorrect,
        onBack: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        onPlayAgain: () {
          Navigator.of(context).pop();
          _resetGame();
        },
      ),
    );
  }

  String _formatTime(int s) =>
      '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final charIdx = settings.characterIndex % _characters.length;
    final player = _characters[charIdx];
    final opponent = _characters[(charIdx + 1) % _characters.length];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // HUD
            _RunHUD(
              timeLabel: _formatTime(_secondsLeft),
              onBack: () => Navigator.of(context).pop(),
              onReset: _resetGame,
            ),
            const SizedBox(height: 6),
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _StatsRow(
                correct: _correct,
                incorrect: _incorrect,
                accuracy: _accuracy(),
                speed: _wpm(),
              ),
            ),
            const SizedBox(height: 10),
            // Animated game scene
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedBuilder(
                animation: _bgCtrl,
                builder: (_, __) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      child: CustomPaint(
                        painter: _ScenePainter(scroll: _bgCtrl.value),
                        child: Stack(
                          children: [
                            // Word label top-right
                            Positioned(
                              top: 12,
                              right: 14,
                              child: AnimatedBuilder(
                                animation: _flashAnim,
                                builder: (_, __) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _wordColor.withValues(
                                          alpha: 0.6,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      _currentTarget,
                                      style: TextStyle(
                                        color: _wordColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Player character (bouncing)
                            Positioned(
                              bottom: 40,
                              left: 50,
                              child: AnimatedBuilder(
                                animation: _bounceAnim,
                                builder: (_, __) => Transform.translate(
                                  offset: Offset(0, _bounceAnim.value),
                                  child: Text(
                                    player.emoji,
                                    style: const TextStyle(fontSize: 48),
                                  ),
                                ),
                              ),
                            ),
                            // Opponent character (idle)
                            Positioned(
                              bottom: 40,
                              right: 50,
                              child: Text(
                                opponent.emoji,
                                style: const TextStyle(fontSize: 48),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            // Input area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'type here',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.white50,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _inputCtrl,
                    focusNode: _focusNode,
                    enabled: _secondsLeft > 0,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.none,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                    ),
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.darkSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      hintText: _currentTarget.substring(0, 1) + '...',
                      hintStyle: TextStyle(color: AppColors.white50),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Scene Painter ─────────────────────────────────────────────────────────────
class _ScenePainter extends CustomPainter {
  const _ScenePainter({required this.scroll});
  final double scroll;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawStars(canvas, size);
    _drawFarTrees(canvas, size);
    _drawNearBushes(canvas, size);
    _drawGround(canvas, size);
  }

  void _drawSky(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0A0A24), Color(0xFF1A1A5E)],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawStars(Canvas canvas, Size size) {
    final positions = [
      Offset(size.width * 0.05, size.height * 0.06),
      Offset(size.width * 0.18, size.height * 0.12),
      Offset(size.width * 0.32, size.height * 0.05),
      Offset(size.width * 0.50, size.height * 0.09),
      Offset(size.width * 0.65, size.height * 0.04),
      Offset(size.width * 0.78, size.height * 0.14),
      Offset(size.width * 0.90, size.height * 0.07),
      Offset(size.width * 0.42, size.height * 0.18),
      Offset(size.width * 0.88, size.height * 0.22),
    ];

    for (var i = 0; i < positions.length; i++) {
      final twinkle = (sin(scroll * 2 * pi * 3 + i * 1.3) + 1) / 2;
      final p = Paint()..color = Colors.white.withValues(alpha: 0.3 + twinkle * 0.5);
      canvas.drawCircle(positions[i], 1.5, p);
    }

    // + decorations
    _drawPlus(canvas, Offset(size.width * 0.12, size.height * 0.25), 5);
    _drawPlus(canvas, Offset(size.width * 0.82, size.height * 0.18), 4);
  }

  void _drawPlus(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(c.dx - r, c.dy), Offset(c.dx + r, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - r), Offset(c.dx, c.dy + r), p);
  }

  void _drawFarTrees(Canvas canvas, Size size) {
    final groundY = size.height * 0.60;
    final offset = (scroll * size.width * 0.4) % (size.width * 0.4);

    for (var i = -1; i <= 4; i++) {
      final x = i * size.width * 0.25 + offset;
      // Trunk
      canvas.drawRect(
        Rect.fromLTWH(x + 10, groundY - 18, 6, 18),
        Paint()..color = const Color(0xFF4A2D1E),
      );
      // Pixelated canopy (3 rects)
      final tp = Paint()..color = const Color(0xFF1A5C2A);
      canvas.drawRect(Rect.fromLTWH(x + 2, groundY - 44, 22, 16), tp);
      canvas.drawRect(Rect.fromLTWH(x + 6, groundY - 60, 14, 18), tp);
      canvas.drawRect(Rect.fromLTWH(x + 9, groundY - 72, 8, 14), tp);
    }
  }

  void _drawNearBushes(Canvas canvas, Size size) {
    final groundY = size.height * 0.60;
    final offset = (scroll * size.width * 0.7) % (size.width * 0.35);

    for (var i = -1; i <= 5; i++) {
      final x = i * size.width * 0.22 + offset;
      final bp = Paint()..color = const Color(0xFF2E8B3E);
      // Pixel-rounded bushes
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, groundY - 22, 28, 22),
          const Radius.circular(6),
        ),
        bp,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 8, groundY - 34, 18, 16),
          const Radius.circular(5),
        ),
        bp,
      );
      // Highlight
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 4, groundY - 28, 8, 6),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFF3CB05A).withValues(alpha: 0.5),
      );
    }
  }

  void _drawGround(Canvas canvas, Size size) {
    final groundY = size.height * 0.60;
    // Grass strip
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, 10),
      Paint()..color = const Color(0xFF3CB043),
    );
    // Dirt
    canvas.drawRect(
      Rect.fromLTWH(0, groundY + 10, size.width, size.height - groundY - 10),
      Paint()..color = const Color(0xFF7A5230),
    );
    // Dirt highlight line
    canvas.drawRect(
      Rect.fromLTWH(0, groundY + 10, size.width, 3),
      Paint()..color = const Color(0xFF9A6E44),
    );
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.scroll != scroll;
}

// ── HUD ───────────────────────────────────────────────────────────────────────
class _RunHUD extends StatelessWidget {
  const _RunHUD({
    required this.timeLabel,
    required this.onBack,
    required this.onReset,
  });
  final String timeLabel;
  final VoidCallback onBack;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const Spacer(),
          Text(
            timeLabel,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.correct,
    required this.incorrect,
    required this.accuracy,
    required this.speed,
  });
  final int correct;
  final int incorrect;
  final int accuracy;
  final int speed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Stat(label: 'correct', value: '$correct'),
        _Stat(label: 'incorrect', value: '$incorrect'),
        _Stat(label: 'accuracy', value: '$accuracy%'),
        _Stat(label: 'speed', value: '$speed wpm'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.white50),
        ),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// ── Game Over Dialog ──────────────────────────────────────────────────────────
class _GameOverDialog extends StatelessWidget {
  const _GameOverDialog({
    required this.speed,
    required this.accuracy,
    required this.correct,
    required this.incorrect,
    required this.onBack,
    required this.onPlayAgain,
  });
  final int speed;
  final int accuracy;
  final int correct;
  final int incorrect;
  final VoidCallback onBack;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Dialog(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.emoji_events, size: 48, color: accent),
            ),
            const SizedBox(height: 12),
            Text(
              "Time's Up!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatBox(label: 'Speed', value: '$speed WPM'),
                _StatBox(label: 'Accuracy', value: '$accuracy%'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatBox(
                  label: 'Correct',
                  value: '$correct',
                  color: AppColors.green,
                ),
                _StatBox(
                  label: 'Incorrect',
                  value: '$incorrect',
                  color: AppColors.pink,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onBack,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.white50),
                      ),
                    ),
                    child: Text(
                      'BACK',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPlayAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'PLAY AGAIN',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    this.color = AppColors.white,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.white50),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
