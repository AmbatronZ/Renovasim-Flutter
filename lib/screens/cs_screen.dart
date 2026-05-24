import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';

class CsScreen extends StatefulWidget {
  const CsScreen({super.key});

  @override
  State<CsScreen> createState() => _CsScreenState();
}

class _CsScreenState extends State<CsScreen>
    with SingleTickerProviderStateMixin {
  // ─── State ───────────────────────────────────────────────────────────────
  bool _isConnected = false;
  bool _isTyping = false;
  final List<_ChatMessage> _messages = [];
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  late AnimationController _spinnerCtrl;

  static const String _csName = 'Renovasim CS';
  static const String _csAgent = 'CS Team : king nasir';

  @override
  void initState() {
    super.initState();
    _spinnerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulate finding CS after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _isConnected = true);

      // CS sends greeting after connecting
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _addCsMessage(
            'Thanks for contacting Renovasim CS. My name is King, how can I help you?');
      });
    });
  }

  @override
  void dispose() {
    _spinnerCtrl.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _addCsMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isUser: false,
        time: _currentTime(),
      ));
    });
    _scrollToBottom();
  }

  void _sendMessage() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isUser: true,
        time: _currentTime(),
      ));
      _inputCtrl.clear();
    });
    _scrollToBottom();

    // Simulate CS typing then reply
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isTyping = true);
      _scrollToBottom();

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isTyping = false);
        _addCsMessage('Terima kasih atas pertanyaannya! Tim kami akan segera membantu Anda.');
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Bar ─────────────────────────────────────────
            _buildTopBar(context),

            // ─── Body ────────────────────────────────────────────
            Expanded(
              child: _isConnected ? _buildChat() : _buildLoading(),
            ),

            // ─── Input Bar (only when connected) ─────────────────
            if (_isConnected) _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar ─────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          // Three dots
          Row(
            children: List.generate(
              3,
              (i) => Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
          const Spacer(),

          // Status
          Row(
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
              Text(
                _isConnected ? 'Connected' : 'Searching',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isConnected
                      ? AppColors.coconutGreen
                      : Colors.orange,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ],
          ),
          const Spacer(),

          // Close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close_rounded,
                size: 20, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ─── Loading State ───────────────────────────────────────────────────────
  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spinning circle with home icon
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              RotationTransition(
                turns: _spinnerCtrl,
                child: CustomPaint(
                  size: const Size(120, 120),
                  painter: _ArcPainter(color: AppColors.coconutGreen),
                ),
              ),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.grey[200]!, width: 2),
                ),
                child: Icon(
                  Icons.home_outlined,
                  size: 36,
                  color: AppColors.metallicBlack,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Text(
          'Finding live Renovasim\nCustomer Service\nteam member',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.metallicBlack,
            height: 1.5,
            fontFamily: 'PPEditorialNew',
          ),
        ),
      ],
    );
  }

  // ─── Chat State ──────────────────────────────────────────────────────────
  Widget _buildChat() {
    return Column(
      children: [
        // CS agent info
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.metallicBlack,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _csName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.metallicBlack,
                      fontFamily: 'PPEditorialNew',
                    ),
                  ),
                  Text(
                    _csAgent,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.zenGray,
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFF0F0F0)),

        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (_, i) {
              if (_isTyping && i == _messages.length) {
                return _buildTypingIndicator();
              }
              return _buildMessageBubble(_messages[i]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Timestamp
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              msg.time,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
          ),
          // Bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: msg.isUser
                  ? AppColors.coconutGreen
                  : const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                bottomRight: Radius.circular(msg.isUser ? 4 : 16),
              ),
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                fontSize: 13,
                color: msg.isUser
                    ? Colors.white
                    : AppColors.metallicBlack,
                height: 1.4,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ─── Input Bar ───────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          // Three dots
          Icon(Icons.more_horiz_rounded,
              color: Colors.grey[400], size: 22),
          const SizedBox(width: 8),

          // Mic
          Icon(Icons.mic_outlined, color: Colors.grey[400], size: 22),
          const SizedBox(width: 8),

          // Text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _inputCtrl,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Type here...',
                  hintStyle: TextStyle(
                      fontSize: 13, color: Color(0xFFBDBDBD)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Icon(Icons.send_rounded,
                color: AppColors.coconutGreen, size: 22),
          ),
        ],
      ),
    );
  }
}

// ─── Typing Dots Animation ────────────────────────────────────────────────────
class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.3) % 1.0;
            final opacity =
                (phase < 0.5 ? phase * 2 : (1.0 - phase) * 2)
                    .clamp(0.3, 1.0);
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.zenGray.withOpacity(opacity),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─── Arc Painter for spinner ──────────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  final Color color;
  _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bgPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background circle
    canvas.drawCircle(center, radius, bgPaint);

    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5,
      2.0,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => false;
}

// ─── Message Model ────────────────────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}