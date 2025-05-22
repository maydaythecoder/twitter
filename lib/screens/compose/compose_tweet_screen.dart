import 'package:flutter/material.dart';
import 'package:twitter/services/mock_data_service.dart';

class ComposeTweetScreen extends StatefulWidget {
  const ComposeTweetScreen({super.key});

  @override
  State<ComposeTweetScreen> createState() => _ComposeTweetScreenState();
}

class _ComposeTweetScreenState extends State<ComposeTweetScreen> {
  final _textController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;
  int _charCount = 0;
  static const int _maxChars = 280;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateCharCount);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _textController.text.length;
    });
  }

  Future<void> _submitTweet() async {
    if (_textController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Tweet cannot be empty';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // In a real app, this would be an API call
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate network delay
      MockDataService.addTweet(
        content: _textController.text.trim(),
        username: 'Current User', // In a real app, this would come from auth
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to post tweet. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canSubmit =
        _textController.text.trim().isNotEmpty && _charCount <= _maxChars;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: canSubmit && !_isSubmitting ? _submitTweet : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    Theme.of(context).colorScheme.primary.withAlpha(100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Tweet'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Text(
                          'CU',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          maxLines: null,
                          maxLength: _maxChars,
                          decoration: InputDecoration(
                            hintText: "What's happening?",
                            border: InputBorder.none,
                            counterText: '',
                            errorText: _errorMessage,
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () {
                    // In a real app, this would open image picker
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.gif_box_outlined),
                  onPressed: () {
                    // In a real app, this would open GIF picker
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.poll_outlined),
                  onPressed: () {
                    // In a real app, this would open poll creator
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {
                    // In a real app, this would open emoji picker
                  },
                ),
                const Spacer(),
                if (_charCount > 0)
                  Text(
                    '$_charCount/$_maxChars',
                    style: TextStyle(
                      color: _charCount > _maxChars
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.secondary,
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
