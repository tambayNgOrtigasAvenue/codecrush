import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/settings/app_settings.dart';
import '../../app/theme/app_colors.dart';

class RunPlayScreen extends StatefulWidget {
  const RunPlayScreen({super.key});

  @override
  State<RunPlayScreen> createState() => _RunPlayScreenState();
}

class _RunPlayScreenState extends State<RunPlayScreen> {
  static const int _durationSeconds = 60;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _random = Random();

  final _targets = <String>[
    'capsule',
    'runner',
    'speed',
    'forest',
    'jump',
    'galaxy',
    'pixel',
    'orbit',
    'signal',
    'rocket',
    'trail',
    'energy',
    'planet',
    'crystal',
    'charge',
    'meter',
    'boost',
    'shield',
    'combo',
    'victory',
    'binary',
    'syntax',
    'widget',
    'buffer',
    'compile',
    'deploy',
    'matrix',
    'vector',
    'server',
    'client',
    'router',
    'stream',
    'socket',
    'thread',
    'memory',
    'packet',
    'engine',
    'script',
    'plugin',
    'module',
    'layout',
    'canvas',
    'render',
    'shader',
    'sprite',
    'object',
    'method',
    'string',
    'number',
    'boolean',
    'array',
    'queue',
    'stack',
    'graph',
    'domain',
    'network',
    'cloud',
    'system',
    'kernel',
    'device',
  ];

  Timer? _timer;
  int _secondsLeft = _durationSeconds;
  bool _running = false;
  int _correct = 0;
  int _incorrect = 0;
  String _currentTarget = '';

  @override
  void initState() {
    super.initState();
    _pickTarget();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _pickTarget() {
    _currentTarget = _targets[_random.nextInt(_targets.length)];
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
      _pickTarget();
    });
  }

  void _submitWord(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || _secondsLeft == 0) {
      _controller.clear();
      return;
    }
    setState(() {
      if (trimmed == _currentTarget) {
        _correct += 1;
      } else {
        _incorrect += 1;
      }
      _pickTarget();
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

  int _calculateAccuracy() {
    final total = _correct + _incorrect;
    if (total == 0) {
      return 100;
    }
    return ((_correct / total) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final player = _characters[settings.characterIndex % _characters.length];
    final opponent = _characters[1];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _RunAppBar(
              timeLabel: _formatTime(_secondsLeft),
              onBackTap: () => Navigator.of(context).pop(),
              onResetTap: _resetGame,
            ),
            const SizedBox(height: 8),
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
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2B2D6E), Color(0xFF5A3D3D)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const Alignment(0, -0.4),
                          child: Text(
                            _currentTarget,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.5, 0.35),
                          child: Icon(
                            player.icon,
                            size: 64,
                            color: player.color,
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0.5, 0.35),
                          child: Icon(
                            opponent.icon,
                            size: 64,
                            color: opponent.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'type here',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.white50),
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
                      if (value.endsWith(' ')) {
                        _submitWord(value);
                      }
                    },
                    onSubmitted: _submitWord,
                    decoration: const InputDecoration(border: InputBorder.none),
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

class _RunAppBar extends StatelessWidget {
  const _RunAppBar({
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

class _CharacterOption {
  const _CharacterOption({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}

const _characters = [
  _CharacterOption(icon: Icons.bug_report, color: Color(0xFFF5DA7E)),
  _CharacterOption(icon: Icons.star, color: Color(0xFFF694BB)),
  _CharacterOption(icon: Icons.ac_unit, color: Color(0xFF5CD6FF)),
  _CharacterOption(icon: Icons.android, color: Color(0xFF7AE582)),
];
