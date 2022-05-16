import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:padre_mentor/src/app/page/home/home_router.dart';
import 'package:padre_mentor/src/app/page/login/login_controller.dart';
import 'package:padre_mentor/src/app/utils/app_column_count.dart';
import 'package:padre_mentor/src/app/utils/app_icon.dart';
import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/widgets/ars_progress.dart';
import 'package:padre_mentor/src/data/repositories/moor/data_usuario_configuracion_respository.dart';
import 'package:padre_mentor/src/device/repositories/http/device_http_datos_repository.dart';

class LoginView3 extends View{
  @override
  _LoginViewState createState() => _LoginViewState();

}

class _LoginViewState extends ViewState<LoginView3, LoginController>{
  // Initially password is obscure
  late final formKey = new GlobalKey<FormState>();
  String? email, password;


  //Color greenColor = AppTheme.colorDocenteMentor;
  //Color greenColor = AppTheme.colorPrimaryDark;
  //Color greenColor = Color(0xFF00AF19);

  bool isLargeScreen  = false;

  _LoginViewState() : super(LoginController(DeviceHttpDatosRepositorio(), DataUsuarioAndRepository()));

  @override
  Widget get view =>  Container(
      color: AppTheme.nearlyWhite,
    child: ControlledWidgetBuilder<LoginController>(
        builder: (context, controller) {

          if((controller.mensaje??"").isNotEmpty){
            Fluttertoast.showToast(
              msg: controller.mensaje!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
            );
            controller.successMsg();
          }

          if(controller.dismis){
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              // fetch data
              HomeRouter.createRouteHomeRemoveAll(context);
            });

          }

          double size = MediaQuery.of(context).size.width;
          if (MediaQuery.of(context).size.width > 600 && ColumnCountProvider.isTablet(MediaQuery.of(context))) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }

