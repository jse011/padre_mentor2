
import 'package:flutter/material.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';

import '../utils/app_theme.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final Function? onClick;
  const TitleView(
      {Key? key,
      this.titleTxt: "",
      this.subTxt: "",
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    var widgetList = <Widget>[
      Expanded(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 18),
          child:  Text(
            titleTxt,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w700,
              fontSize: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
              letterSpacing: 0.5,
              color: AppTheme.colorPrimary,
            ),
          ),
        ),
      ),
    ];

    if(this.subTxt!=null){
      widgetList.add( InkWell(
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        onTap: () {
         onClick?.call();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: <Widget>[
              Text(
                subTxt,
                softWrap: true,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w700,
                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 16),
                  letterSpacing: 0.5,
                  color: AppTheme.colorPrimary,
                ),
              ),
              SizedBox(
                height: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 38),
                width: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 26),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppTheme.colorPrimary,
                  size: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 18),
                ),
              )
            ],
          ),
        ),
      ));
    }

    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 32),
            right: ColumnCountProvider.aspectRatioForWidthPortalAlumno(context, 32),
        ),
        child: Row(
          children: widgetList,
        ),
      ),
    );
  }
}
