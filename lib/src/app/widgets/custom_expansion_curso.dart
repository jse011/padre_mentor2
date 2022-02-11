import 'package:flutter/material.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class CustomExpansionCurso extends StatefulWidget {

  const CustomExpansionCurso({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.trailing,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.lineaColor = AppTheme.colorAccent,
    required this.expandedItem,
    required this.findChildIndexCallback,
    required this.length
  }) :  super(key: key);

  final CrossAxisAlignment crossAxisAlignment;

  /// Typically widget.
  final Widget title;

  /// The color to display behind the sublist when expanded.
  final Color? backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget? trailing;

  final ValueNotifier<Key?> expandedItem;

  /// A widget to display instead of a rotating arrow icon.
  final Color lineaColor;

  final IndexedWidgetBuilder findChildIndexCallback;
  final int length;
  @override
  _CustomExpansionCursoState createState() => _CustomExpansionCursoState();
}

class _CustomExpansionCursoState extends State<CustomExpansionCurso> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded =  widget.expandedItem.value == widget.key;
    if (_isExpanded)
      _controller.value = 1.0;

    widget.expandedItem.addListener(listener);
  }

  void listener() {
    setState(() {
      _changeState(widget.expandedItem.value == widget.key);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.expandedItem.removeListener(listener);
    super.dispose();
  }

  void _changeState(bool isExpanded) {
    setState(() {
      _isExpanded = isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted)
            return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  void _handleTap() {
    _changeState(!_isExpanded);
    widget.expandedItem.value = _isExpanded ? widget.key : null;
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: _handleTap,
           child:  Card(
             color: widget.lineaColor ,
             margin: const EdgeInsets.only(top: 24, left: 16, right: 0, bottom: 8),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(10), // if you need this
               side: BorderSide(
                 color: Colors.grey.withOpacity(0.2),
                 width: 1,
               ),
             ),
             child: Container(
               margin: const EdgeInsets.only(top: 2, left: 8, right: 2, bottom: 2),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: new BorderRadius.only(
                   topLeft: const Radius.circular(10.0),
                   topRight: const Radius.circular(10.0),
                   bottomLeft:const Radius.circular(10.0),
                   bottomRight: const Radius.circular(10.0),
                 ),
               ),
               child: widget.title,
             ),
           ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween
      ..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.bodyText2?.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder:(context, child) => _buildChildren(context, child),
      child: (){
        if(false){
            return widget.length > 0 ? widget.findChildIndexCallback(context, 0) :
                    null;
          }else{
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.findChildIndexCallback(context, index);
              }
          );
          }
      }()
      /*child: closed ? null : Column(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: widget.children
      )*/,
    );

  }

}

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);