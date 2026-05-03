import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/database/database_helper.dart';
import '../../app/database/player_progress.dart';
import '../../app/theme/app_colors.dart';

// ── Challenge model ───────────────────────────────────────────────────────────
class _Challenge {
  _Challenge({required this.decimal, required this.toDecimal});
  final int decimal;
  final bool toDecimal;

  String get prompt =>
      toDecimal ? decimal.toRadixString(2) : decimal.toString();
  String get answer =>
      toDecimal ? decimal.toString() : decimal.toRadixString(2);
  String get promptLabel => toDecimal ? 'BINARY' : 'DECIMAL';
  String get answerLabel => toDecimal ? 'TYPE DECIMAL' : 'TYPE BINARY';
}

// ── Level config ──────────────────────────────────────────────────────────────
class _Level {
  const _Level({
    required this.number,
    required this.min,
    required this.max,
    required this.points,
    required this.color,
  });
  final int number;
  final int min;
  final int max;
  final int points;
  final Color color;
}

const _levels = [
  _Level(
    number: 1,
    min: 1,
    max: 15,
    points: 10,
    color: Color(0xFF00FF41),
  ),
  _Level(
    number: 2,
    min: 16,
    max: 63,
    points: 20,
    color: Color(0xFFFFFF00),
  ),
  _Level(
    number: 3,
    min: 64,
    max: 255,
    points: 30,
    color: Color(0xFFFF8C00),
  ),
  _Level(
    number: 4,
    min: 0,
    max: 255,
    points: 50,
    color: Color(0xFFFF3333),
  ),
];

_Level _getLevel(int correct) {
  if (correct < 5) return _levels[0];
  if (correct < 10) return _levels[1];
  if (correct < 20) return _levels[2];
  return _levels[3];
}

// ── Screen ────────────────────────────────────────────────────────────────────
class BinaryPlayScreen extends StatefulWidget {
  const BinaryPlayScreen({super.key});

  @override
  State<BinaryPlayScreen> createState() => _BinaryPlayScreenState();
}

