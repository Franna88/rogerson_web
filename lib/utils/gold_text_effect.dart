import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart' as app;
import 'dart:typed_data';

class GoldTextEffect extends StatefulWidget {
  final Widget child;
  final double scale;
  final bool enabled;
  
  const GoldTextEffect({
    super.key,
    required this.child,
    this.scale = 1.0,
    this.enabled = true,
  });
  
  @override
  State<GoldTextEffect> createState() => _GoldTextEffectState();
}

class _GoldTextEffectState extends State<GoldTextEffect> {
  ui.Image? _goldFoilImage;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    // Use the preloaded image if available
    if (app.goldFoilImage != null) {
      _goldFoilImage = app.goldFoilImage;
      _isLoading = false;
    } else {
      _loadGoldFoilImage();
    }
  }
  
  Future<void> _loadGoldFoilImage() async {
    try {
      final ByteData data = await rootBundle.load('images/gold_foil.jpg');
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 1024,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      
      if (mounted) {
        setState(() {
          _goldFoilImage = frameInfo.image;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error loading gold foil image: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _isLoading || _goldFoilImage == null) {
      return widget.child;
    }
    
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        final matrix = Matrix4.identity()
          ..scale(widget.scale, widget.scale)
          ..translate(-bounds.left, -bounds.top);
        
        return ImageShader(
          _goldFoilImage!,
          TileMode.repeated,
          TileMode.repeated,
          Float64List.fromList(matrix.storage),
        );
      },
      child: widget.child,
    );
  }
}

// Simple stateless wrapper to use gold text in the Text widget
class GoldText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final double scale;
  
  const GoldText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign,
    this.scale = 0.5,
  });
  
  @override
  Widget build(BuildContext context) {
    return GoldTextEffect(
      scale: scale,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
} 