import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination_package/features/pagination/pages/custom_infinite_scroll_view.dart';

class SkeletonLoading extends StatelessWidget {
  final int itemCount;
  final PaginationLayoutType layoutType;
  final SliverGridDelegate? gridDelegate;
  final bool isFooter;

  const SkeletonLoading({
    super.key,
    required this.itemCount,
    this.layoutType = PaginationLayoutType.list,
    this.gridDelegate,
    this.isFooter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFooter) {
      return SizedBox(
        height: layoutType == PaginationLayoutType.grid ? 200 : 100,
        child: _buildSkeletonContent(),
      );
    }

    return _buildSkeletonContent();
  }

  Widget _buildSkeletonContent() {
    if (layoutType == PaginationLayoutType.grid) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
            gridDelegate ??
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
        itemCount: itemCount,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => const SkeletonItem(),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,

      itemCount: itemCount,
      padding: const EdgeInsets.all(16),
      itemBuilder:
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SkeletonItem(height: 80),
          ),
    );
  }
}

class SkeletonItem extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const SkeletonItem({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const _ShimmerEffect(),
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect();

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              stops: const [0.0, 0.5, 1.0],
              colors: [
                Colors.grey.withOpacity(0.1),
                Colors.grey.withOpacity(0.3),
                Colors.grey.withOpacity(0.1),
              ],
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
            ).createShader(bounds);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
