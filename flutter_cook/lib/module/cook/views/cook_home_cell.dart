import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:get/get.dart';

class CookHomeCell extends StatefulWidget {
  final CookListDataModel model;
  final GestureTapCallback? onTap;

  const CookHomeCell({super.key, required this.model, this.onTap});

  @override
  State<CookHomeCell> createState() => _CookHomeCellState();
}

class _CookHomeCellState extends State<CookHomeCell>
    with AutomaticKeepAliveClientMixin {
  late final Widget _imageSection;
  bool _didPrecacheImage = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _imageSection = _CookHomeImageSection(model: widget.model);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheImage) {
      return;
    }

    final imageUrl = widget.model.image?.trim();
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'null') {
      return;
    }

    _didPrecacheImage = true;
    precacheImage(NetworkImage(imageUrl), context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        CookCard(
          onTap: widget.onTap,
          padding: EdgeInsets.zero,
          borderRadius: CookTokens.listCardRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _imageSection,
              Expanded(child: _CookHomeTitleSection(model: widget.model)),
            ],
          ),
        ),
        _CookHomeSelectionBorder(model: widget.model),
      ],
    );
  }
}

class _CookHomeImageSection extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeImageSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(CookTokens.listCardRadius),
        topRight: Radius.circular(CookTokens.listCardRadius),
      ),
      child: SizedBox(
        height: 110,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: model.image),
            _CookHomeSelectionOverlay(model: model),
          ],
        ),
      ),
    );
  }
}

class _CookHomeSelectionBorder extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeSelectionBorder({required this.model});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!model.isSelected.value) {
        return const SizedBox.shrink();
      }

      return IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CookTokens.listCardRadius),
            border: Border.all(
              color: CookTokens.primary,
              width: 2,
            ),
          ),
        ),
      );
    });
  }
}

class _CookHomeSelectionOverlay extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeSelectionOverlay({required this.model});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!model.isSelected.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: 10,
        right: 10,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              CookAssets.iconCheck,
              width: 20,
              height: 20,
            ),
          ),
        ),
      );
    });
  }
}

class _CookHomeTitleSection extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeTitleSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = model.isSelected.value;
      final colorScheme = Theme.of(context).colorScheme;
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(CookTokens.listCardRadius),
            bottomRight: Radius.circular(CookTokens.listCardRadius),
          ),
        ),
        child: Text(
          model.text ?? '—',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : Theme.of(context).textTheme.titleSmall?.color,
              ),
        ),
      );
    });
  }
}
