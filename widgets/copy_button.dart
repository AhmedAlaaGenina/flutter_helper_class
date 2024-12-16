import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scio_phile/components/components.dart';
import 'package:scio_phile/constants/app_colors.dart';

class CopyButton extends StatefulWidget {
  final String textToCopy;

  const CopyButton({
    super.key,
    required this.textToCopy,
  });

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton>
    with SingleTickerProviderStateMixin {
  bool _isCopied = false;
  late AnimationController _controller;
  late Animation<double> _widthFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _widthFactor = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));
    setState(() {
      _isCopied = true;
    });

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          setState(() {
            _isCopied = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: MyStyles.customBoxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      height: 48,
                      width: constraints.maxWidth * _widthFactor.value,
                      decoration: BoxDecoration(
                        color: AppColors.userMessageBox,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _copyToClipboard,
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isCopied
                                        ? Icons.check
                                        : Icons.copy_outlined,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isCopied ? 'Copied!' : 'Copy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (!_isCopied)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        widget.textToCopy,
                        style: TextStyle(
                          color: AppColors.userMessageBox,
                          fontSize: 22.sp,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
