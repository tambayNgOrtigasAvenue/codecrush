import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/database/database_helper.dart';
import '../../app/database/player_progress.dart';
import '../../app/theme/app_colors.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  static const int _durationSeconds = 60;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _sentences = <String>[
    'the quick brown fox jumps over the lazy dog',
    'practice makes progress every single day',
    'flutter makes it easy to build beautiful apps',
    'typing fast takes focus and steady rhythm',
    'stay curious and keep learning new things',
    'consistency beats intensity over the long run',
    'small steps add up to big results',
    'write clean code and refactor often',
    'a calm mind types with better accuracy',
    'debugging is just careful problem solving',
    'build features with clarity and purpose',
    'measure twice and type once',
    'keep your posture relaxed and shoulders down',
    'short breaks help you maintain speed',
    'read the next word before you type it',
    'mistakes are part of the learning process',
    'focus on accuracy before raw speed',
    'keep the cursor moving at a steady pace',
    'your best speed comes with good habits',
    'every session makes you a bit faster',
    'algorithms and data structures are fundamental',
    'a skilled developer knows how to search for answers',
    'clean architecture leads to maintainable code',
    'always test your edge cases thoroughly',
    'commit early and commit often to save your work',
    'agile methodologies emphasize iterative progress',
    'version control is essential for team collaboration',
    'object oriented programming uses classes and methods',
    'functional programming avoids mutable state',
    'the user interface should be intuitive and responsive',
    'performance profiling helps find hidden bottlenecks',
    'dependency injection makes your code more testable',
    'never trust user input without proper validation',
    'a good variable name is worth a dozen comments',
    'the compiler is your first line of defense',
    'memory leaks can cause your application to crash',
    'asynchronous operations prevent the thread from blocking',
    'cloud computing offers scalable infrastructure',
    'continuous integration catches bugs before deployment',
    'reading documentation saves hours of frustration',
    'regular expressions are powerful but hard to read',
    'a well written api is a joy to consume',
    'security should be a priority from day one',
    'understanding the domain is half the battle',
    'the simplest solution is usually the best one',
    'dont reinvent the wheel unless you have to',
    'peer reviews improve both code and developers',
    'technical debt will eventually slow you down',
    'keep your dependencies up to date',
    'a good error message tells the user what to do next',
  ];

  final _random = Random();
  Timer? _timer;
  int _secondsLeft = _durationSeconds;
  bool _running = false;

  late List<String> _words;
  int _currentWordIndex = 0;
  int _correct = 0;
  int _incorrect = 0;
  String _originalText = '';
  String _enteredText = '';

  @override
  void initState() {
    super.initState();
    _loadSentence();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadSentence() {
    _originalText = _sentences[_random.nextInt(_sentences.length)];
    _words = _originalText.split(' ');
    _currentWordIndex = 0;
    _enteredText = '';
  }

  void _startTimer() {
    if (_running) {
      return;
    }
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
        });
        _focusNode.unfocus();
        _saveHistory();
        _showGameOverDialog();
        return;
      }
      setState(() {
        _secondsLeft -= 1;
      });
    });
  }

  void _resetGame() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _durationSeconds;
      _running = false;
      _correct = 0;
      _incorrect = 0;
      _controller.clear();
      _loadSentence();
    });
  }

  void _submitWord(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || _secondsLeft == 0) {
      _controller.clear();
      return;
    }
    final expected = _words[_currentWordIndex];

    setState(() {
      if (trimmed == expected) {
        _correct += 1;
      } else {
        _incorrect += 1;
      }
      _enteredText = _enteredText.isEmpty ? trimmed : '$_enteredText $trimmed';
      _currentWordIndex += 1;
      if (_currentWordIndex >= _words.length) {
        _loadSentence();
      }
    });
    _controller.clear();
  }

  int _calculateWpm() {
    final elapsed = _durationSeconds - _secondsLeft;
    if (elapsed <= 0) {
      return 0;
    }
    final minutes = elapsed / 60;
    return (_correct / minutes).floor();
  }

  Future<void> _saveHistory() async {
    final speed = _calculateWpm();
    if (speed == 0) return;

    final existing = await DatabaseHelper.instance.getProgress('classic_mode');
    if (existing == null || speed > existing.score) {
      await DatabaseHelper.instance.insertOrUpdateProgress(
        PlayerProgress(
          lessonId: 'classic_mode',
          score: speed,
          isCompleted: true,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  void _showGameOverDialog() {
    final speed = _calculateWpm();
    final accuracy = _calculateAccuracy();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Time\'s Up!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _GameOverStatBox(label: 'Speed', value: '$speed WPM'),
                    _GameOverStatBox(label: 'Accuracy', value: '$accuracy%'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _GameOverStatBox(label: 'Correct', value: '$_correct', color: AppColors.green),
                    _GameOverStatBox(label: 'Incorrect', value: '$_incorrect', color: AppColors.pink),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.white50),
                          ),
                        ),
                        child: Text(
                          'BACK',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.white,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetGame();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
      },
    );
  }

  int _calculateAccuracy() {
    final total = _correct + _incorrect;
    if (total == 0) {
      return 100;
    }
    return ((_correct / total) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _GameAppBar(
              timeLabel: _formatTime(_secondsLeft),
              onBackTap: () => Navigator.of(context).pop(),
              onResetTap: _resetGame,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _StatsRow(
                correct: _correct,
                incorrect: _incorrect,
                accuracy: _calculateAccuracy(),
                speed: _calculateWpm(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _SentencePreview(
                          words: _words,
                          activeIndex: _currentWordIndex,
                          accentColor: accentColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'type here',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.white50),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 2,
                          width: 60,
                          color: AppColors.white50,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          enabled: _secondsLeft > 0,
                          textInputAction: TextInputAction.done,
                          style: Theme.of(context).textTheme.bodyLarge,
                          onChanged: (value) {
                            if (!_running) {
                              _startTimer();
                            }
                            final expected = _words[_currentWordIndex];
                            if (value.trim() == expected) {
                              _submitWord(value);
                            } else if (value.endsWith(' ')) {
                              _submitWord(value);
                            }
                          },
                          onSubmitted: _submitWord,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'original',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.white50),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _originalText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'entered',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.white50),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _enteredText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }
}

class _GameAppBar extends StatelessWidget {
  const _GameAppBar({
    required this.timeLabel,
    required this.onBackTap,
    required this.onResetTap,
  });

  final String timeLabel;
  final VoidCallback onBackTap;
  final VoidCallback onResetTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const Spacer(),
          Text(timeLabel, style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          IconButton(
            onPressed: onResetTap,
            icon: const Icon(Icons.refresh, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

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
        _StatItem(label: 'correct', value: '$correct'),
        _StatItem(label: 'incorrect', value: '$incorrect'),
        _StatItem(label: 'accuracy', value: '$accuracy%'),
        _StatItem(label: 'speed', value: '$speed wpm'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

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
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _SentencePreview extends StatelessWidget {
  const _SentencePreview({
    required this.words,
    required this.activeIndex,
    required this.accentColor,
  });

  final List<String> words;
  final int activeIndex;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 6,
      children: [
        for (var i = 0; i < words.length; i++)
          Text(
            words[i],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: i == activeIndex
                  ? accentColor
                  : i < activeIndex
                  ? AppColors.white
                  : AppColors.white50,
            ),
          ),
      ],
    );
  }
}

class _GameOverStatBox extends StatelessWidget {
  const _GameOverStatBox({
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.white50,
              ),
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