          return Scaffold(
              body: Container(

                child: Row(
                  children: [
                    isLargeScreen?
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Center(
                                child:  Text('Contenidos organizados para\nuna enseñanza de calidad',
                                    style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 24) ,
                                        height: ColumnCountProvider.aspectRatioForWidthLogin(context, 1.5),
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.white
                                    )
                                ),
                              ),
                              SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)),
                              SvgPicture.asset(
                                AppIcon.ic_login_banner_1,
                                width: ColumnCountProvider.aspectRatioForWidthLogin(context, 200),
                                height: ColumnCountProvider.aspectRatioForWidthLogin(context, 200),
                              ),
                            ],
                          ),
                        )
                    ):Container(),
                    Expanded(
                        flex: 1,
                        child:  Container(
                          color: ColumnCountProvider.isTablet(MediaQuery.of(context)) ?null:AppTheme.white,
                          child: Stack(
                            children: [
                              ListView(
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Stack(
                                    children: [
                                      ColumnCountProvider.isTablet(MediaQuery.of(context))?
                                      Container():
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child:  Container(
                                            height: MediaQuery.of(context).size.height/0.5,
                                            width: MediaQuery.of(context).size.width/0.5,
                                            child: Transform.rotate(
                                              angle: -0.9,
                                              child: Container(
                                                child: Lottie.asset(ChangeAppTheme.splahLottieLoginBanner()),
                                              ),
                                            ),
                                          )
                                      ),
                                      Container(
                                          height: MediaQuery.of(context).size.height,
                                          width: MediaQuery.of(context).size.width,
                                          child: Form(key: formKey, child: _buildLoginForm(controller))),
                                    ],
                                  )
                                ],
                              ),
                              if(controller.progress||controller.progressData)
                                ArsProgressWidget(
                                  blur: 2,
                                  backgroundColor: Color(0x33000000),
                                  animationDuration: Duration(milliseconds: 500),
                                ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              )
          );
        })
  );

  _buildLoginForm(LoginController controller) {
    return Container(
        child: Center(
          child: Container(
            //width: double.infinity,
            decoration: ColumnCountProvider.isTablet(MediaQuery.of(context))?BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.all( Radius.circular(ColumnCountProvider.aspectRatioForWidthLogin(context, 32))
                )
            ):null,
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: ColumnCountProvider.aspectRatioForWidthLogin(context, 400)
              ),
              padding: EdgeInsets.only(
                  left: ColumnCountProvider.aspectRatioForWidthLogin(context, 25),
                  right: ColumnCountProvider.aspectRatioForWidthLogin(context, 25)
              ),
              child:  Theme(
                data:Theme.of(context).copyWith(
                  colorScheme: ThemeData().colorScheme.copyWith(
                    primary: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA,
                  ),
                ),
                child:  ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                          height: ColumnCountProvider.aspectRatioForWidthLogin(context, 60)
                      ),
                      Container(
                          height: ColumnCountProvider.aspectRatioForWidthLogin(context, 135),
                          width: ColumnCountProvider.aspectRatioForWidthLogin(context, 350),
                          child: Stack(
                            children: [
                              ChangeAppTheme.getApp() == App.EDUCAR?
                              Container(
                                child: Image.asset(
                                  AppIcon.login_educar,
                                ),
                                padding: EdgeInsets.only(bottom: 26, top: 14),
                              ):
                              Container(
                                child: Image.asset(
                                  AppIcon.login_icrm,
                                ),
                                padding: EdgeInsets.only(bottom: 26, top: 20),
                              ),
                              Positioned(
                                  top: ColumnCountProvider.aspectRatioForWidthLogin(context, 115),
                                  child: Column(
                                    children: [
                                      Text(ChangeAppTheme.getApp() == App.EDUCAR?'Centro de Aprendizaje Virtual':'Social iCRM Educativo Móvil',
                                          style:
                                          TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 16),
                                              fontWeight: FontWeight.w700,
                                              color: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA//AppTheme.lightBlueDarken1
                                          )
                                      ),
                                    ],
                                  )
                              ),

                            ],
                          )),
                      SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 25)),
                      if(controller.typeView==LoginTypeView.USUARIO)
                        TextFormField(
                            key: Key("Usuario"),
                            initialValue: controller.usuario,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms
                            ),
                            decoration: InputDecoration(
                                labelText: 'USUARIO',
                                labelStyle: TextStyle(
                                    fontFamily: AppTheme.fontTTrueno,
                                    fontSize:  ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                    color: AppTheme.grey.withOpacity(0.5)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA),
                                )),
                            onChanged: (value) {
                              controller.onChangeUsuario(value);
                            },
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                            (value??"").isEmpty ? 'Ingrese un usuario' : validateEmail(value??"")

                        ),
                      if(controller.typeView==LoginTypeView.USUARIO)
                        TextFormField(
                            key: Key("Password"),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (term){
                              if(checkFields()) controller.onClickInciarSesion();
                            },
                            initialValue: controller.password,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms
                            ),
                            decoration: InputDecoration(
                              labelText: 'CONTRASEÑA',
                              labelStyle: TextStyle(
                                  fontFamily: AppTheme.fontTTrueno,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                  color: AppTheme.grey.withOpacity(0.5)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA),
                              ),
                              suffixIcon: IconButton(
                                icon: Container(
                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthLogin(context, 14)),
                                  child: Icon(controller.ocultarContrasenia
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                    size: ColumnCountProvider.aspectRatioForWidthLogin(context, 20),
                                  ),
                                ),
                                onPressed: (){
                                  controller.onClikMostarContrasenia();
                                },
                              ),
                            ),
                            obscureText: controller.ocultarContrasenia,
                            onChanged: (value) {
                              controller.onChangeContrasenia(value);
                            },
                            validator: (value) => (value??"").isEmpty ? 'Ingrese una contraseña' : null
                        ),
                      if(controller.typeView==LoginTypeView.DNI)
                        TextFormField(
                            key: Key("DNI"),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (term){
                              if(checkFields()) controller.onClickInciarSesion();
                            },
                            initialValue: controller.dni,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms
                            ),
                            decoration: InputDecoration(
                                labelText: 'Documento de identidad'.toUpperCase(),
                                labelStyle: TextStyle(
                                    fontFamily: AppTheme.fontTTrueno,
                                    fontSize:  ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                    color: AppTheme.grey.withOpacity(0.5)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA),
                                )),
                            onChanged: (value) {
                              controller.onChangeDni(value);
                            },
                            validator: (value) => (value??"").isEmpty ? 'Ingrese un documento de identidad' : null
                        ),
                      if(controller.typeView==LoginTypeView.CORREO)
                        TextFormField(
                            key: Key("Correo"),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (term){
                              if(checkFields()) controller.onClickInciarSesion();
                            },
                            initialValue: controller.dni,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms
                            ),
                            decoration: InputDecoration(
                                labelText: 'Correo'.toUpperCase(),
                                labelStyle: TextStyle(
                                    fontFamily: AppTheme.fontTTrueno,
                                    fontSize:  ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                    color: AppTheme.grey.withOpacity(0.5)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA),
                                )),
                            onChanged: (value) {
                              controller.onChangeCorreo(value);
                            },
                            validator: (value) => (value??"").isEmpty ? 'Ingrese un correo' : null
                        ),
                      SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 5)),
                      controller.typeView==LoginTypeView.USUARIO?
                      GestureDetector(
                          onTap: () {
                            /* Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ResetPassword()));*/
                          },
                          child: Container(
                              alignment: Alignment(1.0, 0.0),
                              padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthLogin(context, 15),
                                  left: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)
                              ),
                              child: InkWell(
                                  child: Text(/*'Has olvidado tu contraseña'*/"Uso exclusivo de los padres",
                                      style: TextStyle(
                                        color: AppTheme.colorPrimary,
                                        fontFamily: AppTheme.fontTTrueno,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 11),
                                        //decoration: TextDecoration.underline
                                      )
                                  )
                              )
                          )
                      ):
                      GestureDetector(
                          onTap: () {
                            controller.onClikAtrasLogin();
                          },
                          child: Container(
                              alignment: Alignment(1.0, 0.0),
                              padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthLogin(context, 15),
                                  left: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)
                              ),
                              child: InkWell(
                                  child: Text(controller.typeView==LoginTypeView.DNI?'Corregir usuario y contraseña':'Corregir el documento de identidad',
                                      style: TextStyle(
                                          color: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA,
                                          fontFamily: AppTheme.fontTTrueno,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 11),
                                          decoration: TextDecoration.underline
                                      )
                                  )
                              )
                          )
                      ),
                      SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 50)),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          if(checkFields()) controller.onClickInciarSesion();
                        },
                        child: Container(
                            height: ColumnCountProvider.aspectRatioForWidthLogin(context, 50),
                            child: Material(
                                borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthLogin(context, 25)),
                                shadowColor: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA,
                                color: ChangeAppTheme.getApp() == App.EDUCAR?AppTheme.colorEducarStudent:AppTheme.colorEVA,
                                elevation: 7.0,
                                child: Center(
                                    child: Text('INICIAR SESIÓN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: AppTheme.fontTTrueno,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 14)
                                        )
                                    )
                                )
                            )
                        ),
                      ),
                      SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)),
                      /*GestureDetector(
            onTap: () {
              //AuthService().fbSignIn();
            },
            child: Container(
                height: 50.0,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: ImageIcon(AssetImage('assets/images/facebook.png'),//../Images/Inicio/logoiCRM.png
                              size: 15.0)),
                      SizedBox(width: 10.0),
                      Center(
                          child: Text('Login with facebook',
                              style: TextStyle(fontFamily: AppTheme.fontTTrueno))),
                    ],
                  ),
                )),
          ),
          SizedBox(height: 25.0),*/
                      /*
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Nuevo en iCRM ?'),
                      SizedBox(width: ColumnCountProvider.aspectRatioForWidthLogin(context, 5)),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => SignupPage()));
                          },
                          child: Text('Registrarse',
                              style: TextStyle(
                                  color: greenColor,
                                  fontFamily: AppTheme.fontTTrueno,
                                  decoration: TextDecoration.underline)))
                    ]),*/
                      SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 30)),
                      Row(
                        children: [
                          _educarLogo(ColumnCountProvider.aspectRatioForWidthLogin(context, 45), ColumnCountProvider.aspectRatioForWidthLogin(context, 135)),
                          Expanded(child: Container()),
                        ],
                      ),
                      SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 50)),
                    ]
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget _educarLogo(double? height, double? width){
    return Image.asset(AppIcon.logo_ICRM,
      fit: BoxFit.cover,
      colorBlendMode: BlendMode.modulate,
      height: height,
      width: width,
    );
  }



  //To Validate email
  String? validateEmail(String value) {
    /*String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value??""))
      return 'Enter Valid Email';
    else
      return null;*/
    if(value.length < 3){
      return 'Ingrese un usuario valido';
    }else{
      return  null;
    }
  }

  checkFields() {
    final form = formKey.currentState;
    if (form?.validate()??false) {
      form?.save();
      return true;
    }
    return false;
  }

}