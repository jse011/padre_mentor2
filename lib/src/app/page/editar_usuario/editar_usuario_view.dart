import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:padre_mentor/src/app/page/editar_usuario/editar_usuario_controller.dart';
import 'package:padre_mentor/src/app/page/home/home_router.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/widgets/animation_view.dart';
import 'package:padre_mentor/src/app/widgets/ars_progress.dart';
import 'package:padre_mentor/src/app/widgets/image_picker/image_picker_handler.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/compress_image/device_compress_image_repository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';

class EditarUsuarioView extends View{
  bool cabecera = false;
  static const String Name = "EditarUsuarioView";
  EditarUsuarioView({this.cabecera = false});

  @override
  EditarUsuarioViewState createState() => EditarUsuarioViewState(EditarUsuarioController(DeviceHttpDatosRepositorio(), DataUsuarioAndRepository(), DeviceCompressImageRepository()));

}

class EditarUsuarioViewState extends ViewState<EditarUsuarioView, EditarUsuarioController> with  TickerProviderStateMixin,ImagePickerListener {
  late Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  late AnimationController animationController;

  late AnimationController _imagePickerAnimationcontroller;
  late ImagePickerHandler imagePicker;
  late EditarUsuarioController controller;

  EditarUsuarioViewState(controller): super(controller){
    this.controller = controller;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    animationController.reset();

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      setState(() {
        animationController.forward();
      });}

    );


    _imagePickerAnimationcontroller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_imagePickerAnimationcontroller);
    imagePicker.init();

    super.initState();
    //initDialog();
  }



  void initDialog(){
    /*  ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    ArsProgressDialog customProgressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        loadingWidget: Container(
          width: 150,
          height: 150,
          color: Colors.red,
          child: CircularProgressIndicator(),
        ));*/
  }

  @override
  void dispose() {
    animationController.dispose();
    _imagePickerAnimationcontroller.dispose();
    super.dispose();
  }
  @override
  Widget get view =>
      Container(
        color: AppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              getMainTab(),
              getAppBarUI(),
              ControlledWidgetBuilder<EditarUsuarioController>(
                  builder: (context, controller) {
                      return controller.showDialog?ArsProgressWidget(
                          blur: 2,
                          backgroundColor: Color(0x33000000),
                          animationDuration: Duration(milliseconds: 500)
                      ):Container();
                  }
              )
            ],
          ),
        ),
      );

  int countView = 4;
  @override
  Widget getMainTab(){

    return ControlledWidgetBuilder<EditarUsuarioController>(
        builder: (context, controller) {

          if(controller.dissmis) {
            if (widget.cabecera) {
              Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pop(context, true);
               });

            } else {
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                // fetch data
                HomeRouter.createRouteHomeRemoveAll(context);
              });
              return Container();
            }
          }
          return Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
              ),
              child: AnimationView(
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController,
                    curve:
                    Interval((1 / countView) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                animationController: animationController,
                child: CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      if(controller.usuarioUi!=null)
                        SliverList(
                            delegate: SliverChildListDelegate([
                              Center(
                                child:  Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 90,right: 90),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 48),
                                        height: 120,
                                        width: 120,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.white,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                                          ],
                                        ),
                                        child: GestureDetector(
                                            onTap: (){
                                              controller.onChangeImageUsuario();
                                              imagePicker.showDialog(context);
                                            },
                                            child:  controller.usuarioUi?.fotoFile!=null?Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                                    image: DecorationImage(
                                                      image: FileImage(controller.usuarioUi!.fotoFile!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                    ]
                                                )
                                            ):
                                            CachedNetworkImage(
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              imageUrl: controller.usuarioUi?.foto??'',
                                              errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                              imageBuilder: (context, imageProvider) => Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                      ]
                                                  )
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                                   Positioned(
                                        bottom: 0,
                                        left: 0,
                                       child:  Container(
                                         width: 85,
                                         height: 30,
                                         padding: const EdgeInsets.all(1),
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.all(Radius.circular(20)),
                                           color: AppTheme.colorPrimary,
                                         ),
                                         child: GestureDetector(
                                             onTap: (){
                                               controller.onChangeImageUsuario();
                                               imagePicker.showDialog(context);
                                             },
                                             child:  Container(
                                                 decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.all(Radius.circular(19)),
                                                   color: AppTheme.background,
                                                 ),
                                               child: Row(
                                                 children: [
                                                   Padding(
                                                     padding: const EdgeInsets.only(left: 8, right: 4),
                                                     child: Icon(Icons.camera_alt_outlined, color: AppTheme.colorPrimary, size: 20,),
                                                   ),
                                                   Expanded(
                                                       child: Text("Editar", style: TextStyle(color: AppTheme.colorPrimary),)
                                                   )
                                                 ],
                                               ),
                                             )
                                         ),
                                       ),
                                   )
                                  ],
                                ),
                              ),
                              // Textform Field
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                                child:  TextFormField(
                                  key: Key("Nombre_${controller.usuarioUi?.personaId}"),
                                  enabled: false,
                                  maxLength: 50,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  initialValue: controller.usuarioUi?.nombre??'',
                                  //controller: accountController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: "Nombres",
                                    labelStyle: TextStyle(
                                      color:  AppTheme.colorPrimary,
                                    ),
                                    helperText: "Desabiliado",
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.account_box,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    hintText: "Ingrese su nombre",
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusColor: AppTheme.colorAccent,
                                  ),
                                  onChanged: (str) {

                                  },
                                  onSaved: (str) {
                                    //  To do
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                child:  TextFormField(
                                  key: Key("Fecha_Nac_${controller.usuarioUi?.personaId}"),
                                  enabled: false,
                                  maxLength: 50,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  initialValue: controller.usuarioUi?.fechaNacimiento2??'',
                                  //controller: accountController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: "Fecha de nacimiento",
                                    labelStyle: TextStyle(
                                      color:  AppTheme.colorPrimary,
                                    ),
                                    helperText: "Desabiliado",
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.today_outlined,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    hintText: "Ingrese su fecha de nacimiento",
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusColor: AppTheme.colorAccent,
                                  ),
                                  onChanged: (str) {
                                    // To do
                                  },
                                  onSaved: (str) {
                                    //  To do
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                child:  TextFormField(
                                  key: Key("Telefono_${controller.usuarioUi?.personaId}"),
                                  enabled: true,
                                  maxLength: 50,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  initialValue: controller.usuarioUi?.celular??'',
                                  //controller: accountController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: "Número de telefono",
                                    labelStyle: TextStyle(
                                      color:  AppTheme.colorPrimary,
                                    ),
                                    helperText: "Actualice su telefono",
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.call_end_outlined,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    hintText: "Ingrese su número de telefono",
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusColor: AppTheme.colorAccent,
                                  ),
                                  onChanged: (str) {
                                    controller.usuarioUi?.celular = str;
                                    controller.usuarioUi?.change = true;
                                  },
                                  onSaved: (str) {
                                    //  To do
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                child:  TextFormField(
                                  key: Key("Correo_${controller.usuarioUi?.personaId}"),
                                  enabled: true,
                                  maxLength: 50,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  initialValue: controller.usuarioUi?.correo??'',
                                  //controller: accountController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: "Correo",
                                    labelStyle: TextStyle(
                                      color:  AppTheme.colorPrimary,
                                    ),
                                    helperText: "Actualice su correo",
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.email_outlined,
                                      color: AppTheme.colorPrimary,
                                    ),
                                    errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    hintText: "Ingrese su correo",
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusColor: AppTheme.colorAccent,
                                  ),
                                  onChanged: (str) {
                                    controller.usuarioUi?.correo = str;
                                    controller.usuarioUi?.change = true;
                                  },
                                  onSaved: (str) {
                                    //  To do
                                  },
                                ),
                              ),
                            ])
                        ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index){

                              HijosUi hijosUi = controller.hijoUiList[index];
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 32),
                                    padding: const EdgeInsets.only(top: 8, left: 24, bottom: 8),
                                    color: AppTheme.grey.withOpacity(0.1),
                                    child: Center(
                                      child: Text("CUENTA VINCULADA", style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      )),
                                    ),
                                  ),
                                  Center(
                                    child:  Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 90,right: 90),
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 48),
                                            height: 120,
                                            width: 120,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppTheme.white,
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                                              ],
                                            ),
                                            child: GestureDetector(
                                                onTap: (){
                                                  controller.onChangeImageHijo(hijosUi);
                                                  imagePicker.showDialog(context);
                                                },
                                                child: hijosUi.fotoFile!=null?Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                        image: DecorationImage(
                                                          image: FileImage(hijosUi.fotoFile!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                        ]
                                                    )
                                                ):
                                                CachedNetworkImage(
                                                  placeholder: (context, url) => CircularProgressIndicator(),
                                                  imageUrl: hijosUi.foto??'',
                                                  errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                  imageBuilder: (context, imageProvider) => Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                                          image: DecorationImage(
                                                            image: imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                          ]
                                                      )
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child:  Container(
                                            width: 85,
                                            height: 30,
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: AppTheme.colorPrimary,
                                            ),
                                            child: GestureDetector(
                                                onTap: (){
                                                  controller.onChangeImageHijo(hijosUi);
                                                  imagePicker.showDialog(context);
                                                },
                                                child:  Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(19)),
                                                    color: AppTheme.background,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8, right: 4),
                                                        child: Icon(Icons.camera_alt_outlined, color: AppTheme.colorPrimary, size: 20,),
                                                      ),
                                                      Expanded(
                                                          child: Text("Editar", style: TextStyle(color: AppTheme.colorPrimary),)
                                                      )
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Textform Field
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                                    child:  TextFormField(
                                      key: Key("Nombre_${hijosUi.personaId}"),
                                      enabled: false,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: hijosUi.nombre??'',
                                      //controller: accountController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Nombres",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Desabiliado",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.account_box,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su nombre",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                        // To do
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                    child:  TextFormField(
                                      key: Key("Fecha_Nac_${hijosUi.personaId}"),
                                      enabled: false,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: hijosUi.fechaNacimiento2,
                                      //controller: accountController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Fecha de nacimiento",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Desabiliado",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.today_outlined,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su fecha de nacimiento",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {

                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                    child:  TextFormField(
                                      key: Key("Telefono_${hijosUi.personaId}"),
                                      enabled: true,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: hijosUi.celular??'',
                                      //controller: accountController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Número de telefono",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Actualice su telefono",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.call_end_outlined,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su telefono",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                        hijosUi.celular = str;
                                        hijosUi.change = true;
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                    child:  TextFormField(
                                      key: Key("Correo_${hijosUi.personaId}"),
                                      enabled: true,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: hijosUi.correo??'',
                                      //controller: accountController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (val) => EmailValidator.validate(val??"") ? null : "Correo inválido",
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Correo",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Actualice su correo",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.email_outlined,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su correo",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                        hijosUi.correo = str;
                                        hijosUi.change = true;
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }, childCount: controller.hijoUiList.length),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index){

                              FamiliaUi familiaUi = controller.familiaUiList[index];
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 32),
                                    padding: const EdgeInsets.only(top: 8, left: 24, bottom: 8),
                                    color: AppTheme.grey.withOpacity(0.1),
                                    child: Center(
                                      child: Text("CUENTA VINCULADA", style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      )),
                                    ),
                                  ),
                                  Center(
                                    child:  Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 90,right: 90),
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 48),
                                            height: 120,
                                            width: 120,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppTheme.white,
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                                              ],
                                            ),
                                            child: GestureDetector(
                                                onTap: (){
                                                  controller.onChangeImageFamila(familiaUi);
                                                  imagePicker.showDialog(context);
                                                },
                                                child:  familiaUi.fotoFile!=null?Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                        image: DecorationImage(
                                                          image: FileImage(familiaUi.fotoFile!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                        ]
                                                    )
                                                ):
                                                CachedNetworkImage(
                                                  placeholder: (context, url) => CircularProgressIndicator(),
                                                  imageUrl: familiaUi.foto??'',
                                                  errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                  imageBuilder: (context, imageProvider) => Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                                          image: DecorationImage(
                                                            image: imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                          ]
                                                      )
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child:  Container(
                                            width: 85,
                                            height: 30,
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: AppTheme.colorPrimary,
                                            ),
                                            child: GestureDetector(
                                                onTap: (){
                                                  controller.onChangeImageFamila(familiaUi);
                                                  imagePicker.showDialog(context);
                                                },
                                                child:  Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(19)),
                                                    color: AppTheme.background,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8, right: 4),
                                                        child: Icon(Icons.camera_alt_outlined, color: AppTheme.colorPrimary, size: 20,),
                                                      ),
                                                      Expanded(
                                                          child: Text("Editar", style: TextStyle(color: AppTheme.colorPrimary),)
                                                      )
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Textform Field
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                                    child:  TextFormField(
                                      key: Key("Nombre_${familiaUi.personaId}"),
                                      enabled: false,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: familiaUi.nombre??'',
                                      //controller: accountController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Nombres",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Desabiliado",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.account_box,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su nombre",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                        // To do
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                    child:  TextFormField(
                                      key: Key("Fecha_Nac_${familiaUi.personaId}"),
                                      enabled: false,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: familiaUi.fechaNacimiento2??'',
                                      //controller: accountController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Fecha de nacimiento",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Desabiliado",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.today_outlined,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su fecha de nacimiento",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                        // To do
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                    child:  TextFormField(
                                      key: Key("Telefono_${familiaUi.personaId}"),
                                      enabled: true,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: familiaUi.celular??'',
                                      //controller: accountController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Número de telefono",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Actualice su telefono",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.call_end_outlined,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su telefono",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                        familiaUi.celular = str;
                                        familiaUi.change = true;
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                    child:  TextFormField(
                                      key: Key("Correo_${familiaUi.personaId}"),
                                      enabled: true,
                                      maxLength: 50,
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      initialValue: familiaUi.correo??'',
                                      //controller: accountController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (val) => EmailValidator.validate(val??"") ? null : "Correo inválido",
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: "Correo",
                                        labelStyle: TextStyle(
                                          color:  AppTheme.colorPrimary,
                                        ),
                                        helperText: "Actualice su correo",
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.email_outlined,
                                          color: AppTheme.colorPrimary,
                                        ),
                                        errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        hintText: "Ingrese su correo",
                                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(28.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                        familiaUi.correo = str;
                                        familiaUi.change = true;
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }, childCount: controller.familiaUiList.length),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              height: 100,
                            )
                          ])
                      ),
                    ]
                ),
              )
          );
        });
  }


  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.cabecera?
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                animationController.reverse().then<dynamic>((data) {
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pop(context, false);
                                });
                              },
                            ):
                            Container(
                              width:  35 + 6 - 6 * topBarOpacity,
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Editar mi perfil',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            ControlledWidgetBuilder<EditarUsuarioController>(
                              builder: (context, controller) {

                                if(controller.mensaje!=null&&(controller.mensaje??"").isNotEmpty){
                                  Fluttertoast.showToast(
                                    msg: controller.mensaje!,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                  controller.successMsg();
                                }

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                    onTap: () {
                                      //if(widget.cabecera){
                                        //Navigator.pop(context, true);
                                      //}
                                      controller.onSave();
                                    },
                                    child:
                                    Container(
                                        padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
                                        child: Row(
                                          children: [
                                            Text("Guardar", style: TextStyle(fontSize: 16, color: AppTheme.colorAccent, fontWeight: FontWeight.w700),),
                                          ],
                                        )
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  @override
  userImage(File? _image) {
    controller.changeImage(_image);
  }

}