class _BinaryPlayScreenState extends State<BinaryPlayScreen>
    with TickerProviderStateMixin {
  static const _maxSeconds = 90;
  static const _maxLives = 3;

  final _inputCtrl = TextEditingController();
  final _focusNode = FocusNode();
  final _rng = Random();

  // Game state
  Timer? _gameTimer;
  int _secondsLeft = _maxSeconds;
  bool _running = false;
  int _lives = _maxLives;
  int _score = 0;
  int _correct = 0;
  bool _submitting = false;
  _Challenge? _challenge;
  Color _feedbackColor = Colors.transparent;

  // Animations
  late final AnimationController _matrixCtrl;
  late final AnimationController _shakeCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _shakeAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _generateChallenge();

    _matrixCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseAnim = Tween(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _inputCtrl.dispose();
    _focusNode.dispose();
    _matrixCtrl.dispose();
    _shakeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _generateChallenge() {
    final level = _getLevel(_correct);
    int decimal;
    if (level.number == 4) {
      // Hard: any 8-bit
      decimal = _rng.nextInt(256);
      while (decimal == (_challenge?.decimal ?? -1)) {
        decimal = _rng.nextInt(256);
      }
    } else {
      decimal =
          level.min + _rng.nextInt(level.max - level.min + 1);
    }
    final toDecimal = _rng.nextBool();
    _challenge = _Challenge(decimal: decimal, toDecimal: toDecimal);
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
        _endGame();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  void _onChanged(String value) {
    if (_submitting || _secondsLeft == 0 || _lives == 0) return;
    if (value.isNotEmpty && !_running) _startTimer();
    if (value.trim() == _challenge?.answer) _submitAnswer(value.trim(), correct: true);
  }

  void _onSubmitted(String value) {
    if (_submitting || _secondsLeft == 0 || _lives == 0) return;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    final isCorrect = trimmed == _challenge?.answer;
    _submitAnswer(trimmed, correct: isCorrect);
  }

  void _submitAnswer(String value, {required bool correct}) {
    if (_submitting) return;
    _submitting = true;
    HapticFeedback.lightImpact();

    final level = _getLevel(_correct);

    if (correct) {
      _pulseCtrl.forward(from: 0).then((_) => _pulseCtrl.reverse());
      setState(() {
        _correct++;
        _score += level.points;
        _feedbackColor = const Color(0xFF00FF41);
        // Bonus time
        _secondsLeft = (_secondsLeft + 3).clamp(0, _maxSeconds);
        _generateChallenge();
      });
    } else {
      _shakeCtrl.forward(from: 0);
      HapticFeedback.mediumImpact();
      setState(() {
        _lives--;
        _feedbackColor = const Color(0xFFFF3333);
      });
      if (_lives == 0) {
        _gameTimer?.cancel();
        _focusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 400), _endGame);
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _feedbackColor = Colors.transparent);
    });

    _inputCtrl.clear();
    Future.microtask(() => _submitting = false);
  }

  void _endGame() {
    _saveProgress();
    _showGameOverDialog();
  }

  Future<void> _saveProgress() async {
    if (_score == 0) return;
    final existing =
        await DatabaseHelper.instance.getProgress('binary_mode');
    if (existing == null || _score > existing.score) {
      await DatabaseHelper.instance.insertOrUpdateProgress(
        PlayerProgress(
          lessonId: 'binary_mode',
          score: _score,
          isCompleted: true,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  void _resetGame() {
    _gameTimer?.cancel();
    setState(() {
      _secondsLeft = _maxSeconds;
      _running = false;
      _lives = _maxLives;
      _score = 0;
      _correct = 0;
      _submitting = false;
      _feedbackColor = Colors.transparent;
      _inputCtrl.clear();
      _generateChallenge();
    });
  }

  void _showGameOverDialog() {
    final level = _getLevel(_correct);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('01101100', style: TextStyle(color: level.color, fontSize: 12, fontFamily: 'monospace')),
              const SizedBox(height: 8),
              Text(
                _lives == 0 ? 'GAME OVER' : "TIME'S UP!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DialogStat(label: 'Score', value: '$_score', color: level.color),
                  _DialogStat(label: 'Correct', value: '$_correct', color: Colors.greenAccent),
                  _DialogStat(label: 'Level', value: '${level.number}', color: level.color),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.white50),
                        ),
                      ),
                      child: const Text('BACK', style: TextStyle(color: AppColors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetGame();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: level.color,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('RETRY', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int s) =>
      '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final challenge = _challenge;
    final level = _getLevel(_correct);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // ── HUD ─────────────────────────────────────────────────────────
            _BinaryHUD(
              timeLabel: _formatTime(_secondsLeft),
              score: _score,
              lives: _lives,
              maxLives: _maxLives,
              level: level,
              onBack: () => Navigator.of(context).pop(),
              onReset: _resetGame,
            ),
            // ── Matrix rain ──────────────────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  // Background rain
                  AnimatedBuilder(
                    animation: _matrixCtrl,
                    builder: (_, __) => CustomPaint(
                      painter: _MatrixRainPainter(t: _matrixCtrl.value),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  // Challenge card
                  if (challenge != null)
                    Center(
                      child: AnimatedBuilder(
                        animation: _shakeAnim,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(_shakeAnim.value, 0),
                          child: child,
                        ),
                        child: AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (_, child) => Transform.scale(
                            scale: _pulseAnim.value,
                            child: child,
                          ),
                          child: _ChallengeCard(
                            challenge: challenge,
                            feedbackColor: _feedbackColor,
                            levelColor: level.color,
                            inputCtrl: _inputCtrl,
                            focusNode: _focusNode,
                            enabled: _secondsLeft > 0 && _lives > 0,
                            onChanged: _onChanged,
                            onSubmitted: _onSubmitted,
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
    );
  }
}

// ── HUD ───────────────────────────────────────────────────────────────────────
class _BinaryHUD extends StatelessWidget {
  const _BinaryHUD({
    required this.timeLabel,
    required this.score,
    required this.lives,
    required this.maxLives,
    required this.level,
    required this.onBack,
    required this.onReset,
  });
  final String timeLabel;
  final int score;
  final int lives;
  final int maxLives;
  final _Level level;
  final VoidCallback onBack;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border(
          bottom: BorderSide(color: level.color.withValues(alpha: 0.4), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: level.color, size: 20),
          ),
          // Lives
          Row(
            children: List.generate(
              maxLives,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.favorite,
                  size: 16,
                  color: i < lives ? Colors.redAccent : Colors.white24,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Timer
          Text(
            timeLabel,
            style: TextStyle(
              color: level.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          // Score + level badge
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'LV ${level.number}',
                style: TextStyle(color: level.color, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Text(
                '$score pts',
                style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onReset,
            icon: Icon(Icons.refresh, color: level.color, size: 20),
          ),
        ],
      ),
    );
  }
}

// ── Challenge card ────────────────────────────────────────────────────────────
class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.feedbackColor,
    required this.levelColor,
    required this.inputCtrl,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
  });
  final _Challenge challenge;
  final Color feedbackColor;
  final Color levelColor;
  final TextEditingController inputCtrl;
  final FocusNode focusNode;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final hasFeedback = feedbackColor != Colors.transparent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: hasFeedback
            ? feedbackColor.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasFeedback ? feedbackColor : levelColor.withValues(alpha: 0.5),
          width: hasFeedback ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: levelColor.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Prompt type label
          Text(
            challenge.promptLabel,
            style: TextStyle(
              color: levelColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          // Big prompt value
          Text(
            challenge.prompt,
            style: TextStyle(
              color: AppColors.white,
              fontSize: challenge.toDecimal ? 22 : 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              letterSpacing: challenge.toDecimal ? 4 : 2,
            ),
          ),
          const SizedBox(height: 6),
          // Arrow
          Icon(Icons.arrow_downward, color: levelColor.withValues(alpha: 0.7), size: 20),
          const SizedBox(height: 6),
          // Input label
          Text(
            challenge.answerLabel,
            style: const TextStyle(
              color: AppColors.white50,
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          // Input field
          TextField(
            controller: inputCtrl,
            focusNode: focusNode,
            enabled: enabled,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: challenge.toDecimal
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: challenge.toDecimal
                ? [FilteringTextInputFormatter.digitsOnly]
                : [FilteringTextInputFormatter.allow(RegExp(r'[01]'))],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: levelColor,
              fontSize: 22,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: levelColor.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: levelColor.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: levelColor, width: 1.5),
              ),
              hintText: challenge.toDecimal ? '0' : '00000000',
              hintStyle: TextStyle(
                color: AppColors.white50.withValues(alpha: 0.3),
                fontFamily: 'monospace',
                letterSpacing: 4,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Press Enter or type exact match to submit',
            style: TextStyle(color: AppColors.white50.withValues(alpha: 0.4), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ── Matrix rain painter ───────────────────────────────────────────────────────
class _MatrixRainPainter extends CustomPainter {
  const _MatrixRainPainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    const colW = 18.0;
    const charH = 18.0;
    final cols = (size.width / colW).ceil();
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (var col = 0; col < cols; col++) {
      final seed = col * 31 + 7;
      final speed = 0.25 + (seed % 9) * 0.07;
      final dropLen = 5 + (seed % 10);
      final offset = (seed % 100) / 100.0;
      final totalH = size.height + dropLen * charH;
      final headY = ((t * speed + offset) % 1.0) * totalH - dropLen * charH;

      for (var row = 0; row < dropLen; row++) {
        final y = headY + row * charH;
        if (y < -charH || y > size.height) continue;

        final isHead = row == dropLen - 1;
        final fade = row / dropLen;
        final alpha = isHead ? 1.0 : fade * 0.5;

        final char = ((seed + row + (t * 15).floor()) % 2 == 0) ? '1' : '0';
        tp.text = TextSpan(
          text: char,
          style: TextStyle(
            color: isHead
                ? const Color(0xFF00FF41).withValues(alpha: alpha)
                : const Color(0xFF003B00).withValues(alpha: alpha + 0.1),
            fontSize: 13,
            fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
          ),
        );
        tp.layout();
        tp.paint(canvas, Offset(col * colW + 3, y));
      }
    }
  }

  @override
  bool shouldRepaint(_MatrixRainPainter old) => old.t != t;
}

// ── Dialog stat box ───────────────────────────────────────────────────────────
class _DialogStat extends StatelessWidget {
  const _DialogStat({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.white50, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
        ),
      ],
    );
  }
}
